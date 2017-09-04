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

    proposal = VoteProposal.find(vote_params[:vote_proposal_id])

    vote_params[:status] = "preview" unless proposal.published?

    # NOTE: Vote.create(vote_params) does not work, for some reason
    # vote.user is blank and because of that vote.valid? is false and
    # because of that updating counters fails
    # TODO: Insert vote with counters with one save
    # vote = Vote.create(vote_params)

    option_ids = vote_params.delete(:vote_proposal_option_ids)
    vote = Vote.create(vote_params)
    vote.update_attributes(vote_proposal_option_ids: option_ids) # triggers callbacks
    
    # Check if this proposal is unpublished and if it has enough votes
    # to be public.
    proposal.send(:check_publication_status)
    
    redirect_back(fallback_location: vote_proposal_path(proposal))
  end

  def update
    vote_id = params.require(:id)

    vote_params = params.require(:vote).
                  permit(vote_proposal_options_attributes: [:id, :_destroy])
    if vote_params.blank?
      vote_params = params.require(:vote).
                    permit(vote_proposal_option_ids: [])
    end

    vote = Vote.where({
                        id: vote_id,
                        user_id: current_or_guest_user.id
                      }).first

    vote.modify_params! vote_params
    vote.update_attributes(vote_params)

    # NOTE: this save is needed to vote.defaults_before_save work
    # correctly and reset selected_options string. When
    # update_attributes (above) is called, before_save is called before
    # vote_proposal_options are removed.
    vote.save

    vote.vote_proposal.send(:check_publication_status)
    
    redirect_back(fallback_location: vote_proposal_path(vote.vote_proposal))
  end

end
