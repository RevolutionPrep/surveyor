class RemovePermalinkFromIterations < ActiveRecord::Migration
  def self.up
    remove_column :iterations, :permalink
  end

  def self.down
    add_column :iterations, :permalink, :string, :null => false
  end
end