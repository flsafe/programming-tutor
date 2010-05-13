module MenuHelper
  def show_menu?
    true unless request.request_uri =~ /\/$/
  end
end