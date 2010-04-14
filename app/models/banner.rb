class Banner < ActiveRecord::Base
  has_attached_file :banner_image, :styles => { :medium => "300x300>", :thumb => "135x135>" }
end
