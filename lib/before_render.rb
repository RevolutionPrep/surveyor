module BeforeRender
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def render(*args)
    self.class.before_render_callbacks.each do |method|
      self.send(method)
    end
    super
  end
  
  module ClassMethods
    
    def before_render_callbacks
      @before_render_callbacks ||= []
    end

    def before_render(*methods)
      methods.each do |method|
        before_render_callbacks << method unless before_render_callbacks.include?(method)
      end
    end
    
  end

end

class ActionController::Base
  include BeforeRender
end