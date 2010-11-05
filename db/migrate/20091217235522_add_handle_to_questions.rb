class AddHandleToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :handle, :string
    Question.all.each do |question|
      question.generate_handle
      question.save
    end
  end

  def self.down
    remove_column :questions, :handle
  end
end