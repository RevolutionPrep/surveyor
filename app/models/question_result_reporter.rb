class QuestionResultReporter
  
  #------- Attributes -------#
  attr_writer :question_results, :question_counts, :short_answer_results
  
  attr_writer :counts_hash
  def counts_hash
    @counts_hash ||= {}
  end
  
  attr_writer :question_results_hash
  def question_results_hash
    @question_results_hash ||= {}
  end
  
  def question_results
    @question_results ||= []
  end
  
  def question_counts
    @question_counts ||= {}
  end
  
  def short_answer_results
    @short_answer_results ||= []
  end
  
  #------- Report Builder -------#
  def self.build(questions, survey_result_ids)
    new.build(questions, survey_result_ids)
  end
  
  def build(questions, survey_result_ids)
    questions.each do |question|
      case question
      when RatingQuestion, MultipleChoiceQuestion
        build_question_counts(question, survey_result_ids)
        build_question_results_hash_values
        build_percentages
        build_gpas(question)
        store_result_counts
        store_question_counts(question)
      when ShortAnswerQuestion
        build_short_answer_results(question)
      end
    end
    build_question_results(questions, survey_result_ids)
    [question_results, question_counts, short_answer_results]
  end
  
  #------- Builder Helpers -------#
  def build_question_counts(question, survey_result_ids)
    question.count(survey_result_ids).each do |count|
      counts_hash.store(count.first.to_s, { :count => count.second })
    end
  end
  
  def build_question_results_hash_values
    question_results_hash.store(:respondent_count, counts_hash.collect { |count| count.second[:count] unless count.first.blank? }.compact.inject(0) { |sum,count| sum += count.to_i })
    question_results_hash.store(:total_count, counts_hash.inject(0) { |sum,count| sum += count.second[:count].to_i })
  end
  
  def build_percentages
    counts_hash.each do |count|
      count.second.store(:percentage_of_respondents, count.second[:count].to_f/question_results_hash[:respondent_count].to_f)
      count.second.store(:percentage_of_total, count.second[:count].to_f/question_results_hash[:total_count].to_f)
    end
  end
  
  def build_gpas(question)
    if question.kind_of?(RatingQuestion)
      gpa_of_respondents = counts_hash.inject(0) { |sum,result_count|
        sum + result_count.second[:percentage_of_respondents] * (RatingLabel.find(result_count.first).value.to_f rescue 0.0)
      }
      gpa_of_total = counts_hash.inject(0) { |sum,result_count|
        sum + result_count.second[:percentage_of_total] * (RatingLabel.find(result_count.first).value.to_f rescue 0.0)
      }
      question_results_hash.store(:gpa_of_respondents, gpa_of_respondents)
      question_results_hash.store(:gpa_of_total, gpa_of_total)
    end
  end
  
  def store_result_counts
    question_results_hash.store(:result_counts, counts_hash)
  end
  
  def store_question_counts(question)
    question_counts.store("#{question.id}", question_results_hash)
  end
  
  def build_short_answer_results(question)
    question.count(params[:hash][:results]).each do |count|
      short_answer_results << count.last
    end
    short_answer_results.flatten!
  end
  
  def build_question_results(questions, survey_result_ids)
    questions.each do |question|
      question_results << question.question_results.find_all_by_question_id_and_survey_result_id(question.id, survey_result_ids) unless question.type.to_s == "ShortAnswerQuestion"
    end
  end
  
end