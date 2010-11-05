class AddUserIdColumnsToResultsTables < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :user_id, :integer
    add_column :question_results, :user_id, :integer
  end

  def self.down
    remove_column :survey_results, :user_id
    remove_column :question_results, :user_id
  end
end