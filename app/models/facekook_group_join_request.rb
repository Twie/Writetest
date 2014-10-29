class FacekookGroupJoinRequest < ActiveRecord::Base
  validates_presence_of :group_title, :request_id
end
