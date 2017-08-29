class CirclesController < ApplicationController

  def index
  end

  def new
  end

  def show
  end

  def create
    circle_params = params.require(:circle).permit(:name)
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
