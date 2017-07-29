class VotesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    if user_signed_in?
    else
    end

  end
end
