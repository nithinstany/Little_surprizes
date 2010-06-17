class Gift < ActiveRecord::Base
  
    
  belongs_to :user

  def validate
    errors.add_to_base("Please select category") if self.category_id.blank?
    errors.add_to_base("Please select wishlist") if self.wish_list_id.blank?
    unless self.category_id.blank?
     errors.add_to_base("Not sufficient points available for this catogery") if self.check_points_available
    end
  end

  def check_points_available

    user = User.find(self.user_id)
    if self.points.to_i > user.points.to_i
      return true
    end
    return false
  end

end

