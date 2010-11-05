unless request.post?
  xml.question_result do
    xml.total_count "#{params[:hash][:results].split(",").length rescue 0}"
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
                  denominator = @question_results[index].length.to_f
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

          numerator = @question_results[index].inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
          denominator = @question_results[index].collect { |question_result| question_result.rating_label }.compact.length.to_f
          xml.gpa_of_respondents "#{ safe_div { numerator / denominator } }" if question.type == "RatingQuestion"

          numerator = @question_results[index].inject(0) { |sum, question_result| sum + (question_result.rating_label.value rescue 0).to_f }
          denominator = @question_results[index].length.to_f
          xml.gpa_of_total "#{ safe_div { numerator / denominator } }" if question.type == "RatingQuestion"

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
else
  xml.question_result do
    xml.total_count "#{params[:hash][:results].split(",").length rescue 0}"
    xml.questions(:type => 'array') do
      @questions.each_with_index do |question,index|
        xml.question do
          xml.id "#{question.id}"
          xml.handle "#{question.handle}"
          xml.statement "#{question.statement}"
          xml.sub_type "#{question.type.to_s}"
          xml.multiple_answers "#{question.multiple_answers}"
          xml.user_entered_answer "#{question.user_entered_answer}"
          xml.required "#{question.required}"
          case question.type.to_s
          when "MultipleChoiceQuestion"
            xml.respondent_count "#{@question_counts[question.id].inject(0) { |sum,count| sum += count.second.to_i }}"
            xml.choices(:type => 'array') do
              question.components.each do |component|
                xml.choice do
                  xml.value "#{component.value}"
                  xml.id "#{component.id}"
                  xml.response_count "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:count]}"
                  xml.percentage_of_respondents "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:percentage_of_respondents]}"
                  xml.percentage_of_respondents "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:percentage_of_total]}"
                  xml.survey_results(:type => 'array') do
                    @question_results[index].collect { |question_result|
                      question_result if question_result.component_id == component.id
                    }.compact.each do |question_result|
                      xml.survey_result_id "#{question_result.survey_result_id}"
                    end
                  end
                end
              end
              unless question.required
                xml.choice do
                  xml.value "Did not respond"
                  xml.response_count "#{@question_counts[question.id.to_s][:result_counts][""][:count]}"
                  xml.percentage_of_respondents "0.0"
                  xml.percentage_of_total "#{@question_counts[question.id.to_s][:result_counts][""][:percentage_of_total]}"
                end
              end
            end
          when "RatingQuestion"
            xml.respondent_count "#{@question_counts[question.id.to_s][:respondent_count]}"
            xml.choices(:type => 'array') do
              question.rating_scale.rating_labels.each do |rating_label|
                xml.choice do
                  xml.value "#{rating_label.key}"
                  xml.grade_point "#{rating_label.value}"
                  xml.id "#{rating_label.id}"
                  xml.response_count "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:count]}"
                  xml.percentage_of_respondents "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:percentage_of_respondents]}"
                  xml.percentage_of_total "#{@question_counts[question.id.to_s][:result_counts][rating_label.id.to_s][:percentage_of_total]}"
                  xml.survey_results(:type => 'array') do
                    @question_results[index].collect { |question_result|
                      question_result if question_result.rating_label_id == rating_label.id
                    }.compact.each do |question_result|
                      xml.survey_result_id "#{question_result.survey_result_id}"
                    end
                  end
                end
              end
              unless question.required
                xml.choice do
                  xml.value "Did not respond"
                  xml.response_count "#{@question_counts[question.id.to_s][:result_counts][""][:count]}"
                  xml.percentage_of_respondents "0.0"
                  xml.percentage_of_total "#{@question_counts[question.id.to_s][:result_counts][""][:percentage_of_total]}"
                end
              end
            end
          when "ShortAnswerQuestion"
            xml.results(:type => 'array') do
              if @short_answer_results and !@short_answer_results.empty?
                @short_answer_results.first.split("|||").each do |response|
                  xml.result do
                    xml.response "#{response}"
                  end
                end
              end
            end
          end

          xml.gpa_of_respondents "#{@question_counts[question.id.to_s][:gpa_of_respondents]}" if question.type == "RatingQuestion"
          xml.gpa_of_total "#{@question_counts[question.id.to_s][:gpa_of_total]}" if question.type == "RatingQuestion"
        end
      end
    end
  end
end