class Leaf < ApplicationRecord
  belongs_to :person_content
  has_ancestry

  before_create :add_furcate_identifier

  def add_furcate_identifier
    self.furcate_identifier = SecureRandom.uuid unless self.furcate_identifier
  end
end
