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
  fb_session = Facebooker::Session.new('160ff3da7db8f04a75fe58ca5ab90d11', 'def046826bbe6f68b1befa7f4eab9007')
  users = User.all(:select => 'facebook_id, session_key', :conditions => "facebook_id != ''")
  #user_ids = users.collect{|u| [u.facebook_id, u.session_key]}

   for user in users
      fb_user = Facebooker::User.new(user.facebook_id, fb_session)
      @user = User.find_by_facebook_id(user.facebook_id) rescue nil
      @wish_list = @user.wish_list.id rescue nil

      begin
        fb_session.secure_with! user.session_key, user.facebook_id, 1.hour.from_now
        @date =  fb_user.birthday_date.blank? ? '' : DateTime.parse(fb_user.birthday_date).to_date

        unless @date.blank?
          year = Date.today.month > @date.month ? Date.today.year.to_i + 1 : Date.today.year
          @birthday = DateTime.parse("#{@date.month}/#{@date.day}/#{year}").to_date
          if (@birthday - Date.today >= 1 and @birthday - Date.today <= 30)
           if !@user.wish_list.nil?
            FacebookPublisher.deliver_notification_email(@user,fb_user,fb_user.friends,@birthday,@user.wish_list.id)
           else
            FacebookPublisher.deliver_notification_email_without_wish_list(@user,fb_user,fb_user.friends,@birthday)
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

