Rails.application.routes.draw do
  resources :cookbooks
  resources :recipes
  get 'new_join_cookbook_recipe', to: 'cookbooks#new_join_cookbook_recipe'
  post 'join_cookbook_recipe', to: 'cookbooks#join_cookbook_recipe', as: 'join_cookbook_recipe'
  devise_for :users
  root 'welcome#index'

end
