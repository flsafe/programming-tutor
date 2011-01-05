class Figure < ActiveRecord::Base
  belongs_to :exercise

  # TODO: Don't know how to load paperclip in a script environment
  # For now it won't be loaded in scripts.
  unless ENV['SCRIPT'] then 
    has_attached_file :image
    
    validates_attachment_presence :image
    validates_attachment_content_type :image, 
      :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  end
end
