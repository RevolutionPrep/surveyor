xml.question_results(:type => 'array') do
  xml.question_result do

    if @question.type.to_s == "RatingQuestion"
      numerator = @question_results.inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
      denominator = @question_results.collect { |question_result| question_result.rating_label }.compact.length
      xml.gpa_of_respondents "#{ safe_div { numerator / denominator } }"

      numerator = @question_results.inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
      denominator = @question_results.length
      xml.gpa_of_total "#{ safe_div { numerator / denominator } }"

    end

  end
end