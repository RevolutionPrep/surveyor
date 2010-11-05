class RemoveQuestionReports < ActiveRecord::Migration
  def self.up
    drop_table :question_reports
  end

  def self.down
    create_table :question_reports do |t|
      t.timestamps
    end
  end
end