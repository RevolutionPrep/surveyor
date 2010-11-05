class AddCompletedToResultsAndQuestionResults < ActiveRecord::Migration
  def self.up
    add_column :results, :completed, :boolean, :default => false
    add_column :question_results, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :results, :completed
    remove_column :question_results, :completed
  end
end