authorization do
  
  same_user = proc do
    if_attribute :user => is {user}
  end
  
  same_school = proc do
    if_attribute :school => is {user.person.school}
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
    has_permission_on :user_profiles, :to => :manage, &same_user
  end
  
  role :teacher do
    includes :student
    has_permission_on :teachers, :to => :read_write, &same_user
    has_permission_on :students, :to => :manage, &same_school
    has_permission_on :klasses, :to => :manage, &same_school
    has_permission_on :exams, :to => :manage do
      if_permitted_to :manage, :klass
    end
    has_permission_on :papers, :to => :manage do
      if_permitted_to :manage, :klass
    end
    has_permission_on :user_profiles, :to => :manage, &same_user
  end
  
  role :school do
    includes :teacher
    has_permission_on :teachers, :to => :manage, &same_school
    has_permission_on :schools, :to => :read_write, &same_user
    has_permission_on :user_profiles, :to => :manage, &same_user
  end
  
  role :schoolarly_admin do
    has_permission_on [:schools, :teachers, :students, :klasses, :exams, :papers, :user_profiles], :to => :manage
    #has_permission_on :authorization_rules, :to => :manage
  end
  
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read_write, :includes => [:read, :update]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => [:new, :add]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end