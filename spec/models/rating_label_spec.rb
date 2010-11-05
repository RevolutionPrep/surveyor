require 'spec_helper'

module RatingLabelSpecHelpers

  def valid_rating_label_attributes
    {
      :key   => "value for key",
      :value => "value for value"
    }
  end

end

describe RatingLabel do
  include RatingLabelSpecHelpers

  before(:each) do
    @rating_label = RatingLabel.new
  end

  it "should create a new instance given valid attributes" do
    @rating_label.attributes = valid_rating_label_attributes
    @rating_label.should be_valid
  end

end