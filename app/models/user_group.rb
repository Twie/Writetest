class UserGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  validates_uniqueness_of :user_id , :scope => :group_id
  after_create :destroy_join_group_invitations_if_any
  
  def destroy_join_group_invitations_if_any
    user = User.find(self.user_id)
    group = Group.find(self.group_id)
    join_group_email_invitation =  group.join_group_email_invitations.where(:email_id => user.email)
    unless join_group_email_invitation.nil?
      JoinGroupEmailInvitation.destroy(join_group_email_invitation.first.id)
    end
  end
  
end
