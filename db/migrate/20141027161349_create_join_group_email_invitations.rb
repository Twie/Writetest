class CreateJoinGroupEmailInvitations < ActiveRecord::Migration
  def change
    create_table :join_group_email_invitations do |t|
      t.string :email_id
      t.references :group, index: true

      t.timestamps
    end
  end
end
