class SessionsController < Devise::SessionsController
  
   before_action :check_user_confirmation, only: :create
  
  def return_point
    puts session[:return_point]
    session[:return_point] || root_path
  end
  
  def check_user_confirmation
    user = User.find_by_email(params[:email])
    if user && user.confirmed?
      redirect_to return_point
    end
      
  end
end