class FacekookGroupJoinRequestsController < ApplicationController
  def create
    @facebook_group_join_request = FacekookGroupJoinRequest.new(facebook_group_join_request_params)
    if @facebook_group_join_request.save
      render :json => true
    else
      render :json => false
    end
  end

  def facebook_group_join_request_params
    puts "#################"
    puts params
    params.require(:facebook_group_join_request).permit(:group_title, :request_id)
  end
end