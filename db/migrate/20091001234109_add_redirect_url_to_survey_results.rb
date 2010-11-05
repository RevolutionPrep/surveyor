class AddRedirectUrlToSurveyResults < ActiveRecord::Migration
  def self.up
    add_column :survey_results, :redirect_url, :text
  end

  def self.down
    remove_column :survey_results, :redirect_url
  end
end