class VoteProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @vote_proposals = VoteProposal.paginate(:page => params[:page], :per_page => 4)
  end

  def show
    if !params[:id] || params[:id].to_i < 0
      redirect_to :root
      return
    end
    @current = VoteProposal.find(params[:id])
    @next = params[:next] if params[:next] || params[:next].to_i > 0
    @prev = params[:prev] if params[:prev] || params[:prev].to_i > 0
    if current_user
      @vote = current_user.votes.where(vote_proposal_id: @current.id).first
    end
  end
end
