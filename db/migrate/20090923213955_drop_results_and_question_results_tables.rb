class DropResultsAndQuestionResultsTables < ActiveRecord::Migration
  def self.up
    drop_table :results
    drop_table :question_results
  end

  def self.down
    create_table :results do |t|
      t.integer :iteration_id

      t.timestamps
    end
    create_table :question_results do |t|
      t.integer :result_id
      t.integer :question_id
      t.integer :component_id
      t.text :response

      t.timestamps
    end
  end
end