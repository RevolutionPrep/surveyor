require 'spec_helper'

module RatingScaleSpecHelpers
  
  def valid_rating_scale_attributes
    {
      :name => "value for name",
      :user_id => 1
    }
  end
  
end

describe RatingScale, "validations" do
  include RatingScaleSpecHelpers
  
  before(:each) do
    @rating_scale = RatingScale.new
  end

  it "is valid given valid attributes" do
    @rating_scale.attributes = valid_rating_scale_attributes
    @rating_scale.should be_valid
  end
  
  it "has an error on name when name is blank" do
    @rating_scale.attributes = valid_rating_scale_attributes.except(:name)
    @rating_scale.should_not be_valid
    @rating_scale.should have(1).error_on(:name)
  end

end

describe RatingScale, ".new_rating_labels_attributes=(rating_labels_attributes)" do
  include RatingScaleSpecHelpers
  
  before(:each) do
    @rating_scale = RatingScale.new(valid_rating_scale_attributes)
  end
  
  it "builds new rating labels with the attributes from each hash" do
    @rating_scale.new_rating_labels_attributes = [ { :key => "A", :value => 1 }, { :key => "B", :value => 2 } ]
    @rating_scale.rating_labels.length.should eql(2)
    @rating_scale.rating_labels[0].key = "A"
    @rating_scale.rating_labels[0].value = 1
    @rating_scale.rating_labels[1].key = "B"
    @rating_scale.rating_labels[1].value = 2
  end
  
end

describe RatingScale, ".existing_rating_labels_attributes=(rating_labels_attributes)" do
  include RatingScaleSpecHelpers
  
  before(:each) do
    @rating_scale = RatingScale.new(valid_rating_scale_attributes)
  end
  
  it "updates existing rating labels using the attributes from each hash" do
    @rating_scale.rating_labels.build(:key => "A", :value => 1, :user_id => 1)
    @rating_scale.rating_labels.build(:key => "B", :value => 2, :user_id => 1)
    @rating_scale.save
    @rating_scale.existing_rating_labels_attributes = { @rating_scale.rating_labels[0].id.to_s => { :key => "C" }, @rating_scale.rating_labels[1].id.to_s => { :value => 3 } }
    @rating_scale.rating_labels.length.should eql(2)
    @rating_scale.rating_labels[0].key.should eql("C")
    @rating_scale.rating_labels[1].value.should eql(3)
  end
  
end

describe RatingScale, ".save_rating_labels" do
  include RatingScaleSpecHelpers
  
  before(:each) do
    @rating_scale = RatingScale.new(valid_rating_scale_attributes)
  end
  
  it "saves the rating labels associated to this rating scale" do
    @rating_scale.rating_labels.build(:key => "A", :value => 1, :user_id => 1)
    @rating_scale.rating_labels.build(:key => "B", :value => 2, :user_id => 1)
    @rating_scale.save_rating_labels
    @rating_scale.rating_labels.length.should eql(2)
    @rating_scale.rating_labels.each do |rating_label|
      rating_label.should_not be_new_record
    end
  end
  
end
