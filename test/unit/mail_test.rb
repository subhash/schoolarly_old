require 'test_helper'

class MailTest < ActiveSupport::TestCase
  
  def setup
    @inMail = mail(:view_my_conv_mail)
    @trashedMail = mail(:trashed_mail)
    @conv = conversations(:sboa_mail_conv)
    @msg = messages(:sboa_message)
    @user = users(:sboa)
  end 

  test "belongs to message, user & conversation" do
    assert_equal @msg, @inMail.message
    assert_equal @user, @inMail.user
    assert_equal @conv, @inMail.conversation
    assert @conv.mails.include?(@inMail)
  end
  
end
