module WishListsHelper

  def check_user_login
    @from_mail_user.facebook_id.to_s == @facebook_user.facebook_id.to_s ? false : true
  end
end

