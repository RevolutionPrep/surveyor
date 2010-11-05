class RemoveUserIdFromIterations < ActiveRecord::Migration
  def self.up
    remove_column :iterations, :user_id
  end

  def self.down
    add_column :iterations, :user_id, :integer
  end
end