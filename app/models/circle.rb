class Circle < ApplicationRecord
  belongs_to :parent, :class_name => "Circle", required: false, inverse_of: :circle
  has_one :circle, :class_name => "Circle", inverse_of: :parent
  belongs_to :group, required: false, inverse_of: :circles
  has_many :vote_proposals, inverse_of: :circle
end
