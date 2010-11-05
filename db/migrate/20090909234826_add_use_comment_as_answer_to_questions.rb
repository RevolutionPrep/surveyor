class AddUseCommentAsAnswerToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :use_comment_as_answer, :boolean, :default => false
  end

  def self.down
    remove_column :questions, :use_comment_as_answer
  end
end