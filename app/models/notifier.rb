class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3004"
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Binary Logic Notifier "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def invitation(user)
    puts 'Invitation URL - '+edit_password_reset_url(user.perishable_token)
    subject       "Welcome to Schoolarly"
    from          "Team Schoolarly"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
end
