case params[:version]

when "1_0", "1_1"

  xml.survey_result do
    xml.id "#{@survey_result.id}"
    xml.question_results(:type => 'array') do
      @survey_result.survey.sections.each do |section|
        section.questions.each do |question|
          @survey_result.question_results.reject { |r| r.question.id != question.id }.each do |question_result|
            xml.question_result do
              xml.question do
                xml.id "#{question_result.question.id}"
                xml.statement "#{question_result.question.statement}"
                xml.sub_type "#{question_result.question.type}"
                xml.multiple_answers "#{question_result.question.multiple_answers}"
                xml.user_entered_answer "#{question_result.question.user_entered_answer}"
                xml.required "#{question_result.question.required}"
                case question_result.question.type
                when "MultipleChoiceQuestion"
                  xml.choices(:type => 'array') do
                    question_result.question.components.each do |component|
                      xml.choice do
                        xml.value "#{component.value}"
                        xml.id "#{component.id}"
                      end
                    end
                  end
                when "RatingQuestion"
                  xml.choices(:type => 'array') do
                    question_result.question.rating_scale.rating_labels.each do |rating_label|
                      xml.choice do
                        xml.value "#{rating_label.key}"
                        xml.id "#{rating_label.id}"
                      end
                    end
                  end
                when "ShortAnswerQuestion"
                  xml.choices(:type => 'array') do

                  end
                end
              end
              case question_result.question.type
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