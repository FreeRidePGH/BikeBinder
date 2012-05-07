module SurveyorUtil

  # Find the latest survey based on title
  def SurveyorUtil.find(title_str)
    found = Survey.where{title =~ "#{title_str}%"}
    retval = (found) ? found.last : nil
  end


end

