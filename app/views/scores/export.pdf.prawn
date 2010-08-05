pdf.text "Scoresheet for #{@assessment.long_name}(#{@assessment.klass.name})"
pdf.move_down(10) 
headers = ["Student email", "Name"] + @activities.collect{|a| "#{a.name}(#{a.max_score})"}
body = []
@students_scores.each do |student, scores|
	body <<  [student.email, student.name] + scores.collect{|s| s ? s.score : ""}
end
pdf.table body, :headers => headers, :border_style => :grid,  
				:row_colors => ["F6EFE1", "F5DFAC"], 
				:header_color => "BAA16E"
