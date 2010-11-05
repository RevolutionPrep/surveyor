class Section < ActiveRecord::Base

  #------- Plugin Behavior -------#
  acts_as_list :scope => :survey

  #------- Associations -------#
  has_many :questions, :order => :position, :dependent => :destroy
  belongs_to :survey
  belongs_to :user

  #------- Validations -------#
  validates_presence_of :title, :message => "cannot be blank"

  #------- Class Methods -------#

  def build_question(params)
    case params[:type]
    when "MultipleChoiceQuestion"
      question = MultipleChoiceQuestion.new(params)
    when "ShortAnswerQuestion"
      question = ShortAnswerQuestion.new(params)
    when "RatingQuestion"
      question = RatingQuestion.new(params)
    end
    question.user = self.user
    questions << question
    question
  end
  
  def breadcrumb_parent
    survey
  end
  
  def breadcrumb_title
    title
  end

end