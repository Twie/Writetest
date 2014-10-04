class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username, :firstname, :lastname]
  end
  
  def confirm_logged_in
    unless user_signed_in?
        flash[:notice] = "Please log in"
        redirect_to new_user_session_path
        return false
    else
        return true
    end
  end
end
