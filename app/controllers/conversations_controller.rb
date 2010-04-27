class ConversationsController < ApplicationController
  
  def show
    @mail=Mail.find(params[:id])
    @mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user && (@mail.trashed ? true : !mail.trashed)}
  end
   
  def destroy
    mail = Mail.find(params[:mail])
    @user = mail.user
    @conversation = mail.conversation
    Mail.delete(@user.mailbox[:trash].mail(:conversation => @conversation))
    @user.mailbox.move_to(:trash, :conversation => @conversation)
  end

end
