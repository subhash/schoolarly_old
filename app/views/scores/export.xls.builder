xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.instruct! :mso_application, :progid => "Excel.Sheet"
xml.Workbook({
  'xmlns'      => "urn:schemas-microsoft-com:office:spreadsheet", 
  'xmlns:o'    => "urn:schemas-microsoft-com:office:office",
  'xmlns:x'    => "urn:schemas-microsoft-com:office:excel",    
  'xmlns:html' => "http://www.w3.org/TR/REC-html40",
  'xmlns:ss'   => "urn:schemas-microsoft-com:office:Spreadsheet" 
}) do
  xml.Worksheet 'ss:Name' => "Scores for #{@title}" do
    xml.Table do
      # Header
      xml.Row do
          xml.Cell { xml.Data 'Student email', 'ss:Type' => 'String' }
          xml.Cell { xml.Data 'Name', 'ss:Type' => 'String' }
          @activities.each do |activity|
            xml.Cell { xml.Data "#{activity.name}(#{activity.max_score})", 'ss:Type' => 'String' }
          end
      end
      
      # Rows
      @students_scores.each do |student, scores|
        xml.Row do
          xml.Cell {xml.Data  student.email, 'ss:Type' => 'String'}
          xml.Cell {xml.Data  student.name, 'ss:Type' => 'String'}
          scores.each do |score|
            xml.Cell {xml.Data score ? score.score : nil, 'ss:Type' => 'Number'}
          end
        end
      end
    end
  end
end