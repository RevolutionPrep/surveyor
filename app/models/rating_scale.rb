class RatingScale < ActiveRecord::Base

  #------- Associations -------#
  belongs_to :user

  has_many :rating_labels, :dependent => :destroy
  has_many :rating_questions

  #------- Validations -------#
  validates_presence_of :name

  #------- Callbacks -------#
  after_update :save_rating_labels

  #------- Virtual Attributes -------#

  def new_rating_labels_attributes=(rating_labels_attributes)
    rating_labels_attributes.each do |attributes|
      unless attributes[:value].blank?
        rating_labels.build(attributes)
      end
    end
  end

  def existing_rating_labels_attributes=(rating_labels_attributes)
    existing_rating_labels = rating_labels.reject(&:new_record?).sort { |a,b| a.value <=> b.value }
    existing_rating_labels.each do |rating_label|
      attributes = rating_labels_attributes[rating_label.id.to_s]
      rating_label.attributes = attributes
    end
  end

  #------- Callback Methods -------#

  def save_rating_labels
    rating_labels.each do |rating_label|
      rating_label.save(:validate => false)
    end
  end


end