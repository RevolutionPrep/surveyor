class AddPermalinkToIterations < ActiveRecord::Migration
  def self.up
    add_column :iterations, :permalink, :string, :null => false
  end

  def self.down
    remove_column :iterations, :permalink
  end
end