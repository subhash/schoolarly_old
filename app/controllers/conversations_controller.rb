class ConversationsController < ApplicationController
  def show
    @mail=Mail.find(params[:id])
    #@mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user} - [@mail]
    @mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user && (@mail.trashed ? true : !mail.trashed)} - [@mail]
  end
  
  def create
    sender=User.find(params[:sender])
    receiver=User.find(params[:mail][:user_id])
    if params[:message][:body].blank? then raise end 
    @sentMail=sender.send_message(receiver, params[:message][:body], params[:message][:subject])
    #@sentMail = sender.mailbox[:sentbox].latest_mail.first
    if sender==receiver then @inMail = sender.mailbox[:inbox].latest_mail.first end
    respond_to do |format|
      flash[:notice] = 'Message was successfully sent.'
      format.js {render :template => 'conversations/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'conversations/create_error'}
    end 
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    @mailbox=@mail.mailbox
    if @mail.mailbox != 'trash'
      convo = @mail.conversation
      @mail.user.mailbox.move_to(:trash, :conversation => convo)
      #c = 'id = ' + @mail.id.to_s
      #@mail.user.mailbox.move_to(:trash, :conditions => c)
    else
  #      @mail.destroy
  #      puts "deleting the mail"
  end
      respond_to do |format|
        format.js {render :template => 'conversations/destroy'}
      end 
  #    @message = Message.find(params[:id])
  #    @message.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(messages_url) }
  #      format.xml  { head :ok }
  #    end
  end
  
end
