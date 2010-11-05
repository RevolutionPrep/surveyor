class AddRatingScaleIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :rating_scale_id, :integer
  end

  def self.down
    remove_column :questions, :rating_scale_id
  end
end