Rails.application.routes.draw do
  root to: redirect("/fi"), as: "root"
  localized do
    get '/', to: "votes#index"
    get '/instruction', to: "democracy#instruction"
    devise_for :users
  end
end
