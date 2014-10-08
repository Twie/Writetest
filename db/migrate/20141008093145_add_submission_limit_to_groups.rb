class AddSubmissionLimitToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :submissions_limit, :integer, :default =>100
  end
end
