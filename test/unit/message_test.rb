require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @sender = teachers(:sunil)
    @receiver = students(:shenu)
    @message = messages(:one)
  end
  
  test "message -sender -receiver" do
    @message.sender = @sender.user
    @message.receiver = @receiver.user
    assert @message.save    
  end
  
end
