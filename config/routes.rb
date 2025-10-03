Rails.application.routes.draw do
  root "slides#new"

  # 세션 기반 슬라이드 미리보기 (resources보다 먼저 정의)
  get "slides/current", to: "slides#show", as: :current_slide
  patch "slides/current", to: "slides#update", as: :update_current_slide

  resources :slides, only: [ :new, :create, :show, :update ], constraints: { id: /[0-9]+/ }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
