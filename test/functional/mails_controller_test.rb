require 'test_helper'
require 'authlogic/test_case'

class MailsControllerTest < ActionController::TestCase

  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @mail = mail(:view_my_conv_mail)
    @trashed_mail = mail(:trashed_mail)
    UserSession.create(@sboa.user)
  end
  
  test "delete should move the mail to trash" do
    assert_equal false, @mail.trashed
    assert_difference('Mail.count',0) do
      xhr :get, :destroy, :id => @mail.to_param
    end
    assert_equal true, @mail.reload.trashed
    assert_response :success
    assert_template 'mails/destroy'
  end
  
  test "delete should destroy the trashed mail" do
    assert_equal true, @trashed_mail.trashed
    assert_difference('Mail.count',-1) do
      xhr :get, :destroy, :id => @trashed_mail.to_param
    end
    assert_response :success
    assert_template 'mails/destroy'
  end
  
  test "click on subject should show the message body & mark the mail as read" do
    xhr :get, :mark_and_show, :id => @mail.to_param
    assert_response :success
    assert_template 'messages/show'
  end
  
  test "reply should open a reply message form in the dialog box" do
    xhr :get, :reply_new, :id => @mail.to_param
    assert_response :success
    assert_template 'mails/reply_new'
  end
  
  test "reply should send a mail to the sender of the current mail with the same conversation id" do
    assert_difference('@mail.user.mailbox[:sentbox].mail.size',1) do
      xhr :post, :send_reply, :mail => @mail.to_param, :subject => 'RE: Apple', :body => 'An apple a day keeps the doctor away'  
    end
    assert_response :success
    assert_template 'conversations/create_success'
  end
  
end
