class AddQuestionResultsTable < ActiveRecord::Migration
  def self.up
    create_table :question_results do |t|
      t.integer :survey_result_id
      t.integer :question_id
      t.integer :component_id
      t.integer :rating_label_id
      t.text :response

      t.timestamps
    end
  end

  def self.down
    drop_table :question_results
  end
end