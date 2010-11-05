require 'spec_helper'

module QuestionSpecHelpers

  def valid_question_attributes
    survey = mock_model(Survey)
    attributes = {
      :section          => mock_model(Section, :survey => survey, :questions => []),
      :statement        => "Statement",
      :position         => 1,
      :required         => false,
      :user             => mock_model(User),
      :multiple_answers => false
    }
    survey.stub(:sections).and_return([attributes[:section]])
    attributes
  end

end

describe Question, "validations" do
  include QuestionSpecHelpers

  before(:each) do
    @question = Question.new
  end

  it "is valid given valid attributes" do
    @question.attributes = valid_question_attributes
    @question.should be_valid
  end

  it "has an error on statement when statement is blank" do
    @question.attributes = valid_question_attributes.except(:statement)
    @question.should_not be_valid
    @question.should have(1).error_on(:statement)
  end

end

describe Question, ".generate_handle" do
  include QuestionSpecHelpers

  before(:each) do
    @question_1 = Question.new
    @question_2 = Question.new
    @section = mock_model(Section, :questions => [])
    @survey = mock_model(Survey, :sections => [@section])
    @section.stub(:survey).and_return(@survey)
    @question_1.attributes = valid_question_attributes.merge(:section => @section)
    @question_1.attributes = valid_question_attributes.merge(:section => @section)
    @question_2.attributes = valid_question_attributes.merge(:section => @section)
  end

  it "generates a random key that is 5 characters long" do
    @question_1.generate_handle.length.should eql(5)
  end

  it "generates a unique key at the scope of the survey this question belongs to" do
    @question_1.generate_handle
    @section.stub(:questions).and_return([@question_1])
    @question_2.generate_handle.should_not eql(@question_1.handle)
  end

end

describe Question, ".type_as_string" do
  include QuestionSpecHelpers

  it "returns 'Question' if the type is not one of the three subclasses of Question" do
    @question = Question.new(valid_question_attributes)
    @question.type_as_string.should eql("Question")
  end

end

describe Question, ".morph_to" do
  include QuestionSpecHelpers

  before(:each) do
    @question = Question.new(valid_question_attributes)
  end

  it "creates a new MultipleChoiceQuestion using the params of this question" do
    @new_question = @question.morph_to("MultipleChoiceQuestion")
    @new_question.class.should eql(MultipleChoiceQuestion)
    @new_question.section.should == @question.section # using == since we don't care about object identity here
    @new_question.statement.should eql(@question.statement)
    @new_question.position.should eql(@question.position)
    @new_question.required.should eql(@question.required)
    @new_question.user.should == @question.user
    @new_question.multiple_answers.should eql(@question.multiple_answers)
  end

  it "creates a new ShortAnswerQuestion using the params of this question" do
    @new_question = @question.morph_to("ShortAnswerQuestion")
    @new_question.class.should eql(ShortAnswerQuestion)
    @new_question.section.should == @question.section # using == since we don't care about object identity here
    @new_question.statement.should eql(@question.statement)
    @new_question.position.should eql(@question.position)
    @new_question.required.should eql(@question.required)
    @new_question.user.should == @question.user
  end

  it "creates a new RatingQuestion using the params of this question" do
    @new_question = @question.morph_to("RatingQuestion")
    @new_question.class.should eql(RatingQuestion)
    @new_question.section.should == @question.section # using == since we don't care about object identity here
    @new_question.statement.should eql(@question.statement)
    @new_question.position.should eql(@question.position)
    @new_question.required.should eql(@question.required)
    @new_question.user.should == @question.user
    @new_question.multiple_answers.should eql(@question.multiple_answers)
  end

end

describe Question, ".new_components_attributes=(components_attributes)" do
  include QuestionSpecHelpers

  before(:each) do
    @question = Question.new(valid_question_attributes)
  end

  it "builds new component records with the attributes from each hash" do
    @question.new_components_attributes = [ { :value => "A" }, { :value => "B" } ]
    @question.components.length.should eql(2)
    @question.components[0].value.should eql("A")
    @question.components[1].value.should eql("B")
  end

end

describe Question, ".existing_components_attributes=(components_attributes)" do
  include QuestionSpecHelpers

  before(:each) do
    @question = Question.new(valid_question_attributes)
  end

  it "updates existing components using the attributes from each hash" do
    @question.components.build(:value => "A", :question_id => 1, :user_id => 1)
    @question.components.build(:value => "B", :question_id => 1, :user_id => 1)
    @question.save
    @question.existing_components_attributes = { @question.components[0].id.to_s => { :value => "C" }, @question.components[1].id.to_s => { :value => "D" } }
    @question.components.length.should eql(2)
    @question.components[0].value.should eql("C")
    @question.components[1].value.should eql("D")
  end
  
  context "when the existing component is updated with a value that is blank" do
    
    it "destroys the component that has a blank value" do
      @question.components.build(:value => "A", :question_id => 1, :user_id => 1)
      @question.components.build(:value => "B", :question_id => 1, :user_id => 1)
      @question.save
      @question.components[0].should_receive(:destroy)
      @question.existing_components_attributes = { @question.components[0].id.to_s => { }, @question.components[1].id.to_s => { :value => "D" } }
      @question.components[1].value.should eql("D")
    end
    
  end

end

describe Question, ".save_components" do
  include QuestionSpecHelpers

  before(:each) do
    @question = MultipleChoiceQuestion.new(valid_question_attributes)
  end

  it "saves components if this question is a multiple choice question" do
    @question.components.build(:value => "A", :question_id => 1, :user_id => 1)
    @question.components.build(:value => "B", :question_id => 1, :user_id => 1)
    @question.save_components
    @question.components.length.should eql(2)
    @question.components.each do |component|
      component.should_not be_new_record
    end
  end

end

describe Question, "acts_as_list" do
  include QuestionSpecHelpers

  before(:each) do
    @survey = mock_model(Survey, :sections => [])
    @question_1 = Question.new
    @question_2 = Question.new
  end

  it "prescribes the correct position to multiple questions belonging to the same section" do
    @section = mock_model(Section, :survey => @survey)
    @question_1.attributes = valid_question_attributes.merge(:section => @section)
    @question_2.attributes = valid_question_attributes.merge(:section => @section)
    @question_1.save
    @question_2.save
    @question_1.position.should eql(1)
    @question_2.position.should eql(2)
  end

  it "prescribes different positions to questions belonging to different sections " do
    @section_1 = mock_model(Section, :survey => @survey)
    @section_2 = mock_model(Section, :survey => @survey)
    @question_1.attributes = valid_question_attributes.merge(:section => @section_1)
    @question_2.attributes = valid_question_attributes.merge(:section => @section_2)
    @question_1.save
    @question_2.save
    @question_1.position.should eql(1)
    @question_2.position.should eql(1)
  end

end

describe Question, ".breadcrumb_parent" do
  include QuestionSpecHelpers
  
  before(:each) do
    @section = mock_model(Section)
    @question = Question.new(valid_question_attributes.merge(:section => @section))
  end
  
  it "returns the section that this question belongs to" do
    @question.breadcrumb_parent.should eql(@section)
  end
  
end

describe Question, ".breadcrumb_title" do
  include QuestionSpecHelpers
  
  before(:each) do
    @question = Question.new(valid_question_attributes)
  end
  
  it "returns the statement for this question" do
    @question.breadcrumb_title.should eql(@question.statement.nobr)
  end
  
end