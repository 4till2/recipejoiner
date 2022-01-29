Rails.application.routes.draw do
  resources :chefs, only: %i[index show], as: 'users'
  resources :cookbooks
  resources :recipes

  get 'discovers', to: 'discovers#index', as: 'discovers'
  get 'search', to: 'discovers#new_search', as: 'new_search'
  post 'search', to: 'discovers#search', as: 'search'

  get 'subscriptions', to: 'subscriptions#show', as: 'load_subscription'
  post 'subscriptions', to: 'subscriptions#update', as: 'subscription'

  get 'new_join_cookbook_recipe', to: 'cookbooks#new_join_cookbook_recipe'
  post 'join_cookbook_recipe', to: 'cookbooks#join_cookbook_recipe', as: 'join_cookbook_recipe'

  devise_for :users

  root 'welcome#index'

end
