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
      puts "setting return point"
      set_return_point(return_point)
      redirect_to new_user_session_path
      return false
    else
      return true
    end
  end
  
  def set_return_point(path)
    unless session[:return_point].blank?
      session[:return_point] = path
    end
    puts session[:return_point]
  end
  
end
