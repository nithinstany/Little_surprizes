module Admin::GiftsHelper
  
  def recepient_message
    arry = []
    @orders.each do |order|
      arry << [User.find(order.payer_id).name]  unless order.payer_id.nil?
    end
    
    "<!DOCTYPE HTML PUBLIC '//W3C//DTD HTML 4.01 Transitional//EN'>
<html>
<head> <meta content='text/html; charset=utf-8' http-equiv='Content-Type'> </head> 
<body>
  Hi #{@user.name},<br />
    We at Little Surprizes would like to wish you on this very special occasion.We hope it will be most joyous and filled with pleasant surprises like this one!!!!!!!!!!!!!!! 
#{arry.join(', ')} have contributed for a fantastic gift from your wishlist. <br />
Here is that Gift for you: <br />
< Gift Card Image> with Amount/ID etc. <br />
We hope this was a pleasant surprise for you.<br />
Thanking you for choosing Little Surprizes!<br />
</body>
</html>"
  end
  
end
