class QuestionResult < ActiveRecord::Base

  #------- Associations -------#
  belongs_to :survey_result
  belongs_to :question
  belongs_to :rating_label
  belongs_to :component

end