class CirclesController < ApplicationController

  def index
    @circles = Circle.all.paginate(:page => params[:page], :per_page => 10)
    @groups = current_or_guest_user.cached_groups    
  end

  def show
    circle_id = params.require(:circle_id)
    @circle = Circle.find(circle_id)

    par_pub = {:page => params[:published_page], :per_page => 10}
    par_unpub = {:page => params[:unpublished_page], :per_page => 10}
    @vote_proposals_published = @circle.vote_proposals.published.paginate(par_pub)
    @vote_proposals_unpublished = @circle.vote_proposals.unpublished.paginate(par_unpub)
  end

  def create
    circle_params = params.require(:circle).permit(:name, :group_id)

    # NOTE: Circles are published currently immediately. In future work
    # user needs to be authorized to be able to publish a new circle.
    circle_params[:published_at] = Time.now
    
    circle = Circle.new(circle_params)

    if circle.valid?
      circle.save
      flash[:success] = t("Circle has been added")
      redirect_to circle_path(circle.id)
    else
      redirect_to circles_path
    end
  end
  
end
