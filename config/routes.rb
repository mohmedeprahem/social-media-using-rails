require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      # Routes for AuthController
      post 'auth/signup', to: 'auth#signup'
      post 'auth/login', to: 'auth#login'

      # Routes for TagController
      get 'tags', to: 'tag#index'

      # Routes for PostController
      post 'posts', to: 'post#create'
      get 'posts', to: 'post#index'
      get 'posts/:id', to: 'post#show'
      patch 'posts/:id', to: 'post#update'
      delete 'posts/:id', to: 'post#destroy'

      # Routes for CommentController
      post 'posts/:post_id/comments', to: 'comment#create'
      get 'posts/:post_id/comments', to: 'comment#index'
      patch 'posts/:post_id/comments/:id', to: 'comment#update'
      delete 'posts/:post_id/comments/:id', to: 'comment#destroy'
    end
  end
end
