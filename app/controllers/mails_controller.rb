class MailsController < ApplicationController
  
  def reply_new
    @mail=Mail.find(params[:id])
  end
  
  def send_reply
    @mail=Mail.find(params[:mail])
    @sentMail=@mail.user.reply_to_sender(@mail, params[:body], params[:subject])
    sender=@sentMail.user
    receiver=@mail.message.sender
    if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail.first end
    respond_to do |format|
      flash[:notice] = 'Message was successfully sent.'
      format.js {render :template => 'conversations/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'mails/reply_create_error'}
    end 
  end
  
  def mark_and_show
      @mail=Mail.find(params[:id])
      @mail.mark_as_read()
      respond_to do |format|
        format.js {render :template => 'messages/show'}
      end 
  end
  
end
