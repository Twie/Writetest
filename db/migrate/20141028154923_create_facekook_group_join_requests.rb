class CreateFacekookGroupJoinRequests < ActiveRecord::Migration
  def change
    create_table :facekook_group_join_requests do |t|
      t.integer :request_id
      t.string :group_title
      t.boolean :accepted, :default => false

      t.timestamps
    end
  end
end
