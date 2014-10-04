class GroupsController < ApplicationController
  before_filter :confirm_logged_in
  
  def index
    @current_user = current_user
  end
end