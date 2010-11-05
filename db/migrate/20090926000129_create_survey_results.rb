class CreateSurveyResults < ActiveRecord::Migration
  def self.up
    create_table :survey_results do |t|
      t.integer :iteration_id

      t.timestamps
    end
  end

  def self.down
    drop_table :survey_results
  end
end