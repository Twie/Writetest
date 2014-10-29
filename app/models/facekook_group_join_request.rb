class FacekookGroupJoinRequest < ActiveRecord::Base
  validates_presence_of :group_title, :request_id
  
  def group
    @group || Group.find_by_title(self.group_title)
  end
end
