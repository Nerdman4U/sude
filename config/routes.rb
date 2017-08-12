Rails.application.routes.draw do

  root to: redirect("/fi"), as: "root"
  localized do
    get "/", to: 'vote_proposals#index', as: "vote_proposals"
    # get "vote_proposals/show/:id/(:next)/(:prev)", to: "vote_proposals#show", as: "vote_proposal"
    get "vote_proposals/show/:id", to: "vote_proposals#show", as: "vote_proposal"
    get '/instruction', to: "democracy#instruction", as: "instruction"
    get '/confirm', to: "democracy#confirm", as: "confirm"
    devise_for :users
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end

  get "/democracy/checkout/success", to: "democracy#checkout_success", as: :success_callback
  get "/democracy/checkout/cancel", to: "democracy#checkout_cancel", as: :cancel_callback
  get "/democracy/checkout/reject", to: "democracy#checkout_reject", as: :reject_callback
  get "/democracy/checkout/delayed", to: "democracy#checkout_delayed", as: :delayed_callback

  post "/votes", to: "votes#create", as: "create_vote"
  put "/votes/:id", to: "votes#update", as: "update_vote"
end
