class CreateRatingScales < ActiveRecord::Migration
  def self.up
    create_table :rating_scales do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :rating_scales
  end
end