class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.integer :iteration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end