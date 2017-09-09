# coding: utf-8
require Rails.root.join("lib/checkout.rb")

class UsersController < ApplicationController
  before_action :authenticate_user!

  def give_mandate
    mandate_to_id = params.require(:mandate_to_id)
    mandate_to = User.find(mandate_to_id)
    current_user.give_mandate(mandate_to)

    redirect_back(fallback_location: settings_path)
  end

  def remove_mandate
    mandate_from_id = params.require(:mandate_from_id)
    mandate_from = User.find(mandate_from_id)
    current_user.remove_mandate(mandate_from)
    
    redirect_back(fallback_location: settings_path)
  end

  def settings
    @users = User.where(confirmed: 1).paginate(page: params[:page], per_page: 10)
    @given_mandates = current_user.mandates_to
  end

  def history
    @history = current_or_guest_user.user_histories.order(created_at: :desc).paginate(page: params[:page], per_page: 10)    
  end
  
end
