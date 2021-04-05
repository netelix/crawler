Rails
  .application
  .routes
  .draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root to: 'application#index'

    devise_for :users,
               controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations',
                 passwords: 'users/passwords'
               }

    devise_scope :user do
      get 'login', to: 'users/sessions#new', as: 'login'
      post 'login', to: 'users/sessions#create'
      get 'signup', to: 'users/registrations#new', as: 'new_user'
    end

    require 'sidekiq/web'
    if Rails.env.production?
      Sidekiq::Web.use Rack::Auth::Basic do |username, password|
        # Protect against timing attacks:
        # - See https://codahale.com/a-lesson-in-timing-attacks/
        # - See https://thisdata.com/blog/timing-attacks-against-string-comparison
        # - Use & (do not use &&) so that it doesn't short circuit.
        # - Use digests to stop length information leaking
        #   (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(username),
          ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])
        ) &
          ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(password),
            ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
          )
      end
    end
    mount Sidekiq::Web => '/sidekiq'

    namespace :admin do
      get '/', to: 'application#index', as: :index

      resources :hosts do
        collection do
          get :new_crawl
          post :start_crawl
        end
        member { post :start_linked_hosts_crawl }
      end

      resources :pages
    end
  end
