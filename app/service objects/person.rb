class Person
  include ActiveModel::Model

  delegate :first_name, :last_name, :manager, to: :person
  delegate :effective_on, :parent, :furcate_identifier, :path, :children, to: :leaf

  def initialize(attributes)
    @person_content = PersonContent.new(attributes.slice(*person_content_attribute_keys))
    leaf_attributes = attributes.slice(*leaf_attribute_keys).merge(person_content: @person_content)
    @leaf = Leaf.new(leaf_attributes)
  end

  def self.create(attributes)
    Person.new(attributes).save
  end

  def update(attributes)

    person_content_attributes = @person_content.attributes.except(:id)
    person_content_attributes = person_content_attributes
                                  .slice(*person_content_attribute_keys)
                                  .merge(attributes.slice(*person_content_attribute_keys))
    @person_content = PersonContent.new(person_content_attributes)

    leaf_attributes = @leaf.attributes.except(:id)
    leaf_attributes = leaf_attributes
                        .slice(*leaf_attribute_keys)
                        .merge(person_content: @person_content)
                        .merge(attributes.slice(*leaf_attribute_keys))
    @leaf = Leaf.new(leaf_attributes)
    save
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

  def leaf_attribute_keys
    [:effective_on, :furcate_identifier]
  end

  def person_content_attribute_keys
    [:first_name, :last_name, :manager]
  end
end
