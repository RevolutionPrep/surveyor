xml.survey do
  xml.key "#{@survey.api_key}"
  xml.questions(:type => 'array') do
    @survey.sections.collect { |section| section.questions }.flatten.each do |question|
      xml.question do
        xml.id "#{question.id}"
        xml.statement "#{question.statement}"
        xml.sub_type "#{question.type}"
        xml.multiple_answers "#{question.multiple_answers}"
        xml.user_entered_answer "#{question.user_entered_answer}"
        xml.required "#{question.required}"
        case question.type
        when "MultipleChoiceQuestion"
          xml.choices(:type => 'array') do
            question.components.each do |component|
              xml.choice do
                xml.value "#{component.value}"
                xml.id "#{component.id}"
              end
            end
          end
        when "RatingQuestion"
          xml.choices(:type => 'array') do
            question.rating_scale.rating_labels.each do |rating_label|
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
    end
  end
end