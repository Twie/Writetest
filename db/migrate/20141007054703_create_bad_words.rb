class CreateBadWords < ActiveRecord::Migration
  def change
    create_table :bad_words do |t|
      t.string :word

      t.timestamps
    end
  end
end
