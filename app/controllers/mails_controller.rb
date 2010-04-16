class MailsController < ApplicationController
  
  def reply_new
    @mail=Mail.find(params[:id])
  end
  
  def send_reply
    @mail=Mail.find(params[:mail])
    @sentMail=@mail.user.reply_to_sender(@mail, params[:body], params[:subject])
    sender=@sentMail.user
    receiver=@mail.message.sender
    if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail(:conversation => @sentMail.conversation, :conditions => 'message_id = ' + @sentMail.message.id.to_s).first end
    render :template => 'conversations/create_success'
  rescue Exception => e
    render :template => 'mails/send_reply_error'
  end
  
  def mark_and_show
    @mail=Mail.find(params[:id])
    @mail.mark_as_read()
    render :template => 'messages/show'
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    if !@mail.trashed
      @mail.user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s)
    else
      Mail.delete(@mail)
    end
    render :template => 'mails/destroy'
  end
  
end
