class WishList < ActiveRecord::Base
  belongs_to :user
  has_many :category_wish_lists
  has_many :categories,:through => :category_wish_lists
  has_many :orders
  has_many :gifts 
  accepts_nested_attributes_for :category_wish_lists, :allow_destroy => true

 
  validates_presence_of :name

  def has_permission?
 
   if facebook.users.hasAppPermission
    return 1
  end
  end

 



def WishList.send_mail
 user = User.find(8)
 UserMailer.deliver_message(user)
 FacebookPublisher.deliver_user_notification(user)
end

def WishList.birthday_reminder
  fb_session = Facebooker::Session.new('160ff3da7db8f04a75fe58ca5ab90d11', 'def046826bbe6f68b1befa7f4eab9007') # api key and secret
  for user in User.find(:all, :conditions => ["facebook_id IS NOT  NULL"])
    begin
      fb_session.secure_with!(user.session_key, user.facebook_id, 2.hour.from_now)
      fb_user = Facebooker::User.new(user.facebook_id, fb_session)
      wish_lists = user.wish_lists.find(:all,:conditions => ['date >= ?',Date.today ])
      unless wish_lists.nil?
        wish_lists.each do| wish_list|
          unless wish_list.date.blank?
            if ((wish_list.date-Date.today).to_i == 3 || (wish_list.date - Date.today).to_i == 1)
          FacebookPublisher.deliver_notification_email(user,fb_user,fb_user.friends,wish_list.date,wish_list)
            end
         end 
      end
    end
      rescue Facebooker::Session::SessionExpired
    end
  end
end

  
 def self.wishlist(facebook_session)
    WishList.find_by_facebook_id(facebook_session) rescue nil
 end


end

