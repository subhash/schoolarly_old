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
    assert_kind_of Mail, assigns(:mail)
    #TODO assert_equal true, assigns(:mail).trashed
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
    #TODO  
  end
  
  test "reply should send a mail to the sender of the current mail with the same conversation id" do
    #TODO
  end
  
end
