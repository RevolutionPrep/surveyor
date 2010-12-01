class AddSetKeyToSurveyResults < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :set_key, :string
  end

  def self.down
    remove_column :survey_results, :set_key
  end
end
