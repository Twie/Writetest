class UserGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  validates_uniqueness_of :user_id , :scope => :group_id
  after_create :destroy_join_group_invitations_if_any
  
  def destroy_join_group_invitations_if_any
    join_group_email_invitations =  self.group.join_group_email_invitations.where(:email_id => self.user.email)
    join_group_email_invitations.each do |invitation|
      JoinGroupEmailInvitation.destroy(invitation.id)
    end
  end
end
