module RatingScalesHelper

  def fields_for_rating_label(rating_label, &block)
    prefix = rating_label.new_record? ? 'new' : 'existing'
    fields_for("rating_scale[#{prefix}_rating_labels_attributes][]", rating_label, &block)
  end

end