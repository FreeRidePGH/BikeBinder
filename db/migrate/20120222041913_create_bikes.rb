class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
      t.string :color
      t.float :value
      t.float :seat_tube_height
      t.float :top_tube_length

      t.timestamps
    end
  end
end
