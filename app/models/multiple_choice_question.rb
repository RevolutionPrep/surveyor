class MultipleChoiceQuestion < Question

  #------- Associations -------#
  has_many :components, :foreign_key => "question_id", :order => :position, :dependent => :destroy
  
  def type_as_string
    "Multiple Choice"
  end
  
  def count(survey_result_ids)
    self.class.connection.execute %Q{
      SELECT component_id, count(DISTINCT question_results.id) AS num
      FROM `question_results`
      WHERE (`question_results`.`question_id` = #{id} AND `question_results`.`survey_result_id` IN (#{survey_result_ids}))
      AND (`question_results`.user_id = #{user.id})
      GROUP BY component_id
    }
  end

end