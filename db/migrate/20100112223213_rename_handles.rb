class RenameHandles < ActiveRecord::Migration
  def self.up
    Question.first(:conditions => {:statement => "Do you plan to recommend Revolution Prep to a friend?"}).update_attributes :handle => "recommend"
    Question.first(:conditions => {:statement => "Rate your overall satisfaction with Revolution Prep:"}).update_attributes :handle => "satisfaction"
    Question.first(:conditions => {:statement => "Rate your instructor's teaching ability, clarity, and energy:"}).update_attributes :handle => "ability"
    Question.first(:conditions => {:statement => "Rate your instructor's expertise in the subject matter and curriculum:"}).update_attributes :handle => "expertise"
    Question.first(:conditions => {:statement => "What do you think your instructor did well?"}).update_attributes :handle => "did well"
    Question.first(:conditions => {:statement => "What could your instructor have done better?"}).update_attributes :handle => "done better"
    Question.first(:conditions => {:statement => "Can you give us a quote about the course that we can put up on our website?"}).update_attributes :handle => "quote"
    Question.first(:conditions => {:statement => "Are you interested in tutoring with a Revolution Prep instructor for the Subject Tests, academic subjects, etc?"}).update_attributes :handle => "interested"


  end

  def self.down
  end
end