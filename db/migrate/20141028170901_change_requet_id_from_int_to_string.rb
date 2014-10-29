class ChangeRequetIdFromIntToString < ActiveRecord::Migration
  def change
    change_column :facekook_group_join_requests, :request_id, :string
  end
end
