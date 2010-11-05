class AddPositionToComponents < ActiveRecord::Migration
  def self.up
    add_column :components, :position, :integer
  end

  def self.down
    remove_column :components, :position
  end
end