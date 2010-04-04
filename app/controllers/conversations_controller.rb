class ConversationsController < ApplicationController
  def show
    @mail=Mail.find(params[:id])
    #@mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user} - [@mail]
    @mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user && (@mail.trashed ? true : !mail.trashed)} #- [@mail]
  end
  
  def create
    sender=User.find(params[:sender])
    if params[:receiver]
      @receiver = User.find(params[:receiver])
      @sentMail = sender.send_message(@receiver, params[:message][:body], params[:message][:subject])
    else
      receivers=User.find(params[:mail][:user_ids].compact.reject(&:blank?))
      @sentMail=sender.send_message(receivers, params[:message][:body], params[:message][:subject])
      if receivers.include?(sender) then @inMail = sender.mailbox[:inbox].latest_mail.first end
    end
    if params[:message][:body].blank? then raise end 
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
    @conversation = Conversation.find(params[:id])
    @mail = Mail.find(params[:base_mail])
    if !@mail.trashed
      @mail.user.mailbox.move_to(:trash, :conversation => @conversation)
      #c = 'id = ' + @mail.id.to_s
      #@mail.user.mailbox.move_to(:trash, :conditions => c)
    else
      Mail.delete(@mail.user.mailbox.mail(:conversation => @conversation))
    end
    respond_to do |format|
      format.js {render :template => 'conversations/destroy'}
    end 
  end
  
end
