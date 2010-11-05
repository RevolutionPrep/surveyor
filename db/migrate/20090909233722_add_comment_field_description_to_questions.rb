class AddCommentFieldDescriptionToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :comment_field_description, :text
  end

  def self.down
    remove_column :questions, :comment_field_description
  end
end