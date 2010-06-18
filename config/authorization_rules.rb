authorization do
  
  same_user = proc do
    if_attribute :user => is {user}
  end
  
  same_school = proc do
    if_attribute :school => is {user.person.school}, :school => is_not {nil}
  end
  
  same_klass = proc do
    if_attribute :klass => {:class_teacher => is {user.person}}
  end
  
  role :guest do
  end
  
  role :student do
    has_permission_on [:schools, :klasses, :teachers, :students], :to => :read, &same_school
    has_permission_on :exams, :to => :read do
      if_attribute :students => contains {user.person}
    end
    has_permission_on :scores, :to => :read do
      if_permitted_to :read, :exam
    end
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students, :klasses], :to => :contact, &same_school
  end
  
  role :teacher do
    includes :student
    has_permission_on :klasses, :to => :add_remove_students, &same_klass
    has_permission_on :students, :to => :add_remove_papers, &same_klass
    has_permission_on :students, :to => :add_to_klass do
      if_attribute :klass => is {nil}, :school => is {user.person.school}
    end
    has_permission_on :teachers, :to => :read_write, &same_user
    has_permission_on :students, :to => :read, &same_school
    has_permission_on :students, :to => :read_write do
      if_attribute :klass => is { nil }, :school => is {user.person.school}
      if_attribute :klass => {:class_teacher => is {user.person}}
    end
    has_permission_on :klasses, :to => :manage, &same_school
    has_permission_on :exams, :to => :manage do
      if_permitted_to :manage, :klass
    end
    has_permission_on :scores, :to => :manage do
      if_permitted_to :manage, :exam
    end
    has_permission_on :papers, :to => :manage do
      if_permitted_to :manage, :klass
    end
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students, :klasses], :to => :contact, &same_school
  end
  
  role :school do
    includes :teacher
    has_permission_on :klasses, :to => [:add_remove_students, :update], &same_school
    has_permission_on [:klasses, :students, :teachers], :to => :create, &same_school
    has_permission_on :students, :to => :add_to_klass do
      if_attribute :klass => is {nil}, :school => is {user.person}
    end
    has_permission_on [:klasses, :teachers], :to => :add_remove_papers, &same_school
    has_permission_on :students, :to => :add_remove_papers do
      if_attribute :klass => is_not {nil}, :school => is {user.person}
    end
    has_permission_on :students, :to => :manage, &same_school
    has_permission_on :teachers, :to => :manage, &same_school
    has_permission_on :schools, :to => :read_write, &same_user
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students, :klasses], :to => :contact, &same_school
    has_permission_on [:schools, :teachers, :students], :to => :alter, &same_school
  end
  
  role :schoolarly_admin do
    has_permission_on [:teachers, :students], :to => :add_to_school do
      if_attribute :school => is {nil}
    end
    has_permission_on :students, :to => :add_to_klass do
      if_attribute :klass => is {nil}
    end
    has_permission_on :klasses, :to => :add_remove_papers
    has_permission_on :teachers, :to => :add_remove_papers do
      if_attribute :school => is_not {nil}
    end
    has_permission_on :students, :to => :add_remove_papers do
      if_attribute :klass => is_not {nil}
    end
    has_permission_on [:users, :schools, :teachers, :students, :klasses, :exams, :scores, :papers, :user_profiles], :to => :manage
    has_permission_on [:schools, :teachers, :students, :klasses], :to => :contact
    has_permission_on [:schools, :teachers, :students], :to => :alter
    #has_permission_on :authorization_rules, :to => :manage
  end
  
end

privileges do
  privilege :manage, :includes => [:create, :delete, :read_write]
  privilege :read_write, :includes => [:read, :update]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => [:new, :add]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end