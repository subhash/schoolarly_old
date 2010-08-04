pdf.text "Student Evaluation profile for #{@student.name} - #{@student.klass.name}",  :size => 15, :style => :bold, :align => :center
pdf.move_down(10) 

AssessmentType.terms.each do |term|
	headers = ["SUBJECT"]
	weightage_total = 0
	AssessmentType.for_term(term).FA.each do |type|
		headers << "#{type.name}(#{trim(weightage_for_type_in_klass(type,@student.klass))}%)"
		weightage_total += weightage_for_type_in_klass(type,@student.klass)
	end
	headers << "TOTAL(FA) #{trim(weightage_total)}%"
	AssessmentType.for_term(term).SA.each do |type|
		headers << "#{type.name}(#{trim(weightage_for_type_in_klass(type,@student.klass))}%)"
		weightage_total += weightage_for_type_in_klass(type,@student.klass)
	end
	headers << "TOTAL#{term}(FA+SA) #{trim(weightage_total)} %"
	body = []
	@student.papers.each do |paper|
		row = [paper.name]
		total = 0
		AssessmentType.for_term(term).FA.each do |type|
			row << trim(weighted_score = paper.assessments.select{|a|a.name == type.name}.first.weighted_score_for(@student))
			total+= weighted_score if weighted_score
		end
		row << trim(total)
		AssessmentType.for_term(term).SA.each do |type|
			row << trim(weighted_score = paper.assessments.select{|a|a.name == type.name}.first.weighted_score_for(@student))
			total+= weighted_score if weighted_score
		end
		row << trim(total)
		body << row
	end	
	pdf.text "TERM#{term}"
	pdf.table body, :headers => headers, :border_style => :grid,  
  					:row_colors => ["F6EFE1", "F5DFAC"], 
  					:header_color => "BAA16E"
  	pdf.move_down(30)  
end

headers = ["SUBJECT", "GRAND TOTAL (Term 1 + Term 2)", "GRADE"]
rows = @student.papers.map do |paper|
	[paper.name, trim(paper.total_score_for(@student)), Score.grade(paper.total_score_for(@student))]
end
pdf.move_down(10)
pdf.text "TERM 1 + 2"
pdf.table rows, :headers => headers, :border_style => :grid,  
  				:row_colors => ["F6EFE1", "F5DFAC"], 
  				:header_color => "BAA16E"
  				
