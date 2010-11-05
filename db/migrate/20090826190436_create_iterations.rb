class CreateIterations < ActiveRecord::Migration
  def self.up
    create_table :iterations do |t|
      t.string :title
      t.text :description
      t.boolean :active, :default => false
      t.integer :survey_id
      t.integer :user_id
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :iterations
  end
end