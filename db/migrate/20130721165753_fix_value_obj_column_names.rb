class FixValueObjColumnNames < ActiveRecord::Migration
  def change
    rename_column :bikes, :number, :number_record
    rename_column :hooks, :number, :number_record
  end
end
