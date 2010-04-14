class UserMailer < ActionMailer::Base
  

  def message(user)
    subject    'Welcome'
    recipients [user.email]
    from       'admin@shoppingcart.com'
    sent_on    Time.now
    @body["user" ] = user
    
    
  end


  def order(buyer)
    subject    'Test mail'
    recipients [buyer.customer_email]
    from       'admin@shoppingcart.com'
    sent_on    Time.now
    @body["user" ] = buyer
    @body["url" ] = "http://localhost:3000/guides/#{buyer.guide_id}"
    
  end

end
