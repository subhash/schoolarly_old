require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  
  def setup
    @sunil = teachers(:sunil)
    @treasa = teachers(:treasa)
    @rose = teachers(:rose)
    @mary = students(:mary)
    @stteresas = schools(:st_teresas)
    @level = levels(:three)
    @klass_with_students = klasses(:klass_with_students)
    @klass_with_papers = klasses(:klass_with_papers)
    @student1 = students(:student1_for_klass_with_students)
    @student2 = students(:student2_for_klass_with_students)
    @paper1 = papers(:paper1_for_klass_with_papers)
    @paper2 = papers(:paper2_for_klass_with_papers)
    @mal = school_subjects(:st_teresas_malayalam) 
    @eng = school_subjects(:st_teresas_english)
  end
  
  test "klass CRUD" do
    three_c = Klass.new(:level => @level, :division => 'C')
    assert_difference('@stteresas.klasses.size', 1) do 
      three_c.school = @stteresas
      three_c.save!
    end
    assert_equal AssessmentType.count, three_c.assessment_groups.size
    assert_difference('@stteresas.klasses.size', -1) do
      three_c.destroy
    end
  end
  
  test "klass can be destroyed" do
    three_c = Klass.new(:level => @level, :division =>'C')
    three_c.school = @stteresas
    three_c.save!
    assert three_c.can_be_destroyed
    assert !@klass_with_students.can_be_destroyed
    assert !@klass_with_papers.can_be_destroyed
  end
  
  test "klass belongs to school & it can have one class_teacher" do
    three_c = Klass.create(:level => @level, :division =>'C', :school => @stteresas, :teacher_id => @sunil.id)
    assert_equal three_c.school, @stteresas
    assert @stteresas.klasses.include?(three_c)
    assert_equal three_c.class_teacher, @sunil
    assert @sunil.owned_klasses.include?(three_c)
  end
  
  test "klass has many students" do
    assert_equal 2, @klass_with_students.students.size    
    assert_equal @klass_with_students, @student1.klass
    assert_equal @klass_with_students, @student2.klass
  end
  
  test "klass has many papers" do
    assert_equal 2, @klass_with_papers.papers.size    
    assert_equal @klass_with_papers, @paper1.klass
    assert_equal @klass_with_papers, @paper2.klass
  end
  
  test "klass has many school_subjects and teachers through papers" do
    assert_equal 2, @klass_with_papers.school_subjects.size
    assert @klass_with_papers.school_subjects.include?(@paper1.school_subject)
    assert @klass_with_papers.school_subjects.include?(@paper2.school_subject)
    assert_equal 2, @klass_with_papers.teachers.size
    assert @klass_with_papers.teachers.include?(@paper1.teacher)
    assert @klass_with_papers.teachers.include?(@paper2.teacher)
  end
  
  test "klass belongs to school" do
    klass = Klass.new(:level => @level, :division => 'C')
    @stteresas.klasses << klass
    assert_equal klass.school, @stteresas
  end
  
  test "klass belongs to level" do
    klass = Klass.new(:level => @level, :division => 'C', :school => @stteresas)
    klass.save!
    assert_equal klass.level, @level
  end
  
  test "users return teacher users & student users of the klass" do
    assert_difference('@klass_with_students.reload.users.size',3) do
      assert_difference('@klass_with_students.reload.teacher_users.size',3) do
        paper1 = Paper.create(:klass => @klass_with_students, :school_subject => @eng, :teacher => @sunil)
        paper2 = Paper.create(:klass => @klass_with_students, :school_subject => @mal, :teacher => @treasa)
        @klass_with_students.class_teacher = @rose
        @klass_with_students.save!
      end
    end
  end
  
  test "users, student users & teacher users of the klass" do
    assert_difference('@klass_with_papers.users.size', 2) do
      assert_difference('@klass_with_papers.reload.student_users.size', 1) do
        @mary.klass = @klass_with_papers
        @mary.save!
      end
      assert_difference('@klass_with_papers.reload.teacher_users.size', 1) do
        @klass_with_papers.class_teacher = @rose
        @klass_with_papers.save!          
      end
    end
  end
  
  test "division should be unique for school-level combination" do
    klass1 = Klass.create(:school => @stteresas, :level => @level, :division => 'A')
    klass2 = Klass.new(:school => @stteresas, :level => @level, :division => 'A')
    assert !klass2.valid?
  end

end