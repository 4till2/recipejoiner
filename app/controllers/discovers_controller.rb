class DiscoversController < ApplicationController
  before_action :authenticate_user!

  def index
    @feed = current_user.feed
    @discoverables = Recipe.last(10)
  end

  def new_search
    render turbo_stream: turbo_stream.replace('modal_content', partial: 'search')
  end

  def search
    results = PgSearch.multisearch(params[:query])
    render partial: 'discovers/search', locals: { results: results, query: params[:query]}
  end

end
