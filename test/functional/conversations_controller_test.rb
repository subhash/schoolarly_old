require 'test_helper'
require 'authlogic/test_case'

class ConversationsControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @mail = mail(:view_my_conv_mail)
    @conversation = conversations(:sboa_mail_conv)
    @trashed_mail = mail(:trashed_mail)
    UserSession.create(@sboa.user)
  end
  
  test "view conversations should show all related messages in the user's mailbox" do
    xhr :get, :show, :id => @mail.to_param
    assert_response :success
    assert_template :show
  end

  test "delete conversation should move the untrashed mails of the conversation to trash" do
    assert_difference("@mail.user.mailbox.mail(:conversation => @conversation, :conditions => 'trashed = false').size", -1) do      
      xhr :get, :destroy, :mail => @mail.to_param
    end
    assert_response :success
    assert_template 'conversations/destroy'
  end
  
  test "delete conversation should actually delete the trashed mails of the conversation for the user" do
    assert_difference('@trashed_mail.user.mail(:conversation => @conversation).size', -1) do
      xhr :get, :destroy, :mail => @trashed_mail.to_param
    end
    assert_response :success
    assert_template 'conversations/destroy'
  end  
end