xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rows do
  xml.page(params[:page])
  xml.total ((@total / params[:rows].to_f).ceil)
  xml.records(@total)
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