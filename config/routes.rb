Rails.application.routes.draw do

  root to: redirect("/fi"), as: "root"
  
  localized do
    get "/", to: 'vote_proposals#index', as: "vote_proposals"
    get "/circles", to: 'circles#index', as: "circles"
    post "/circles", to: "circles#create", as: "create_circle"
    get "/circles/:circle_id", to:"circles#show", as: "circle"
    get "/vote_proposals", to: 'vote_proposals#index'
    get "/vote_proposals/:group_id", to: "vote_proposals#index", as: "vote_proposals_with_group"
    get "/vote_proposals/show/:id", to: "vote_proposals#show", as: "vote_proposal"
    get '/user/:id/settings', to: "users#settings", as: "settings"
    get '/user/:id/history', to: "users#history", as: "history"
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
