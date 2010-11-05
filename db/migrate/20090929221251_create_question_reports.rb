class CreateQuestionReports < ActiveRecord::Migration
  def self.up
    create_table :question_reports do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :question_reports
  end
end