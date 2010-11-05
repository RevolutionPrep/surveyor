class AddCommentFieldToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :comment_field, :boolean, :default => false
  end

  def self.down
    remove_column :questions, :comment_field
  end
end