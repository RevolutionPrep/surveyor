class AddMultipleAnswersBooleanToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :multiple_answers, :boolean, :default => false
  end

  def self.down
    remove_column :questions, :multiple_answers
  end
end