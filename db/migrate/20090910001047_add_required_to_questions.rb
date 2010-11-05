class AddRequiredToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :required, :boolean, :default => false
  end

  def self.down
    remove_column :questions, :required
  end
end