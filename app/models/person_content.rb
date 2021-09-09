class PersonContent < ApplicationRecord
  has_one :leaf
  belongs_to :manager, class_name: "PersonContent", optional: true
end
