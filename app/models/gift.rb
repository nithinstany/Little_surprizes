class Gift < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :category_id ,:wish_list_id

  def validate
    errors.add_to_base("Not sufficient points Available for this catogery") if self.test
  end



  def test
    catogery = Category.find(self.category_id)
    user = User.find(self.user_id)
    if catogery.lowest_number_of_points_needed.to_i > user.points.to_i
      return true
    end
    return false
  end

end

