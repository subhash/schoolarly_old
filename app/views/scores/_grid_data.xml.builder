xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rows do
  puts "params = "+params.inspect
  xml.page params[:page]
  xml.total (@students_scores.size.to_i / params[:rows].to_i)
  xml.records(@students_scores.size)
  @students_scores.each do |student, scores|
    xml.row :id => student.id do
      xml.cell link_to student.email, student
      xml.cell student.name
      scores.each do |score|
        xml.cell score.nil? ? " " :  score.score 
      end
    end
  end
end