class RatingLabel < ActiveRecord::Base

  #------- Associations -------#
  belongs_to :rating_scale
  belongs_to :user

end