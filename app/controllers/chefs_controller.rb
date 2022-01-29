class ChefsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all_chefs
    render 'users/index'
  end

  def show
    @user = User.find(params[:id])&.as_chef
    render 'users/show'
  end

end
