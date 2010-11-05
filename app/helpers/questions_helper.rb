module QuestionsHelper

  def fields_for_component(component, &block)
    prefix = component.new_record? ? 'new' : 'existing'
    fields_for("question[#{prefix}_components_attributes][]", component, &block)
  end

end