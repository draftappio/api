class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session,
      if: Proc.new { |c| c.request.format =~ %r{application/json} }

  before_action :configure_permitted_parameters, if: :devise_controller?
  # TODO: before_action :check_sketch_version, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(email password firstname lastname))
    devise_parameter_sanitizer.permit(:account_update, keys: %i(email password firstname lastname image))
  end
end
