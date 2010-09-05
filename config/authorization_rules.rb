authorization do
  
  same_user = proc do
    if_attribute :user => is {user}
  end
  
  same_school = proc do
    if_attribute :school => is {user.person.school} 
    if_attribute :school => is_not {nil}
  end
  
  same_klass = proc do
    if_attribute :klass => is {user.person.klass} 
    if_attribute :klass => is_not {nil}
  end
  
  role :guest do
  end
  
  role :student do
    has_permission_on [:schools, :klasses, :teachers, :students], :to => :read, :join_by => :and, &same_school
    has_permission_on :activities, :to => :read, :join_by => :and, &same_klass
    has_permission_on :scores, :to => :read do
      if_permitted_to :read, :activity
    end
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students, :klasses, :papers], :to => :contact, :join_by => :and, &same_school
  end
  
  role :teacher do
    has_permission_on :schools, :to => :read, :join_by => :and, &same_school 
    has_permission_on :teachers, :to => :read_write, &same_user
    has_permission_on :students, :to => :read_write, :join_by => :and, &same_school
    has_permission_on :klasses, :to => :manage, :join_by => :and, &same_school
    has_permission_on :assessment_groups, :to => :manage, :join_by => :and do
      if_permitted_to :manage, :klass
    end
    has_permission_on :assessments, :to => :manage, :join_by => :and do
      if_permitted_to :manage, :assessment_group
    end
    has_permission_on :assessment_tools, :to => :manage, :join_by => :and do
      if_permitted_to :manage, :assessment
    end
    has_permission_on :activities, :to => :manage, :join_by => :and do
      if_permitted_to :manage, :assessment_tool
    end
    has_permission_on :scores, :to => :manage, :join_by => :and do
      if_permitted_to :manage, :activity
    end
    has_permission_on :papers, :to => :manage do
      if_permitted_to :manage, :klass
    end
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students, :klasses, :papers], :to => :contact, :join_by => :and, &same_school
  end
  
  role :school do
    includes :teacher
    has_permission_on [:teachers, :students], :to => :manage, :join_by => :and, &same_school
    has_permission_on :schools, :to => :read_write, &same_user
    has_permission_on :user_profiles, :to => :read_write, &same_user
    has_permission_on [:schools, :teachers, :students], :to => :alter, :join_by => :and, &same_school
  end
  
  role :schoolarly_admin do
    has_permission_on [:schools, :teachers, :students, :schoolarly_admins, :klasses, :exams, :scores, :papers, :users, :user_profiles], :to => :manage
    has_permission_on [:schools, :teachers, :students], :to => :alter
    has_permission_on [:schools, :teachers, :students, :klasses, :papers], :to => :contact
    #has_permission_on :authorization_rules, :to => :manage
  end

end

privileges do
  privilege :manage, :includes => [:create, :read_write, :delete]
  privilege :read_write, :includes => [:read, :update]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => [:new, :add]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end