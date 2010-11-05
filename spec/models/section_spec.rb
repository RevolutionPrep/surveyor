require 'spec_helper'

module SectionSpecHelpers

  def valid_section_attributes
    {
      :title        => "value for title",
      :description  => "value for description",
      :position     => 1
    }
  end

end

describe Section, "validations" do
  include SectionSpecHelpers

  before(:each) do
    @section = Section.new
  end

  it "is valid given valid attributes" do
    @section.attributes = valid_section_attributes
    @section.should be_valid
  end
  
  it "has an error on title when title is blank" do
    @section.attributes = valid_section_attributes.except(:title)
    @section.should_not be_valid
    @section.should have(1).error_on(:title)
  end

end

describe Section, ".build_question(params)" do
  include SectionSpecHelpers
  
  before(:each) do
    @section = Section.new(valid_section_attributes)
  end
  
  it "builds a new MultipleChoiceQuestion record when passed a params hash with :type => 'MultipleChoiceQuestion'" do
    @section.build_question({ :type => "MultipleChoiceQuestion" })
    @section.questions.length.should eql(1)
    @section.questions[0].class.should eql(MultipleChoiceQuestion)
  end
  
  it "builds a new ShortAnswerQuestion record when passed a params hash with :type => 'ShortAnswerQuestion'" do
    @section.build_question({ :type => "ShortAnswerQuestion" })
    @section.questions.length.should eql(1)
    @section.questions[0].class.should eql(ShortAnswerQuestion)
  end
  
  it "builds a new RatingQuestion record when passed a params hash with :type => 'RatingQuestion'" do
    @section.build_question({ :type => "RatingQuestion" })
    @section.questions.length.should eql(1)
    @section.questions[0].class.should eql(RatingQuestion)
  end
  
end

describe Section, ".breadcrumb_parent" do
  include SectionSpecHelpers
  
  before(:each) do
    @survey = mock_model(Survey)
    @section = Section.new(valid_section_attributes.merge(:survey => @survey))
  end
  
  it "returns the survey that this section belongs to" do
    @section.breadcrumb_parent.should eql(@survey)
  end
  
end

describe Section, ".breadcrumb_title" do
  include SectionSpecHelpers
  
  before(:each) do
    @section = Section.new(valid_section_attributes)
  end
  
  it "returns the title of this section" do
    @section.breadcrumb_title.should eql(@section.title)
  end
  
end

describe Section, "acts_as_list" do
  include SectionSpecHelpers

  before(:each) do
    @survey_1 = mock_model(Survey)
    @survey_2 = mock_model(Survey)
    @section_1 = Section.new
    @section_2 = Section.new
  end

  it "prescribes the correct position to multiple sections belonging to the same survey" do
    @section_1.attributes = valid_section_attributes.merge(:survey => @survey_1)
    @section_2.attributes = valid_section_attributes.merge(:survey => @survey_1)
    @section_1.save
    @section_2.save
    @section_1.position.should eql(1)
    @section_2.position.should eql(2)
  end

  it "prescribes different positions to section belonging to different surveys " do
    @section_1.attributes = valid_section_attributes.merge(:survey => @survey_1)
    @section_2.attributes = valid_section_attributes.merge(:survey => @survey_2)
    @section_1.save
    @section_2.save
    @section_1.position.should eql(1)
    @section_2.position.should eql(1)
  end

end