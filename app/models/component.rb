class Component < ActiveRecord::Base

  #------- Plugin Behavior -------#
  acts_as_list :scope => :question

  #------- Associations -------#
  belongs_to :question
  belongs_to :user
  
  #------- Validations -------#
  validates_presence_of :question_id
  validates_presence_of :user_id
  validates_presence_of :value

end