require 'test_helper'
require 'authlogic/test_case'

class MessagePostingTest < ActionController::IntegrationTest
  fixtures :all
  
  MESSAGE_DETAILS = {
    :subject => "Apple",
    :body => "An apple a day keeps the doctor away. If the doctor is a lady, keep the apple away. :)"
  }
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @mary_kutty = teachers(:mary_kutty)
    UserSession.create(@sboa.user)
  end
  
  #The story goes like this... Marukutty goes to sboa page and post a message. She finds the mail at the inbox of sboa. Then she rechecks it by going to her show page & checking out her sent items. Whenever a mail is posted, it goes to the active user.

      def is_viewing(page)
        assert_response :success
        assert_template page
      end
      
      def posts_message(active_user)
        xhr :post, 'conversations/create', :receiver => active_user, :message => MESSAGE_DETAILS
        assert_response :success
        assert_template 'conversations/post_message_success'
      end
      
      def has_mails(actual_user, count, mailbox)
        assert_equal count, actual_user.mailbox[mailbox].mail_count
      end

  test 'checks if the message goes to active user' do
#    sboa = regular_user
#    marykutty = regular_user

#    get 'teachers/' + @mary_kutty.to_param
    active_user = User.find_by_person_type_and_person_id('teachers'.singularize.camelcase, @mary_kutty.to_param)
#    is_viewing 'teachers/show'
#    has_mails(@sboa.user, 1, :sentbox)
#    has_mails(@mary_kutty.user, 0, :inbox)
    posts_message active_user
    has_mails(@sboa.user, 2, :sentbox)
    has_mails(@mary_kutty.user, 1, :inbox)
  end
  
end
