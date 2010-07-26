# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spinner
    image_tag 'loading.gif', :id=>'spinner', :style=>"display:none;"
  end
end
