class User < ActiveRecord::Base

  #------- Plugin Behavior -------#
  acts_as_authentic

  #------- Associations -------#
  has_many :surveys
  has_many :sections
  has_many :questions
  has_many :components
  has_many :rating_scales
  has_many :rating_labels
  has_many :survey_results
  has_many :question_results

end