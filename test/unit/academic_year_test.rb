require 'test_helper'

class AcademicYearTest < ActiveSupport::TestCase

  def setup
    @sboa = schools(:sboa)
    @stteresas = schools(:st_teresas)
    @stteresas_year = academic_years(:st_teresas_year)
  end
  
  test "school can have many academic years" do
    assert_equal @stteresas.academic_years.size, 3
  end
  
  test "current academic year is the one with the latest start_date for the school" do
    assert_equal @stteresas.academic_year, @stteresas_year
  end
  
end
