module PapersHelper
  def message_if_empty_papers
    return 'No paper available'
  end
  
  def message_if_empty_unallotted_papers
    return 'No more papers to add'
  end
  
end
