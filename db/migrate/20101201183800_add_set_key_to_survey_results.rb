class AddSetKeyToSurveyResults < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :set_key, :string
    add_index :survey_results, [:survey_id, :set_key]
    add_index :survey_results, [:set_key, :survey_id]
  end

  def self.down
    remove_index :survey_results, [:survey_id, :set_key]
    remove_index :survey_results, [:set_key, :survey_id]
    remove_column :survey_results, :set_key
  end
end
