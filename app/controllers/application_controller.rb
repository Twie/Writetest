class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:username, :firstname, :lastname]
  end
  
  def confirm_logged_in(return_point = request.url)
    unless user_signed_in?
      flash[:notice] = "Please log in"
      set_return_point(return_point, true)
      redirect_to new_user_session_path
      return false
    else
      return true
    end
  end
  
  def set_return_point(path, overwrite = false)
    if overwrite or session[:return_point].blank?
      session[:return_point] = path
    end
  end
  
  def return_point
    session[:return_point] || root_path
  end
  
  def after_sign_in_path_for(resource)
      return return_point
  end
  
end
