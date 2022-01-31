Rails.application.routes.draw do
  devise_for :users

  resources :chefs, only: %i[index show], as: 'users'
  resources :cookbooks
  resources :recipes

  get 'paginated_collection', to: 'subscriptions#paginated', as: 'paginated_collection'

  get 'discover', to: 'discover#index', as: 'discover'
  get 'search', to: 'discover#search', as: 'new_search'
  post 'search', to: 'discover#search', as: 'search'

  get 'subscriptions', to: 'subscriptions#show', as: 'load_subscription'
  post 'subscriptions', to: 'subscriptions#update', as: 'subscription'

  get 'new_join_cookbook_recipe', to: 'cookbooks#new_join_cookbook_recipe'
  post 'join_cookbook_recipe', to: 'cookbooks#join_cookbook_recipe', as: 'join_cookbook_recipe'


  root 'welcome#index'

end
