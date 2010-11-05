class RatingQuestion < Question

  #------- Associations -------#
  belongs_to :rating_scale
  
  def type_as_string
    "Rating"
  end
  
  def count(survey_result_ids)
    self.class.connection.execute %Q{
      SELECT rating_label_id, count(DISTINCT question_results.id) AS num
      FROM `question_results`
      WHERE (`question_results`.`question_id` = #{id} AND `question_results`.`survey_result_id` IN (#{survey_result_ids}))
      AND (`question_results`.user_id = #{user.id})
      GROUP BY rating_label_id
    }
  end

end