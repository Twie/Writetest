class AddUserGroupToSentence < ActiveRecord::Migration
  def change
    add_column :sentences, :user_id, :integer
    add_column :sentences, :group_id, :integer
  end
end
