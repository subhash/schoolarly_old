require 'test_helper'

class AcademicYearTest < ActiveSupport::TestCase

  def setup
    @sboa_student = students(:sboa_student)
    @stteresas = schools(:st_teresas)
    @stteresas_year = academic_years(:st_teresas_year)
    @oneA = klasses(:one_A)
    @marykkutty = teachers(:marykkutty)
  end
  
  test "school can have many academic years" do
    assert_equal @stteresas.academic_years.size, 3
  end
  
  test "current academic year is the one with the latest start_date for the school" do
    assert_equal @stteresas.academic_year, @stteresas_year
  end
 
  test "academic year of a klass is its schools current academic year" do
    assert_equal @oneA.academic_year, @oneA.school.academic_year
  end
  
  test "a student can have an academic year which is his schools current academic year" do
    assert_equal @sboa_student.academic_year, @sboa_student.school.academic_year
  end

  test "a teacher can have an academic year which is his schools current academic year" do
    assert_equal @marykkutty.academic_year, @marykkutty.school.academic_year
  end

end
