class VoteProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @vote_proposals = VoteProposal.paginate(:page => params[:page], :per_page => 10)    
    session_handler.set(:proposals, @vote_proposals.map(&:id))
  end

  def show
    if !params[:id] || params[:id].to_i < 0
      redirect_to :root
      return
    end

    @current = VoteProposal.find(params[:id])
    session_handler.set([:proposals, :current], @current.id)
    
    @next = next_proposal_from_session
    @prev = previous_proposal_from_session
    if current_or_guest_user
      @vote = current_or_guest_user.votes.where(vote_proposal_id: @current.id).first
    end
  end

  private

  def proposal_ids_from_session
    session_handler.get(:proposals)
  end
  def current_proposal_from_session
    session_handler.get([:proposals, :current])
  end
  def next_proposal_from_session
    ids = proposal_ids_from_session
    current = current_proposal_from_session
    return unless ids
    return unless ids.is_a? Array
    return unless current
    next_id = ids.index(current) + 1
    next_id = 0 if next_id >= ids.count 
    VoteProposal.find(ids[next_id]) rescue nil
  end
  def previous_proposal_from_session
    ids = proposal_ids_from_session
    current = current_proposal_from_session
    return unless ids
    return unless ids.is_a? Array
    return unless current
    prev_id = ids.index(current) - 1
    prev_id = ids.count-1 if prev_id < 0
    VoteProposal.find(ids[prev_id]) rescue nil
  end
  
end
