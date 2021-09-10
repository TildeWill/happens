class Person
  include ActiveModel::Model

  delegate :first_name, :last_name, to: :person_content
  delegate :effective_date, :parent, :furcate_identifier, :path, :children, to: :leaf

  def initialize(attributes)
    @person_content = PersonContent.new(build_person_content_attributes(attributes))
    @leaf = Leaf.new(build_leaf_attributes(attributes))
  end

  def self.create(attributes)
    Person.new(attributes).save
  end

  def update(new_attributes)
    @person_content = PersonContent.new(build_person_content_attributes(new_attributes))
    @leaf = Leaf.new(build_leaf_attributes(new_attributes))
    save
  end

  def self.find_for(effective_date)
    leaves = Leaf
               .eager_load(:person_content)
               .select(:effective_date, :furcate_identifier, :ancestry, :person_content_id)
               .order(effective_date: :desc, created_at: :desc)
               .where("effective_date <= ?", effective_date)
               .group_by(&:furcate_identifier)
               .values.map(&:first)
  end

  def save
    new_parent = Leaf.where("effective_date <= ?", @leaf.effective_date).order(effective_date: :desc, created_at: :desc).first
    if new_parent
      @leaf.parent = new_parent
    else
      root = Leaf.first&.root
      if root
        root.parent = @leaf
        root.save
      end
    end
    @leaf.save

    if new_parent
      new_parent.children.each do |child|
        child.parent = @leaf
        child.save
      end
    end

    self
  end


  private
  attr_accessor :person_content
  attr_accessor :leaf

  def build_leaf_attributes(new_attributes)
    {
      effective_date: new_attributes[:effective_date] || @leaf&.effective_date,
      furcate_identifier: new_attributes[:furcate_identifier] || @leaf&.furcate_identifier,
      person_content: @person_content
    }
  end

  def build_person_content_attributes(new_attributes)
    {
      first_name: new_attributes[:first_name] || @person_content&.first_name,
      last_name: new_attributes[:last_name] || @person_content&.last_name,
      manager: new_attributes[:manager].instance_variable_get(:@manager) || @person_content&.manager
    }
  end
end
