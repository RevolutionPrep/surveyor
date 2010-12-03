class ActionController::Base

  def with_placeholder(placeholder = :placeholder)
    case Rails.env
    when "development", "test"
      yield
    else
      render placeholder
    end
  end

end