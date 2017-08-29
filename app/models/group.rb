class Group < ApplicationRecord
  has_many :group_permissions
  has_many :users, -> {distinct}, through: :group_permissions
  has_many :group_vote_proposals
  has_many :vote_proposals, -> {distinct}, through: :group_vote_proposals
  has_many :circles, inverse_of: :group
end
