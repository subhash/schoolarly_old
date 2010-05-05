class ConversationsController < ApplicationController
  
  def show
    @mail=Mail.find(params[:id])
    @mails = @mail.user.mailbox.mail(:conversation => @mail.conversation).select{|mail| !mail.trashed || @mail.trashed}
  end
   
  def destroy
    mail = Mail.find(params[:mail])
    Mail.delete(mail.user.mailbox[:trash].mail(:conversation => mail.conversation))
    mail.user.mailbox.move_to(:trash, :conversation => mail.conversation)
  end

end