require 'test_helper'
require 'authlogic/test_case'

class MailsControllerTest < ActionController::TestCase

  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @mail = mail(:view_my_conv_mail)
    @trashed_mail = mail(:trashed_mail)
    @sboa_user = @sboa.user
    @sboa_student_user = users(:sboa_student)
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
    xhr :get, :show, :id => @mail.to_param
    assert_response :success
    assert_template 'mails/show'
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
    assert_template 'mails/create_success'
  end
  
    test "post message should post a message to the active user" do
    #TODO If it is the active user will be checked in integration testing
    assert_difference('Message.count',1) do
      xhr :post, :create, :receiver => @sboa_student_user, :message => {:body => 'body', :subject => 'subject'}
    end
    assert_response :success
    assert_template 'mails/create_success'
  end
  
  test "post message form should be displayed only for persons (school, teacher, student & parent)" do
    #TODO To be moved to respective shows
  end
  
  test "compose message should post a message" do
    assert_difference('Conversation.count',1) do
      xhr :post, :create, :mail => {:user_ids => [@sboa_student_user.to_param, @sboa_user.to_param]}, :message => {:body => 'new_body', :subject => 'new_subject'}, :users => [@sboa_student_user.to_param, teachers(:mary_kutty).user.to_param, teachers(:v_subramaniam).user.to_param, @sboa_user.to_param]
    end
    assert_response :success
    assert_template 'mails/create_success'
  end
  
end
