class CategoryWishList < ActiveRecord::Base
  belongs_to :category
  belongs_to :wish_list
end

