class DropIterationsTable < ActiveRecord::Migration
  def self.up
    remove_column :sections, :iteration_id
    remove_column :survey_results, :iteration_id
    drop_table :iterations
  end

  def self.down
  end
end
