if Rails.env.development?
  # letter_opener_webのコントローラーを拡張
  LetterOpenerWeb.configure do |config|
    config.letters_location = Rails.root.join('tmp', 'letter_opener')
  end
  
  # CSRF保護を無効化
  Rails.application.config.after_initialize do
    if defined?(LetterOpenerWeb)
      LetterOpenerWeb::Engine.routes.draw do
        # ルートを再定義してCSRF保護を無効化
        scope module: 'letter_opener_web' do
          resources :letters, only: [:index, :show, :destroy] do
            delete :clear, on: :collection
          end
        end
      end
      
      # コントローラーのCSRF保護を無効化
      LetterOpenerWeb::LettersController.class_eval do
        skip_forgery_protection
      end
    end
  end
end