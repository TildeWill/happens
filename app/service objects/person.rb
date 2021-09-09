class Person
  include ActiveModel::Model

  delegate :first_name, :last_name, :manager, to: :person
  delegate :effective_on, :parent, :furcate_identifier, :path, to: :leaf

  def initialize(attributes)
    @person_content = PersonContent.new(attributes.slice(:first_name, :last_name, :manager))
    leaf_attributes = attributes.slice(:effective_on, :furcate_identifier).merge(person_content: @person_content)
    @leaf = Leaf.new(leaf_attributes)
  end

  def self.create(attributes)
    Person.new(attributes).save
  end

  def update(attributes)
    leaf_attributes = @leaf.attributes.except(:id)
    person_attributes = @person_content.attributes.except(:id)
    Person.new(person_attributes.merge(leaf_attributes).merge(attributes)).save
  end


  def save
    new_parent = Leaf.where("effective_on <= ?", @leaf.effective_on).order(effective_on: :desc).first #TODO: this will be a problem if multiple things are on the same date
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
  attr_accessor :person
  attr_accessor :leaf
end
