class Gift < ActiveRecord::Base
  
  belongs_to :wish_list 
  belongs_to :user

  def validate
    errors.add_to_base("Please select category") if self.category_id.blank?
    errors.add_to_base("Please select wishlist") if self.wish_list_id.blank?
    errors.add_to_base("Please enter recepient_subject") if self.recepient_subject.blank?
    errors.add_to_base("Please enter donors_subject") if self.donors_subject.blank?
    unless self.category_id.blank?
     errors.add_to_base("Not sufficient points available for this catogery") if self.check_points_available
    end
  end

  def check_points_available

    #user = User.find(self.user_id)
    if self.points.to_f > self.wish_list.points.to_f
      return true
    end
    return false
  end

end

