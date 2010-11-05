class ShortAnswerQuestion < Question

  def type_as_string
    "Short Answer"
  end
  
  def count(survey_result_ids)
    self.class.connection.execute %Q{ SET SESSION group_concat_max_len = 32768 }
    self.class.connection.execute %Q{
      SELECT count(DISTINCT id) AS completed_response_count, question_id, group_concat(DISTINCT response SEPARATOR \"|||\" )
      FROM `question_results`
      WHERE (`question_results`.`question_id` = #{id} AND `question_results`.`survey_result_id` IN (#{survey_result_ids}))
      AND (`question_results`.user_id = #{user.id})
      AND (response IS NOT NULL AND CHAR_LENGTH(response) > 4)
      GROUP BY question_id
    }
  end

end