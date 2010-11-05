class Question < ActiveRecord::Base

  #------- Plugin Behavior -------#
  acts_as_list :scope => :section

  #------- Associations -------#
  belongs_to :section
  belongs_to :user
  has_many :question_results
  has_many :components

  #------- Callbacks -------#
  before_create :generate_handle
  after_update :save_components

  #------- Validations -------#
  validates_presence_of :statement, :message => "cannot be blank"

  #------- Class Methods -------#

  def generate_handle
    used_keys = section.survey.sections.collect { |section| section.questions }.flatten.collect { |question| question.handle }.compact
    key = ""
    while ( key.blank? || used_keys.include?(key) ) do
      key = ""
      5.times { key << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    end
    self.handle = key
  end

  def type_as_string
    "Question"
  end

  #######################################################################
  # morph_to takes a STI SubClass type and creates a new instance of    #
  # this type with the attributes of the existing type, then deletes    #
  # the existing Question, essentially morphing the Question to the     #
  # chosen SubClass. This could be re-written to be more self-contained #
  #######################################################################
  def morph_to(type)
    params = { :section => section, :statement => statement, :position => position, :required => required, :user => user }
    multi_ans = { :multiple_answers => multiple_answers }
    delete
    case type
    when "MultipleChoiceQuestion"
      morph = MultipleChoiceQuestion.create!(params.merge(multi_ans))
    when "ShortAnswerQuestion"
      morph = ShortAnswerQuestion.create!(params)
    when "RatingQuestion"
      morph = RatingQuestion.create!(params.merge(multi_ans))
    end
  end

  #------- Virtual Attributes -------#
  def new_components_attributes=(components_attributes)
    components_attributes.each do |attributes|
      unless attributes[:value].blank?
        components.build(attributes)
      end
    end
  end

  def existing_components_attributes=(components_attributes)
    existing_components = components.reject(&:new_record?).sort { |a,b| b.position <=> a.position }
    existing_components.each do |component|
      attributes = components_attributes[component.id.to_s]
      if attributes[:value].blank?
        component.destroy
      else
        component.attributes = attributes
      end
    end
  end

  #------- Callback Methods -------#

  def save_components
    if type == "MultipleChoiceQuestion"
      components.each do |component|
        component.save(:validate => false)
      end
    end
  end
  
  def breadcrumb_parent
    section
  end
  
  def breadcrumb_title
    statement
  end

end