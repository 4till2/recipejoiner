class CookbooksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_and_authorize, only: %i[show edit update destroy]

  # GET /cookbooks or /cookbooks.json
  def index
    @cookbooks = Cookbook.all
  end

  # GET /cookbooks/1 or /cookbooks/1.json
  def show
  end

  # GET /cookbooks/new
  def new
    @cookbook = Cookbook.new
  end

  # GET /cookbooks/1/edit
  def edit
  end

  # options = cookbooks, or recipes depending on whose asking.
  # when options == cookbooks the user is selecting a cookbook to add a recipe to.
  # when options == recipes the user is selecting recipes to add to a cookbook.
  def new_join_cookbook_recipe
    options = params[:recipe_id] ? Cookbook.where(user_id: current_user.id) : Recipe.where(user_id: current_user.id)
    recipe = params[:recipe_id] ? Recipe.find(params[:recipe_id]) : nil
    cookbook = params[:cookbook_id] ? Cookbook.find(params[:cookbook_id]) : nil
    render turbo_stream: turbo_stream.replace('modal_content', partial: 'join_cookbook_recipe',
                                                               locals: { options: options, cookbook: cookbook, recipe: recipe })
  end

  def join_cookbook_recipe
    recipe = Recipe.find(params[:recipe_id]) if params[:recipe_id]
    cookbook = Cookbook.find(params[:cookbook_id]) if params[:cookbook_id]
    return unless recipe && cookbook

    cookbook.add_or_remove_recipe(recipe)
    render partial: 'cookbook_recipe_join_button', locals: { recipe: recipe, cookbook: cookbook }
  end

  # POST /cookbooks or /cookbooks.json
  def create
    @cookbook = Cookbook.new(cookbook_params)

    respond_to do |format|
      if @cookbook.save
        format.html { redirect_to cookbook_url(@cookbook), notice: "Cookbook was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cookbooks/1 or /cookbooks/1.json
  def update
    respond_to do |format|
      if @cookbook.update(cookbook_params)
        format.html { redirect_to cookbook_url(@cookbook), notice: "Cookbook was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cookbooks/1 or /cookbooks/1.json
  def destroy
    @cookbook.destroy

    respond_to do |format|
      format.html { redirect_to cookbooks_url, notice: "Cookbook was successfully destroyed." }
    end
  end

  private

  # authorize with pundit policy
  def load_and_authorize
    @cookbook = Cookbook.find(params[:id])
    authorize @cookbook
  end

  # Only allow a list of trusted parameters through.
  def cookbook_params
    params.require(:cookbook).permit(:title, :description, :user_id)
  end
end
