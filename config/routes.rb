Rails.application.routes.draw do
  get "static_pages/top"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root 'static_pages#top'

  # ユーザー登録
  resources :users, only: %i[new create index]

  # ログイン・ログアウト(後で実装)
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # ステータス関連
  resources :statuses, only: [:new, :create, :edit, :update, :destroy]
end
