class AddEnterCodeToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :enter_code, :string
  end
end
