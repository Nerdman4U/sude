# coding: utf-8
class VotesController < ApplicationController

  # Create new vote.
  #
  # If user has a vote for this proposal, update instead.
  def create
    # Käyttöoikeus tarkistukset puuttuvat

    vote_params = params.require(:vote).
                  permit(:vote_proposal_id,
                         vote_proposal_option_ids: [])
    vote_params.merge!({user_id: current_or_guest_user.id})

    Vote.create(vote_params)
    
  end

  def update
    proposal_id = params.require(:vote).require(:vote_proposal_id)
    vote_params = params.require(:vote).
                  permit(vote_proposal_option_ids: [])

    vote = Vote.where({user_id: current_or_guest_user.id,
                       vote_proposal_id: proposal_id}
                     ).first
    vote.update_attributes(vote_params)
  end

end
