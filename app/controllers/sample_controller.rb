class SampleController < ApplicationController
  before_action :authenticate_user!
  before_action :load_and_authorize, only: %i[ show edit update destroy ]

  def index
    @samples = Sample.where(user_id: current_user.id).order("created_at DESC")
  end

  def show;end

  def new
    @sample = Sample.new
  end

  def edit; end

  def create
    @sample = Sample.new(sample_params)
    @sample.user_id = current_user.id
    respond_to do |format|
      if @sample.save
        format.html { redirect_to sample_url(@sample), notice: "Sample was successfully created." }
        format.json { render :show, status: :created, location: @sample }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sample.update(sample_params)
        format.html { redirect_to sample_url(@sample), notice: "Sample was successfully updated." }
        format.json { render :show, status: :ok, location: @sample }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sample.destroy

    respond_to do |format|
      format.html { redirect_to samples_url, notice: "Sample was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # authorize with pundit policy
  def load_and_authorize
    @sample = Sample.find(params[:id])
    authorize @sample
  end

  # Only allow a list of trusted parameters through.
  def sample_params
    params.require(:sample).permit(:name)
  end
end
