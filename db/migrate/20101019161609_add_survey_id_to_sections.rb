class AddSurveyIdToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :survey_id, :integer, :null => false
    Section.all.each do |section|
      section.update_attributes(:survey => section.iteration.survey)
    end
  end

  def self.down
    remove_column :sections, :survey_id
  end
end
