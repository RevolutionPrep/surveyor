module SafeDivisionHelper

  def safe_div(&block)
    result = yield
    raise ZeroDivisionError if result.nan?
    raise ZeroDivisionError if result.infinite?
    result
  rescue ZeroDivisionError
    nil
  end

end