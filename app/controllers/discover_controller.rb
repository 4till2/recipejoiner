class DiscoverController < ApplicationController
  before_action :authenticate_user!

  def index
    @recommendations = current_user.discover_recommendations
    @recipes = current_user.discover_recipes
    @cookbooks = current_user.discover_cookbooks
    @users = current_user.discover_users
    @subscriptions = current_user.recent_subscriptions
  end

  def search
    results = PgSearch.multisearch(params[:query]).limit(10)
    recommendations = current_user.discover_recommendations(10)
    render partial: 'discover/search', locals: { results: results, query: params[:query], recommendations: recommendations}
  end

end
