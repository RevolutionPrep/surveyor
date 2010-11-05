class ModifyMembersOfQuestionTable < ActiveRecord::Migration
  def self.up
    remove_column :questions, :comment_field
    remove_column :questions, :comment_field_description
    rename_column :questions, :use_comment_as_answer, :user_entered_answer
  end

  def self.down
    rename_column :questions, :user_entered_answer, :use_comment_as_answer
    add_column :questions, :comment_field, :boolean, :default => false
    add_column :questions, :comment_field_description, :text
  end
end