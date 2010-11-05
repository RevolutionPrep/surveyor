class AddUserIdToRatingLabels < ActiveRecord::Migration
  def self.up
    add_column :rating_labels, :user_id, :integer, :null => false
    add_index :rating_labels, :user_id
    RatingScale.all.each do |rating_scale|
      RatingLabel.connection.execute %Q{ UPDATE rating_labels SET user_id = #{rating_scale.user_id} WHERE rating_scale_id = #{rating_scale.id} }
    end
  end

  def self.down
    remove_index :rating_labels, :user_id
    remove_column :rating_labels, :user_id
  end
end
