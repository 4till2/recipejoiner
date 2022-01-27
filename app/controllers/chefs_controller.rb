class ChefsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chefs = User.all_chefs
  end

  def show
    @chef = User.find(params[:id])&.as_chef
  end

end
