Rails.application.routes.draw do
  get '/', to: redirect("/fi"), as: "root"
  localized do
    get '/', to: "votes#index"
    get '/instruction', to: "democracy#instruction"
  end
end
