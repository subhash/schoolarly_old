class MailsController < ApplicationController
  
  def reply_new
    @mail=Mail.find(params[:id])
  end
  
  def send_reply
    @mail=Mail.find(params[:mail])
    @sentMail=@mail.user.reply_to_sender(@mail, params[:body], params[:subject])
    sender=@sentMail.user
    receiver=@mail.message.sender
    #if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail.first end
    if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail(:conversation => @sentMail.conversation).first end
      puts "inmaiiiiiiiiiiiiiiiiiiiiil="
      puts sender.mailbox[:inbox].mail(:conversation => @sentMail.conversation).inspect
    respond_to do |format|
      flash[:notice] = 'Message was successfully sent.'
      format.js {render :template => 'mails/reply_create_success'}
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
  
  def destroy
    @mail=Mail.find(params[:id])
    if !@mail.trashed
      @mail.user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s)
    else
      Mail.delete(@mail)
    end
    respond_to do |format|
      format.js {render :template => 'mails/destroy'}
    end 
  end
  
end
