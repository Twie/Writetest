class AddChancesSkippedToUserGroups < ActiveRecord::Migration
  def change
    add_column :user_groups, :skipped_count, :integer
  end
end
