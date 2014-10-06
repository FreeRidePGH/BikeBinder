class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group, :integer, :default => 0
  end
end
