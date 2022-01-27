Rails.application.routes.draw do
  resources :chefs, only: %i[index show]
  resources :feeds, only: [:index]
  get 'subscriptions', to: 'subscriptions#show', as: 'load_subscription'
  post 'subscriptions', to: 'subscriptions#update', as: 'subscription'
  # post 'subscribe_or_unsubscribe', to: 'feeds#subscribe_or_unsubscribe', as: 'subscription'
  resources :cookbooks
  resources :recipes
  get 'new_join_cookbook_recipe', to: 'cookbooks#new_join_cookbook_recipe'
  post 'join_cookbook_recipe', to: 'cookbooks#join_cookbook_recipe', as: 'join_cookbook_recipe'
  devise_for :users
  root 'welcome#index'

end
