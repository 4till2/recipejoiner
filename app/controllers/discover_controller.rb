class DiscoverController < ApplicationController
  # before_action :authenticate_user!

  def index
    user = current_user || User.new
    @recommendations = user.discover_recommendations
    @recipes = user.discover_recipes
    @cookbooks = user.discover_cookbooks
    @users = user.discover_users
    @subscriptions = user.recent_subscriptions
  end

  def search
    user = user || User.new
    results = PgSearch.multisearch(params[:query]).limit(10)
    recommendations = user.discover_recommendations(10)
    render partial: 'discover/search', locals: { results: results, query: params[:query], recommendations: recommendations}
  end

end
