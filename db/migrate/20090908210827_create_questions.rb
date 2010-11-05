class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :section_id
      t.text :statement
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end