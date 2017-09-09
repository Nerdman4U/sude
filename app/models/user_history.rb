# UserHistory object is created everytime vote.vote_proposal_options are
# changed. When user votes first time and vote has one or more options
# UserHistory is created.
#
# When user changes his votes and selects different VoteProposalOption
# objects a new UserHistory is created for every Option. Every
# UserHistory as selected_action attribute to hold information if option
# was added or removed.
#
class UserHistory < ApplicationRecord
  has_many :user_user_histories
  has_many :users, through: :user_user_histories
  belongs_to :vote

  enum selected_action: [:add, :remove]
end
