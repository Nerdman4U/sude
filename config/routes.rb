Rails.application.routes.draw do

  root to: redirect("/fi"), as: "root"
  localized do
    get "/", to: 'vote_proposals#index', as: "vote_proposals"
    # get '/', to: "votes#index", as: "votes"
    get '/instruction', to: "democracy#instruction", as: "instruction"
    get "vote_proposals/show/:id", to: "vote_proposals#show", as: "vote_proposal"
    devise_for :users
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
  end
end
