class CreateRatingLabels < ActiveRecord::Migration
  def self.up
    create_table :rating_labels do |t|
      t.string :key
      t.string :value
      t.integer :rating_scale_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rating_labels
  end
end