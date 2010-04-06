require 'test_helper'
require 'authlogic/test_case'

class ConversationsControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @sboa_user = @sboa.user
    @sboa_student_user = users(:sboa_student)
    @mail = mail(:view_my_conv_mail)
    @conversation = conversations(:sboa_mail_conv)
    UserSession.create(@sboa.user)
  end
  
#  test "view conversations should show all related messages in the user's mailbox" do
#    xhr :get, :show, :id => @mail.to_param
#    assert_response :success
#  end
  
  test "post message should post a message to the active user" do
    #TODO If it is the active user will be checked in integration testing
    assert_difference('Message.count',1) do
      xhr :post, :create, :receiver => @sboa_student_user, :message => {:body => 'body', :subject => 'subject'}
    end
    assert_response :success
    assert_template 'conversations/create_success'
  end
  
  test "post message form should be displayed only for persons (school, teacher, student & parent)" do
    #TODO To be moved to respective shows
  end
  
#  test "compose message should post a message" do
#    assert_difference('Message.count',1) do
#      xhr :post, :create, :mail => {:user_ids => {@sboa_student_user.to_param, @sboa_user.to_param}}, :message => {:body => 'body', :subject => 'subject'}
#    end
#    assert_response :success
#    assert_template 'conversations/create_success'
#  end

#  test "delete conversation should delete the entire conversation for the user" do
#    assert_difference('Mail.count',-1) do
#      xhr :get, :destroy, :id => @conversation.to_param, :base_mail => @mail.to_param
#    end
#    assert_response :success
#    assert_template 'conversations/destroy'
#  end
  
end