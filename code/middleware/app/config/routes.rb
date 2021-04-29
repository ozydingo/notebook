Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/ping", to: "pings#ping"
  post "/ping", to: "pings#ping"

  mount ABigStick.new, at: "/abigstick", as: "abigstick"

  mount MiddleView::MiddleView.new, at: "/view", as: "view"
  mount Rerackt::UI.new, at: "/rerackt", as: "rerackt"
end
