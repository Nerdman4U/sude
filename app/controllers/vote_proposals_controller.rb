class VoteProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @vote_proposals = VoteProposal.paginate(:page => params[:page], :per_page => 2)
  end

  def show
  end
end
