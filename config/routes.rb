Rails.application.routes.draw do
  get "help_magics/new"
  get "help_magics/create"
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
  resources :statuses, only: %i[new create edit update destroy] do
    collection do
      get :new_schedule
      post :create_schedule
      get :complete
    end
    resources :status_histories, only: %i[index]
  end

  resources :tasks do
    member do
      post :add_helper  # ヘルパーをタスクに追加
    end

    collection do
      get :help_requests
    end
  end

  resources :help_requests, only: [:show] do
    member do
      patch :update_status  # ステータス更新用のルーティング
      post  :apply
      post :complete_notify
    end
  end

  resources :help_magics, only: [:new, :create]

  # ヘルパー選択後のタスク選択画面用
  resources :helpers, only: [] do
    member do
      get :select_task  # このヘルパーに依頼するタスクを選択
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    
    # CSRF保護を無効化
    LetterOpenerWeb::Engine.config.action_controller.default_protect_from_forgery = false
  end
end
