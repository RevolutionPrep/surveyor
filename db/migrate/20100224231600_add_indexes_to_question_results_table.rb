class AddIndexesToQuestionResultsTable < ActiveRecord::Migration
  def self.up
    add_index :question_results, :question_id
    add_index :question_results, :component_id
    add_index :question_results, :rating_label_id
    add_index :question_results, :survey_result_id
    add_index :question_results, :user_id
  end

  def self.down
  end
end