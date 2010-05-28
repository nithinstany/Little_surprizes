class Gift < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :category_id ,:wish_list_id
end

