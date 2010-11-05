class SurveyResult < ActiveRecord::Base

  #------- Associations -------#
  belongs_to :survey
  belongs_to :user
  has_many :question_results, :dependent => :destroy

  #------- Callbacks -------#
  after_update :save_question_results

  #------- Virtual Attributes -------#

  def question_results_attributes=(attributes)
    attributes.each do |question_result_attributes|
      question_result = question_results.build(:user_id => user_id, :question_id => question_result_attributes[0])
      case question_result_attributes[1][:type]
      when "MultipleChoiceQuestion"
        question_result.component_id = question_result_attributes[1][:component_id]
        question_result.response = question_result_attributes[1][:response]
      when "RatingQuestion"
        question_result.rating_label_id = question_result_attributes[1][:rating_label_id]
      when "ShortAnswerQuestion"
        question_result.response = question_result_attributes[1][:response]
      end
    end
  end

  #------- Callback Methods -------#
  def save_question_results
    question_results.each do |question_result|
      question_result.save
    end
  end
  
  #------- Actions -------#
  def build_results(results)
    results.each_pair do |key,value|
      key_params = key.split('_')
      if key_params.last == "type"
        question = user.questions.find(key_params.second)
        case value
        when "multiple_choice_question"
          question_results.build(:user_id => user.id, :question_id => question.id, :component_id => results["#{key_params.first}_#{key_params.second}"])
        when "rating_question"
          question_results.build(:user_id => user.id, :question_id => question.id, :rating_label_id => results["#{key_params.first}_#{key_params.second}"])
        when "short_answer_question"
          question_results.build(:user_id => user.id, :question_id => question.id, :response => results["#{key_params.first}_#{key_params.second}"])
        end
      end
    end
  end

end