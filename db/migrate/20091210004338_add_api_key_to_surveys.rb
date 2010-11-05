class AddApiKeyToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :api_key, :string
    Survey.all.each do |survey|
      survey.api_key = survey.generate_api_key
      survey.save!
    end
  end

  def self.down
    remove_column :surveys, :api_key
  end

end