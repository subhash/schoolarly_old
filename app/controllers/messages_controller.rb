class MessagesController < ApplicationController
#
#  def create
#    sender=User.find(params[:sender])
#    receiver=User.find(params[:mail][:user_id])
#    @sentMail=sender.send_message(receiver, params[:message][:body], params[:message][:subject])
#    #@sentMail = sender.mailbox[:sentbox].latest_mail.first
#    if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail.first end
#    respond_to do |format|
#      flash[:notice] = 'Message was successfully sent.'
#      format.js {render :template => 'mails/create_success'}
#    end 
#  rescue Exception => e
#    respond_to do |format|
#      format.js {render :template => 'mails/create_error'}
#    end 
#  end
#  
#  def destroy
#    @mail=Mail.find(params[:id])
#    @mailbox=@mail.mailbox
#    if @mail.mailbox != 'trash'
#      convo = @mail.conversation
#      @mail.user.mailbox.move_to(:trash, :conversation => convo)
#    else
#  #      @mail.destroy
#  #      puts "deleting the mail"
#  end
#      respond_to do |format|
#        format.js {render :template => 'mails/destroy'}
#      end 
#  #    @message = Message.find(params[:id])
#  #    @message.destroy
#  #
#  #    respond_to do |format|
#  #      format.html { redirect_to(messages_url) }
#  #      format.xml  { head :ok }
#  #    end
#  end
#  
#  #def mark_as_read
#  #    @mail=Mail.find(params[:id])
#  #    @mail.mark_as_read()
#  #    respond_to do |format|
#  #      format.js {render :template => 'mails/change_read_status'}
#  #    end 
#  #end
#  #
#  #def mark_as_unread
#  #    @mail=Mail.find(params[:id])
#  #    @mail.mark_as_unread()
#  #    respond_to do |format|
#  #      format.js {render :template => 'mails/change_read_status'}
#  #    end     
#  #end
#  
#  def mark_and_show
#      @mail=Mail.find(params[:id])
#      @mail.mark_as_read()
#      respond_to do |format|
#        format.js {render :template => 'mails/mark_and_show'}
#      end 
#  end
  
end
