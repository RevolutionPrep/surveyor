When /^I request (.*) with API version (.*)$/ do |page_name,version|
  case page_name
  when /the API survey page/
    get("/api/#{version.gsub('.','_')}/surveys/#{current_user.surveys.first.api_key}.xml")
  when /the bad API survey page/
    get("/api/#{version.gsub('.','_')}/surveys/badkey.xml")
  when /the API survey results page/
    get("/api/#{version.gsub('.','_')}/survey_results/#{current_user.survey_results.first.id}.xml")
  when /the bad API survey results page/
    get("/api/#{version.gsub('.','_')}/survey_results/bad_key.xml")
  when /multiple API survey results pages/
    get("/api/#{version.gsub('.','_')}/survey_results.xml?api_key=#{current_user.surveys.first.api_key}&results[]=#{current_user.survey_results.collect { |x| x.id }.join('&results[]=')}")
  when /the API question result page for "([^\"]*)"/
    handles = []
    $1.split(',').each do |statement|
      handles << Question.find_by_statement(statement).handle
    end
    get("/api/#{version.gsub('.','_')}/question_results/1.xml?api_key=#{current_user.surveys.first.api_key}&handles[]=#{handles.join('&handles[]=')}&results=#{current_user.survey_results.collect { |x| x.id }.join('&results[]=')}")
  when /the bad API question result page/
    get("/api/#{version.gsub('.','_')}/question_results/1.xml?api_key=bad_key")
  else
    raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
    "Now, go and add a mapping in #{__FILE__}"
  end
end

When /^I post (.*) with API version (.*)$/ do |page_name,version|
  case page_name
  when /a valid survey result/
    params = {"survey_result" => { 
        "class" => "TutorOrientation",
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("MultipleChoiceQuestion").id}" => current_user.components.first.id,
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("MultipleChoiceQuestion").id}_type" => "multiple_choice_question",
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("RatingQuestion").id}" => current_user.rating_scales.first.rating_labels.first.id,
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("RatingQuestion").id}_type" => "rating_question",
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("ShortAnswerQuestion").id}" => "Ryan",
        "#{current_user.surveys.first.api_key}_#{current_user.questions.find_by_type("ShortAnswerQuestion").id}_type" => "short_answer_question",
        "key" => "#{current_user.surveys.first.api_key}"
      }}
      post(	"/api/#{version.gsub('.','_')}/survey_results.xml",
      params
      )
  when /an invalid survey result/
    post("/api/#{version.gsub('.','_')}/survey_results.xml",
      "survey_result" => { 
        "class" => "TutorOrientation",
        "key" => "bad_key"
      }
    )
  else
    raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
    "Now, go and add a mapping in #{__FILE__}"
  end
end


Then /^I should see "([^\"]*)" in the XML response ([0-9]+) times?$/ do |text,count|
  doc = Nokogiri::XML::Document.parse(response.body)
  nodes = doc.root.xpath("descendant::#{text}").to_a
  nodes << doc.root.name if doc.root.name.match(/^#{text}$/)
  nodes.length.should eql(count.to_i)
end

Then /^I should see "([^\"]*)" in the XML response with content "([^\"]*)"$/ do |text,content|
  doc = Nokogiri::XML::Document.parse(response.body)
  nodes = doc.root.xpath("descendant::#{text}")
  nodes.to_s.should include(content)
end

Then /^the XML response should contain ([0-9]+) xpath nodes? matching "([^\"]*)"$/ do |count,xpath|
  doc = Nokogiri::XML::Document.parse(response.body)
  nodes = doc.root.xpath("#{xpath}")
  nodes.length.should eql(count.to_i)
end

Then /^the XML response xpath node matching "([^\"]*)" should have content "([^\"]*)"$/ do |xpath,content|
  doc = Nokogiri::XML::Document.parse(response.body)
  node = doc.root.xpath("#{xpath}")
  node.first.content.should eql(content)
end

Then /^I should get a response with status ([^\"]*)$/ do |status|
  response.status.should eql(status.to_i)
end
