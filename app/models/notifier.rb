class Notifier < ActionMailer::Base
  
  def send_mail(user,message)
    defaults
    subject    message.subject    
    recipients    user.email
    body       :message_body =>   message.body  
  end
  
   def send_recepient_mail(gift)
    defaults
    subject    gift.recepient_subject    
    recipients    gift.user.email
    body       :message_body => gift.recepient_message 
  end

 def send_donor_mail(user,message)
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
