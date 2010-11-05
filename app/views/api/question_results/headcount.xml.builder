xml.question_results(:type => 'array') do
  xml.question_result do
    xml.headcount "#{@question_results.length rescue 0}"
    case @question.type.to_s
    when "MultipleChoiceQuestion"
      numerator = @total_results.collect { |question_result| question_result if question_result.component_id == @component.id }.compact.length.to_f
      denominator = @total_results.collect { |question_result| question_result.component_id }.compact.length.to_f
      xml.percentage_of_respondents "#{ safe_div { numerator / denominator } }"

      numerator = @total_results.collect { |question_result| question_result if question_result.component_id == @component.id }.compact.length.to_f
      denominator = @total_results.length.to_f
      xml.percentage_of_total "#{ safe_div { numerator / denominator } }"

    when "RatingQuestion"
      numerator = @total_results.collect { |question_result| question_result if question_result.rating_label_id == @rating_label.id }.compact.length.to_f
      denominator = @total_results.collect { |question_result| question_result.rating_label_id }.compact.length.to_f
      xml.percentage_of_respondents "#{ safe_div { numerator / denominator } }"

      numerator = @total_results.collect { |question_result| question_result if question_result.rating_label_id == @rating_label.id }.compact.length.to_f
      denominator = @total_results.length.to_f
      xml.percentage_of_total "#{ safe_div { numerator / denominator } }"
    end
  end
end