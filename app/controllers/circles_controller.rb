class CirclesController < ApplicationController

  def index
    @circles = Circle.all.paginate(:page => params[:page], :per_page => 10)
    @groups = current_or_guest_user.cached_groups    
  end

  def show
    circle_id = params.require(:circle_id)
    @circle = Circle.find(circle_id)
    @vote_proposals = @circle.vote_proposals.paginate(:page => params[:page], :per_page => 10)
  end

  def create
    circle_params = params.require(:circle).permit(:name, :group_id)
    circle = Circle.new(circle_params)

    if circle.valid?
      circle.save
      redirect_to circle_path(circle.id)
    else
      # flash[:error] <= kuinkas default error
      redirect_to circles_path
    end
  end
  
end
