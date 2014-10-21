class GroupsController < ApplicationController
  before_filter :confirm_logged_in
  
  def index
    @current_user = current_user
  end
  
  def result
    group_id = params[:gid]
    @group = Group.find(group_id)
  end
  
  def new
    @current_user = current_user
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save
      @user = current_user
      @user_group = current_user.user_groups.new(:group_id=>@group.id)
      @user_group.save
      emails = params[:emails]
      invite_users_to_join(emails, @group)
      redirect_to "/sentences/new?gid=#{@group.id}", :notice => "Group successfully created!"
    else
      render action: 'new'
    end
  end
  
  def invite_users_to_join(emails,group)
    email_ids = extract_emails_from(emails)
    email_ids.each do |email|
      next if current_user.email == email
      user = User.where(:email=>email)
      if(user.nil?)
        UserMailer.invite_to_join_group(current_user,group, user).deliver
      else
        UserMailer.invite_to_join_app(current_user, group, email).deliver
      end
    end
  end
  
  def demo_facebook_invite
    
  end
  
  def extract_emails_from( raw_text )
    return [] unless raw_text.present?
    raw_text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end
  
  def group_params
    params.require(:group).permit(:title, :enter_code)
  end
  
end