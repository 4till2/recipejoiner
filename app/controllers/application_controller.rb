class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :turbo_frame_request_variant

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  private

  # def turbo_frame_request_variant
  #   request.variant = :turbo_frame if turbo_frame_request?
  #   # request.format = :turbo_frame if turbo_frame_request?
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
