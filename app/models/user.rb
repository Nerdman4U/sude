class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :votes
  has_many :user_vote_proposals
  has_many :vote_proposals, through: :user_vote_proposals
  enum status: [:active, :disabled, :removed]

  after_initialize :defaults_for_new

  def defaults_for_new
    self.status = 0
  end

  # This method does the voting
  #
  # Params: proposal  VoteProposal object
  #         values    An array of VoteProposalOption objects
  # Returns: Vote object (valid or not)
  #
  def vote proposal, values
    return unless proposal
    return unless proposal.is_a?(VoteProposal)
    return if values.blank?
    values = [values] if values.is_a?(VoteProposalOption)
    # values = values.filter.map {|v| !v.is_a?(VoteProposal)}
    Vote.create({
                  user: self,
                  vote_proposal: proposal,
                  vote_proposal_options: values
                })
  end
end


