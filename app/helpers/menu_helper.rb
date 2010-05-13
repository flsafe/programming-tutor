module MenuHelper
  def black_list
    @black_list ||= [/\/$/, /\/login/, /\logout/, /\/users\/new/]
  end

  def show_menu?
    not black_list.detect {|no_show| request.request_uri =~ no_show }
  end
end