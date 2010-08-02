module StudentsHelper
    
  def trim(score)
    score.to_i == score ? score.to_i : score
  end
  
end
