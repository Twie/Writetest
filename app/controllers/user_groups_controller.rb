class UserGroupsController < ApplicationController
  before_filter :confirm_logged_in
  respond_to :html, :js
  # GET /sentences
  # GET /sentences.json
  def new
    @group_id = params[:gid]
    group_passwd = params[:passwd]
    @group = Group.find_by_id(@group_id)
    unless @group.nil?
      @user_group = current_user.user_groups.new(:group_id=>@group.id)
      if @group.enter_code.try(:downcase) == group_passwd.try(:downcase)
        @user_group.save
        redirect_to "/sentences/new?gid=#{@group_id}", :notice => "Welcome to the group!"
      else
        redirect_to :root, :alert => "Incorrect Passcode" 
      end
    else
      redirect_to :root, :alert => "Group does not exists!"
    end
  end
  
  def create
    group_title = params[:title]
    @group = Group.find_by_title(group_title)
    unless @group.nil?
      @group_id = @group.id
      @user_group = current_user.user_groups.new(:group_id=>@group_id)
      src = params[:src]
      if @group.enter_code.try(:downcase) == params[:enter_code].try(:downcase)
        @user_group.save
        redirect_to "/sentences/new?gid=#{@group_id}", :notice => "Welcome to the group!"
      else
        if(src == "sentences")
          redirect_to "/sentences/new?gid=#{@group_id}", :alert => "Incorrect Passcode"
        else
          redirect_to :root, :alert => "Incorrect Passcode" 
        end  
      end
    else
      redirect_to :root, :alert => "No group exists by " + group_title 
    end
  end
  
  private
  def user_group_params
    params.require(:user_group).permit(:group_id)
  end
end
