class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    @feed = current_user.feed
  end

end
