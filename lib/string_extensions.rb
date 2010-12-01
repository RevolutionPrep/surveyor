class String
  
  def nobr
    self.gsub(" ", "&nbsp;")
  end
  
  def nl2br
    self.gsub("\n", "<br />")
  end
  
end