class JoinGroupEmailInvitation < ActiveRecord::Base
  belongs_to :group
  validates_uniqueness_of :email_id, :scope => :group
end
