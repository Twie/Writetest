class UserGroupsController < ApplicationController
  before_filter :confirm_logged_in
  respond_to :html, :js
  # GET /sentences
  # GET /sentences.json
  def create
    @user_group = current_user.user_groups.new(user_group_params)
    @group_id = user_group_params[:group_id]
    @group = Group.find(@group_id) 
    src = params[:src]
    if @group.enter_code.try(:downcase) == params[:enter_code].try(:downcase)
      @user_group.save
      redirect_to "/sentences/new?gid=#{user_group_params[:group_id]}", :notice => "Welcome to the group!"
    else
      if(src == "sentences")
        redirect_to "/sentences/new?gid=#{user_group_params[:group_id]}", :notice => "Incorrect Passcode"
      else
        redirect_to :root, :notice => "Incorrect Passcode" 
      end  
    end
  end
  
  private
  def user_group_params
    params.require(:user_group).permit(:group_id)
  end
end
