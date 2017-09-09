class MandateUser < ApplicationRecord
  belongs_to :mandate_from, class_name: "User"
  belongs_to :user
  belongs_to :circle, required: false
end

