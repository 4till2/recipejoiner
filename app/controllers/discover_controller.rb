class DiscoverController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes_feed = current_user.recipes_feed.last(10)
    @discoverables = Recipe.last(20)
  end

  def new_search
    render turbo_stream: turbo_stream.replace('modal_content', partial: 'search')
  end

  def search
    results = PgSearch.multisearch(params[:query])
    render partial: 'discover/search', locals: { results: results, query: params[:query]}
  end

end
