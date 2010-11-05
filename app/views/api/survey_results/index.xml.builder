xml.survey_results(:type => 'array') do
  xml.survey_result do
    xml.total_count "#{@question_results.first.length}"
    xml.questions(:type => 'array') do
      @questions.each_with_index do |question,index|
        xml.question do
          xml.id "#{question.id}"
          xml.handle "#{question.handle}"
          xml.statement "#{question.statement}"
          xml.sub_type "#{question.type}"
          xml.multiple_answers "#{question.multiple_answers}"
          xml.user_entered_answer "#{question.user_entered_answer}"
          xml.required "#{question.required}"
          case question.type
          when "MultipleChoiceQuestion"
            xml.respondent_count "#{@question_results[index].collect { |question_result| question_result.component_id }.compact.length}"
            xml.choices(:type => 'array') do
              question.components.each do |component|
                xml.choice do
                  xml.value "#{component.value}"
                  xml.id "#{component.id}"
                  xml.response_count "#{@question_results[index].collect { |question_result| question_result if question_result.component_id == component.id }.compact.length}"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.component_id == component.id }.compact.length.to_f
                  denominator = @question_results[index].collect { |question_result| question_result.component_id }.compact.length.to_f
                  xml.percentage_of_respondents "#{ safe_div { numerator / denominator } }"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.component_id == component.id }.compact.length.to_f
                  denominator = @question_results[index].length.to_f
                  xml.percentage_of_total "#{ safe_div { numerator / denominator } }"

                  xml.survey_results(:type => 'array') do
                    @question_results[index].collect { |question_result| question_result if question_result.component_id == component.id }.compact.each do |question_result|
                      xml.survey_result_id "#{question_result.survey_result_id}"
                    end
                  end
                end
              end
              unless question.required
                xml.choice do
                  xml.value "Did not respond"
                  xml.response_count "#{@question_results[index].collect { |question_result| question_result if question_result.component_id == nil }.compact.length}"
                  xml.percentage_of_respondents "0.0"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.component_id == nil }.compact.length.to_f
                  denominator = @question_results[index].length
                  xml.percentage_of_total "#{ safe_div { numerator / denominator } }"
                end
              end
            end
          when "RatingQuestion"
            xml.respondent_count "#{@question_results[index].collect { |question_result| question_result.rating_label_id }.compact.length}"
            xml.choices(:type => 'array') do
              question.rating_scale.rating_labels.each do |rating_label|
                xml.choice do
                  xml.value "#{rating_label.key}"
                  xml.grade_point "#{rating_label.value}"
                  xml.id "#{rating_label.id}"
                  xml.response_count "#{@question_results[index].collect { |question_result| question_result if question_result.rating_label_id == rating_label.id }.compact.length}"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.rating_label_id == rating_label.id }.compact.length.to_f
                  denominator = @question_results[index].collect { |question_result| question_result.rating_label_id }.compact.length.to_f
                  xml.percentage_of_respondents "#{ safe_div { numerator / denominator } }"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.rating_label_id == rating_label.id }.compact.length.to_f
                  denominator = @question_results[index].length.to_f
                  xml.percentage_of_total "#{ safe_div { numerator / denominator } }"

                  xml.survey_results(:type => 'array') do
                    @question_results[index].collect { |question_result| question_result if question_result.rating_label_id == rating_label.id }.compact.each do |question_result|
                      xml.survey_result_id "#{question_result.survey_result_id}"
                    end
                  end
                end
              end
              unless question.required
                xml.choice do
                  xml.value "Did not respond"
                  xml.response_count "#{@question_results[index].collect { |question_result| question_result if question_result.rating_label_id == nil }.compact.length}"
                  xml.percentage_of_respondents "0.0"

                  numerator = @question_results[index].collect { |question_result| question_result if question_result.rating_label_id == nil }.compact.length.to_f
                  denominator = @question_results[index].length.to_f
                  xml.percentage_of_total "#{ safe_div { numerator / denominator } }"
                end
              end
            end
          end

          if question.type == "RatingQuestion"
            numerator = @question_results[index].inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
            denominator = @question_results[index].collect { |question_result| question_result.rating_label }.compact.length
            xml.gpa_of_respondents "#{ safe_div { numerator / denominator } }"

            numerator = @question_results[index].inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
            denominator = @question_results[index].length
            xml.gpa_of_total "#{ safe_div { numerator / denominator } }"
          end

          xml.results(:type => 'array') do
            @question_results[index].each do |question_result|
              xml.result do
                xml.survey_result_id "#{question_result.survey_result_id}"
                case question.type
                when "MultipleChoiceQuestion"
                  xml.response "#{question_result.component_id}"
                when "RatingQuestion"
                  xml.response "#{question_result.rating_label_id}"
                when "ShortAnswerQuestion"
                  xml.response "#{question_result.response}"
                end
              end
            end
          end
        end
      end
    end
  end
end