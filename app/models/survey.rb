class Survey < ActiveRecord::Base

  #------- Associations -------#
  has_many :sections, :order => :position, :dependent => :destroy
  has_many :survey_results
  belongs_to :user

  before_create :generate_api_key
  
  #------- Validations -------#
  validates_presence_of :title, :message => "cannot be blank"

  #------- Class Methods -------#
  def generate_api_key
    used_keys = Survey.all.collect { |survey| survey.api_key }
    key = ""
    while ( key.blank? || used_keys.include?(key) ) do
      key = ""
      5.times { key << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    end
    self.api_key = key
  end
  
  def breadcrumb_parent
    nil
  end
  
  def breadcrumb_title
    title
  end

end