class VoteProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def create
    proposal_params = params.require(:vote_proposal).permit(:topic, :description, :circle_id, vote_proposal_option_ids: [])
    proposal = VoteProposal.new(proposal_params)
    if proposal.valid?
      proposal.save
      flash[:notice] = t("Vote proposal has been added")
      redirect_to preview_vote_proposal_path(proposal)
    else
      redirect_to circles_path
    end
  end

  def new
    circle_id = params[:circle_id]
    @circle = Circle.find(circle_id)    
  end

  # TODO: CHECK PERMISSIONS
  # TODO: CACHE
  # - JSON api is very heavy and needs to be cached
  def index
    group_id = params[:group_id]

    if group_id # group = current_or_guest_user.has_permission(group_id)
      @group = Group.find(group_id)
      @vote_proposals = VoteProposal.includes({vote_proposal_vote_proposal_options: [:vote_proposal_option]}, :vote_proposal_options).in_permitted_group(current_or_guest_user, @group).paginate(:page => params[:page], :per_page => 10)
    else
      @vote_proposals = VoteProposal.includes({vote_proposal_vote_proposal_options: [:vote_proposal_option]}, :vote_proposal_options).global.paginate(:page => params[:page], :per_page => 10)    
    end

    @groups = current_or_guest_user.groups

    # {:vote_proposal_id => <VOTE>}
    @votes = {}
    # Add current_user vote to eah
    @vote_proposals.each do |vp|
      vote = current_or_guest_user.vote_in_proposal(vp)
      @votes[vp.id] = vote if vote
    end

    respond_to do |format|
      format.html {
        session_handler.set(:proposals, @vote_proposals.map(&:id))
      }
      format.json {
        render json: @vote_proposals, include: [:vote_proposal_options, :circle, :vote_proposal_vote_proposal_options]
      }
    end
  end

  def preview
    record_id = params.require(:id)    
    if record_id.blank?
      redirect_to :root
      return
    end

    @options = VoteProposalOption.preview_options
    @current = VoteProposal.friendly.find(record_id)

    if @current.published?
      redirect_to vote_proposal_path(@current)
      return
    end
    
    @vote = current_or_guest_user.votes.where(vote_proposal_id: @current.id).first

    preview_votes = @current.votes.where(status: "preview")
    @accept_count = preview_votes.where(selected_options: "Accept").count
    @decline_count = preview_votes.where(selected_options: "Decline").count
  end
  
  def show
    record_id = params.require(:id)    
    if record_id.blank?
      redirect_to :root
      return
    end

    @current = VoteProposal.friendly.find(record_id)
    @vote = current_or_guest_user.vote_in_proposal(@current)
    
    session_handler.set([:proposals, :current], @current.id)    
    @next = next_proposal_from_session
    @prev = previous_proposal_from_session    
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
    return unless ids.is_a? Array
    return if ids.blank?
    return unless current
    current_ind = ids.index(current)
    return if current_ind.blank?
    next_id = current_ind + 1
    next_id = 0 if next_id >= ids.count 
    VoteProposal.find(ids[next_id]) rescue nil
  end
  def previous_proposal_from_session
    ids = proposal_ids_from_session
    current = current_proposal_from_session
    return unless ids.is_a? Array
    return if ids.blank?
    return unless current
    current_ind = ids.index(current)
    return if current_ind.blank?
    prev_id = current_ind - 1
    prev_id = ids.count-1 if prev_id < 0
    VoteProposal.find(ids[prev_id]) rescue nil
  end
  
end
