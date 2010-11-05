class AddSurveyIdToSurveyResults < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :survey_id, :integer, :null => false
    Iteration.all.each do |iteration|
      SurveyResult.connection.execute %Q{ UPDATE survey_results SET survey_id = #{iteration.survey_id} WHERE iteration_id = #{iteration.id} }
    end
  end

  def self.down
    remove_column :survey_results, :survey_id
  end
end
