module SurveyorHelper

  # Find the latest survey based on title
  def SurveyorHelper.find(title_str)
    found = Survey.where{title =~ "#{title_str}%"}
    retval = (found) ? found.last : nil
  end


end

