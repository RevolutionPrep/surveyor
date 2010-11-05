class AddUserToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :user_id, :integer
  end

  def self.down
    remove_column :components, :user_id
  end
end