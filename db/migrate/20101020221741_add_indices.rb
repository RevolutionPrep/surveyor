class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :components, :user_id
    add_index :components, :question_id
    add_index :questions, :section_id
    add_index :questions, :user_id
    add_index :questions, :rating_scale_id
    add_index :rating_labels, :rating_scale_id
    add_index :rating_scales, :user_id
    add_index :sections, :user_id
    add_index :sections, :survey_id
    add_index :survey_results, :user_id
    add_index :survey_results, :survey_id
    add_index :surveys, :user_id
  end

  def self.down
    remove_index :components, :user_id
    remove_index :components, :question_id
    remove_index :questions, :section_id
    remove_index :questions, :user_id
    remove_index :questions, :rating_scale_id
    remove_index :rating_labels, :rating_scale_id
    remove_index :rating_scales, :user_id
    remove_index :sections, :user_id
    remove_index :sections, :survey_id
    remove_index :survey_results, :user_id
    remove_index :survey_results, :survey_id
    remove_index :surveys, :user_id
  end
end