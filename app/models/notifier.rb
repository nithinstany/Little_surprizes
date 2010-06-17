class Notifier < ActionMailer::Base
  
  def send_mail(user,message)
    puts "zzzzzzzzzzzzzzzzzzzzzzzzzzz #{user.email}"
    defaults
    subject    message.subject    
    recipients    user.email
    body       :message_body =>   message.body  
  end
  
  
  
  private

    def defaults
      content_type  'text/html'
      sent_on       Time.now
      #from          "\"/littlesurprizes\" </littlesurprizes@gmail.com>"
      #reply_to     "\"Prodocx support\" <admin@prodocx.com>"
    end
end
