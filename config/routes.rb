require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web, at: '/sidekiq'
  apipie

  root to: 'misc#ping'

  match 'beta_welcome_email', to: 'mails_viewer#welcome_email', via: :get

  resources :beta_requesters, except: 'index' do
    get :confirm_request, on: :member, param: :confirmation_token
  end

  resources :invites
  resources :tags

  resources :projects do
    get :project_names, on: :collection
    post :set_status, on: :member
    post :add_team_member, on: :member
    post :remove_team_member, on: :member
    post :archive, on: :member
    post :upload_artboard_or_slice, on: :member

    resources :activities, only: %i(index create)
    resources :implemented_screens

    resources :styleguides, only: %i(show destroy) do
      post :add_color, on: :member
      post :add_font, on: :member
    end

    resources :artboards, only: %i(destroy) do
      resources :notes do
        resources :note_replies, except: %i(index show)
      end
      resources :links

      post :set_due_date, on: :member
      post :set_status, on: :member
      post :add_assignee, on: :member
    end
  end

  mount_devise_token_auth_for 'User', at: 'auth',
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    resources :notification_settings, only: %i(show update)
  end

  post '/profile/update_avatar', to: 'profile#update_avatar'

end
