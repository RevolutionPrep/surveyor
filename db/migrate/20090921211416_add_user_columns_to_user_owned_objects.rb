class AddUserColumnsToUserOwnedObjects < ActiveRecord::Migration
  def self.up
    add_column :iterations, :user_id, :integer
    add_column :sections, :user_id, :integer
    add_column :questions, :user_id, :integer
  end

  def self.down
    remove_column :iterations, :user_id
    remove_column :sections, :user_id
    remove_column :questions, :user_id
  end
end