class ConversationsController < ApplicationController
  
  def show
    @mail=Mail.find(params[:id])
    @mails = @mail.conversation.mails.select{|mail| mail.user == @mail.user && (@mail.trashed ? true : !mail.trashed)}
  end
  
  def create
    sender=current_user     #TODO Once the compose message action is displayed only when current_user is the same as active user, the confusion goes. i.e., when the authorisation is in place
    raise if params[:message][:body].blank?  #TODO Move to form validation
    if params[:receiver]
      @receiver = User.find(params[:receiver])
      @sentMail = sender.send_message(@receiver, params[:message][:body], params[:message][:subject])
      template_name = 'conversations/post_message_success'
    else
      receivers=User.find(params[:mail][:user_ids].compact.reject(&:blank?))
      raise if receivers.empty? #TODO Move to form validation
      @sentMail=sender.send_message(receivers, params[:message][:body], params[:message][:subject])
      if receivers.include?(sender) then @inMail = sender.mailbox[:inbox].latest_mail(:conversation => @sentMail.reload.conversation).first end
      template_name = 'conversations/create_success'
    end
    render :template => template_name
  rescue Exception => e
    #@users = get_users_for_composing(sender.person)
    render :template => 'conversations/create_failure'
  end
  
  def destroy
    @conversation = Conversation.find(params[:id])
    @mail = Mail.find(params[:base_mail])
    if !@mail.trashed
      @mail.user.mailbox.move_to(:trash, :conversation => @conversation)
    else
      Mail.delete(@mail.user.mailbox.mail(:conversation => @conversation))
    end
  end
  
end
