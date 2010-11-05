class CreateComponents < ActiveRecord::Migration
  def self.up
    create_table :components do |t|
      t.text :value
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :components
  end
end