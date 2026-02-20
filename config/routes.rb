Rails.application.routes.draw do
  get "static_pages/top"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "static_pages#top"

  get "dashboard", to: "dashboard#show"

  # ユーザー登録
  resources :users, only: %i[new create index] do
    patch :read_total_virtue_points, on: :collection
  end

  # ログイン・ログアウト(後で実装)
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  # ステータス関連
  resources :statuses, only: %i[index new create edit update destroy] do
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

  resources :help_requests, only: %i[index show] do
    member do
      patch :update_status  # ステータス更新用のルーティング
      post  :apply
      get  :complete_form
      post :complete_notify
    end

    resource :chat, only: [ :show, :create ], controller: "chats"
  end

  resource :help_magic, only: %i[new create edit update destroy]

  # ヘルパー選択後のタスク選択画面用
  resources :helpers, only: [] do
    collection do
      get :helping  # /helpers/helping
    end

    member do
      get :select_task  # このヘルパーに依頼するタスクを選択
    end
  end

  namespace :settings do
    get "email_confirmations/show"
    resource :profile, only: %i[show edit update]
    resource :password, only: %i[edit update]
    resource :email, only: %i[edit update]

    get "email/confirm", to: "email_confirmations#show", as: :email_confirm
  end

  namespace :admin do
    root to: "dashboard#show"

    resources :users, only: %i[index edit update destroy] do
      member do
        get  :edit_password
        patch :update_password

        get :edit_email
        patch :update_email
      end
    end

    resources :tasks, only: %i[index edit update destroy]
    resources :personality_tags, only: %i[index new create edit update destroy]
  end

  namespace :manager do
    get "staff_conditions/index"
    resources :staff_conditions, only: [ :index ]
  end

  resources :introductions, only: [ :show, :edit, :update ]

  resource :ranking, only: [ :show ]

  resources :password_resets, only: %i[new create edit update]

  get "guide", to: "guides#show", as: :guide

  resources :notifications, only: [ :index, :show ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"

    # CSRF保護を無効化
    LetterOpenerWeb::Engine.config.action_controller.default_protect_from_forgery = false
  end
end
