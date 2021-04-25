Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/ping", to: "pings#ping"
  post "/ping", to: "pings#ping"

  mount MiddleView::MiddleView.new, at: "/view", as: "view"
end
