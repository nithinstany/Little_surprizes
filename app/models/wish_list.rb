class WishList < ActiveRecord::Base
  belongs_to :user
  #has_many :categories
  #has_and_belongs_to_many :categories,:uniq => true
  has_many :category_wish_lists
  has_many :categories,:through => :category_wish_lists

  accepts_nested_attributes_for :category_wish_lists, :allow_destroy => true


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
      date =  fb_user.birthday_date.blank? ? '' : DateTime.parse(fb_user.birthday_date).to_date
      unless date.blank?
        year = Date.today.month > date.month ? Date.today.year.to_i + 1 : Date.today.year
        birthday = DateTime.parse("#{date.month}/#{date.day}/#{year}").to_date
        if (birthday - Date.today >= 1 and birthday - Date.today <= 30)
          unless user.wish_lists.nil?
              FacebookPublisher.deliver_notification_email(user,fb_user,fb_user.friends,birthday,user.wish_lists.last.id)
          else
              FacebookPublisher.deliver_notification_email_without_wish_list(user,fb_user,fb_user.friends,birthday)
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

