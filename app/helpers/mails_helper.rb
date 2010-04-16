module MailsHelper
    
  def message_if_empty_mails
    return 'No message available'
  end
  
  def list_sender_or_receivers(mail)
    users_list = (mail.mailbox == 'inbox') ? [mail.message.sender] : mail.message.recipients
    users_list.collect {|u| link_to u.person.name, {:controller => u.person_type.pluralize, :action => 'show', :id => u.person}, :title => u.email }.join(', ')
  end
  
end
