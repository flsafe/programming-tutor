class Figure < ActiveRecord::Base
  belongs_to :exercise
  
  has_attached_file :image
  
  validates_attachment_presence :image
  validates_attachment_content_type :image, 
    :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
end