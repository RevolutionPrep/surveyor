class AddDescriptionToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :description, :text, :default => "", :null => false
    Iteration.all.each do |iteration|
      iteration.survey.update_attributes(:description => iteration.description)
    end
  end

  def self.down
    remove_column :surveys, :description
  end
end
