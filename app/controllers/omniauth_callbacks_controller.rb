class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          if @user and session[:facebook_request_id].present?
            join_request = FacekookGroupJoinRequest.find_by_request_id(session[:facebook_request_id])
            if join_request and join_request.group
             @user.user_groups.create(:group => join_request.group)
             session[:facebook_request_id] = nil
           end
          end
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:facebook, :google_oauth2, :facebook_invite].each do |provider|
    provides_callback_for provider
  end

end