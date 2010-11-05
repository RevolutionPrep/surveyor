module NavigationHelpers

  def path_to(page_name)
    case page_name

    #------- ROOT -------#
    when /the homepage/
      root_path
    
    #------- LOGIN/LOGOUT -------#
    when /the login page/
      login_path

    #------- USERS -------#
    when /the user new page/
      new_user_path
    when /the user edit page/
      edit_user_path(:current)

    #------- SURVEYS -------#
    when /the surveys index page/
      surveys_path
    when /the survey show page/
      survey_path(User.first.surveys.first)
    when /the survey new page/
      new_survey_path
    when /the survey edit page/
      edit_survey_path(User.first.surveys.first)
    when /the survey confirm delete page/
      confirm_delete_survey_path(User.first.surveys.first)
    when /the surveys index page in xml/
      surveys_path(:format => :xml)
    
    #------- SECTIONS -------#
    when /the sections index page/
      survey_sections_path(User.first.surveys.first)
    when /the section new page/
      new_survey_section_path(User.first.surveys.first)
    when /the section show page/
      section_path(User.first.surveys.first.sections.first)
    when /the section edit page/
      edit_section_path(User.first.surveys.first.sections.first)
    when /the section confirm delete page/
      confirm_delete_section_path(User.first.surveys.first.sections.first)
    when /a section page belonging to "(.+)"/
      section_path(User.find_by_username($1).surveys.first.sections.first)
    
    #------- QUESTIONS -------#
    when /the questions index page/
      section_questions_path(User.first.surveys.first.sections.first)
    when /the question show page/
      question_path(User.first.surveys.first.sections.first.questions.first)
    when /the question new page/
      new_section_question_path(User.first.surveys.first.sections.first)
    when /the question confirm delete page/
      confirm_delete_question_path(User.first.surveys.first.sections.first.questions.first)
    when /the question edit page/
      edit_question_path(User.first.surveys.first.sections.first.questions.first)
    when /a question edit page belonging to "(.+)"/
      edit_question_path(User.find_by_username($1).surveys.first.sections.first.questions.first)

    #------- COMPONENTS -------#
    when /the component confirm delete page/
      confirm_delete_component_path(User.first.components.first)

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
      "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)