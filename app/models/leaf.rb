class Leaf < ApplicationRecord
  belongs_to :person_content
  has_ancestry
end
