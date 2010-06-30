module WishListsHelper

  def check_user
    @from_mail_user.facebook_id.to_s == @facebook_user.facebook_id.to_s ? false : true
  end
  
  def friends_list
    array = [ ]
    @friend_list.each do |flists|
      array << [ ]
    end
  end
  
end

