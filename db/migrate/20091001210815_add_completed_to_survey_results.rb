class AddCompletedToSurveyResults < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :survey_results, :completed
  end
end