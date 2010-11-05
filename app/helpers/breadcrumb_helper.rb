module BreadcrumbHelper
  
  def breadcrumb_for(object)
    html = ""
    while(object.respond_to?(:breadcrumb_parent))
      html = link_to(ERB::Util.html_escape(object.breadcrumb_title).try(:nobr), object) + " &raquo; ".html_safe + html unless object.new_record?
      html = link_to(object.class.to_s.pluralize, [object.breadcrumb_parent, object.class.to_s.pluralize.underscore.to_sym]) + " &raquo; ".html_safe + html
      object = object.breadcrumb_parent
    end
    html
  end
  
end