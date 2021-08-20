Rails.application.routes.draw do
  get 'login' => 'users#login_form'
  post "login" => "users#login"

  post "logout" => "users#logout"

  post 'users/:id/update' => 'users#update'
  get 'users/:id/edit' => 'users#edit'
  post 'users/create' => 'users#create'
  get 'signup' => 'users#new'
  get "users/member/:share_id" => "users#member"
  get 'users/:id' => 'users#show'
  get "users/:id/likes" => "users#likes"

  get 'rooms/show' => 'rooms#show'

  get 'posts/new' => 'posts#new'
  get 'posts/index' => 'posts#index'
  get 'posts/:id' => 'posts#show'
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"

  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"

  get '/' => 'home#top'
  get 'about' => 'home#about'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
