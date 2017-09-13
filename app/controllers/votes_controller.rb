# coding: utf-8
class VotesController < ApplicationController

  # Create new vote
  #
  # Selected vote proposal options come to this action one at a time.
  #
  # Examples:
  # {vote: {vote_proposal_id: 1, vote_proposal_options_attributes: [{id:1}]}}
  # {vote: {vote_proposal_id: 1, vote_proposal_options_attributes: [{id:1, _destroy: true}]}}
  #
  # Options from the previous vote must be included to new vote.
  #
  # TODO: Käyttöoikeus tarkistukset puuttuvat
  def create
    vote_params = params.require(:vote).
                  permit(:vote_proposal_id, vote_proposal_option_ids: [])

    proposal = VoteProposal.find(vote_params.delete :vote_proposal_id)
    option_ids = vote_params.delete(:vote_proposal_option_ids)

    # Params contains only one option
    option = VoteProposalOption.find(option_ids.first)

    if proposal.published?
      current_or_guest_user.vote(proposal, option)
    else
      current_or_guest_user.preview_vote(proposal, option)
    end

    # Decrease counter of removed option
    
    # NOTE: Vote.create(vote_params) does not work, for some reason
    # vote.user is blank and because of that vote.valid? is false and
    # because of that updating counters fails
    # TODO: Insert vote with counters with one save
    # vote = Vote.create(vote_params)
    #option_ids = vote_params.delete(:vote_proposal_option_ids)
    #vote = Vote.create(vote_params)
    #vote.update_attributes(vote_proposal_option_ids: option_ids) # triggers callbacks
    
    # Check if this proposal is unpublished and if it has enough votes
    # to be public.
    proposal.publish


    respond_to do |format|
      format.html {
        redirect_back(fallback_location: vote_proposal_path(proposal))
      }
      format.json {
        render json: proposal.find_counter_cache_record(option)
        return
      }
    end
  end

  # Update a vote.
  #
  # Parameters always contain only one vote option.
  def update
    vote_id = params.require(:id)
    vote_params = params.require(:vote).
                  permit(vote_proposal_options_attributes: [:id, :_destroy])
    if vote_params.blank?
      vote_params = params.require(:vote).permit(vote_proposal_option_ids: [])
    end
   
    if vote_params[:vote_proposal_options_attributes]
      id = vote_params[:vote_proposal_options_attributes][0][:id]
      action = :delete
    else
      id = vote_params[:vote_proposal_option_ids][0]
    end

    # Detect does not hit database.
    vote = current_or_guest_user.votes.detect {|vote| vote.id == vote_id.to_i }
    proposal = vote.vote_proposal
    option = proposal.vote_proposal_options.detect {|opt| opt.id ==  id.to_i }
    current_or_guest_user.vote proposal, option, action: action

    # vote.modify_params! vote_params
    # vote.update_attributes(vote_params)

    # # NOTE: this save is needed to vote.defaults_before_save work
    # # correctly and reset selected_options string. When
    # # update_attributes (above) is called, before_save is called before
    # # vote_proposal_options are removed.
    # vote.save

    proposal.publish

    respond_to do |format|
      format.html {
        redirect_back(fallback_location: vote_proposal_path(proposal))
      }
      format.json {
        data = proposal.find_counter_cache_record(option)
        render json: data
      }
    end
  end

  # # DEPRECATED
  # #
  # # We use object methods instead of nested attributes, this change was
  # # made when implementing mandate.
  # #
  # # Create new vote with nested attributes.
  # #
  # # If user has a vote for this proposal, update instead.
  # def create2
  #   # Käyttöoikeus tarkistukset puuttuvat

  #   vote_params = params.require(:vote).
  #                 permit(:vote_proposal_id,
  #                        vote_proposal_option_ids: [])
  #   vote_params.merge!({user_id: current_or_guest_user.id})

  #   proposal = VoteProposal.find(vote_params[:vote_proposal_id])

  #   vote_params[:status] = "preview" unless proposal.published?

  #   # NOTE: Vote.create(vote_params) does not work, for some reason
  #   # vote.user is blank and because of that vote.valid? is false and
  #   # because of that updating counters fails
  #   # TODO: Insert vote with counters with one save
  #   # vote = Vote.create(vote_params)

  #   option_ids = vote_params.delete(:vote_proposal_option_ids)
  #   vote = Vote.create(vote_params)
  #   vote.update_attributes(vote_proposal_option_ids: option_ids) # triggers callbacks
    
  #   # Check if this proposal is unpublished and if it has enough votes
  #   # to be public.
  #   proposal.send(:check_publication_status)
    
  #   redirect_back(fallback_location: vote_proposal_path(proposal))
  # end

  
end
