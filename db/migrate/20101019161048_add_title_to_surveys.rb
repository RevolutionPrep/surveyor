class AddTitleToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :title, :string, :default => "", :null => false
    Iteration.all.each do |iteration|
      iteration.survey.update_attributes(:title => iteration.title)
    end
  end

  def self.down
    remove_column :surveys, :title
  end
end
