class ConversationsController < ApplicationController
  
  def show
    @mail=Mail.find(params[:id])
    @mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user && (@mail.trashed ? true : !mail.trashed)}
  end
   
  def destroy
    mail = Mail.find(params[:mail])
    Mail.delete(mail.user.mailbox[:trash].mail(:conversation => mail.conversation))
    mail.user.mailbox.move_to(:trash, :conversation => mail.conversation)
  end

end
