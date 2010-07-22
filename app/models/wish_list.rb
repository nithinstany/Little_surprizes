class WishList < ActiveRecord::Base
  belongs_to :user
  #has_many :categories
  #has_and_belongs_to_many :categories,:uniq => true
  has_many :category_wish_lists
  has_many :categories,:through => :category_wish_lists
  has_many :orders
  has_many :gifts 
  accepts_nested_attributes_for :category_wish_lists, :allow_destroy => true

  #def validate
   #errors.add_to_base("Please select category") if self.category_wish_lists.count<1
  #end
  validates_presence_of :name

  def has_permission?
  #session.post('facebook.users.hasAppPermission')
   if facebook.users.hasAppPermission
    return 1
  end
  end

#def get_profile_info(user)
#session.post('facebook.profile.getInfo', :uid => @id)
#user.getInfo(user,birthday_date)
#end

def self.birth_day(birthday)
@remaining_days = (birthday - Date.today).to_i
  if (@remaining_days <= 30)
   return 1
  else
   return 0
  end
end



def WishList.send_mail
 user = User.find(8)
 UserMailer.deliver_message(user)
 FacebookPublisher.deliver_user_notification(user)
end

def WishList.birthday_reminder
  fb_session = Facebooker::Session.new('d7069c71e7b928287fccf3c74f67beec', '4c425b88e6730e941276904269779024') # api key and secret
  for user in User.find(:all, :conditions => ["facebook_id IS NOT  NULL"])
    begin
      fb_session.secure_with!(user.session_key, user.facebook_id, 2.hour.from_now)
      fb_user = Facebooker::User.new(user.facebook_id, fb_session)
      wish_lists = user.wish_lists 
      unless wish_lists.nil?
        wish_lists.each do| wish_list|
          unless wish_list.date.blank?
            if (wish_list.date - Date.today == 30 ||  wish_list.date - Date.today == 7 || wish_list.date - Date.today <=2)
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

