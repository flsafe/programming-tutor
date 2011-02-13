module GradeSheetHelper

  def to_str(str)
    str.blank? ? '""' : str
  end

  def to_color_points_td(test_results)
    css_class = ""
    if test_results[:got] and test_results[:expected]
      if test_results[:got].strip.chomp == test_results[:expected].strip.chomp
        css_class = "green-text"
      end
    end
    "<td class='#{css_class}'> #{html_escape(test_results[:points])} </td>"
  end

  def to_color_got_td(test_results)
    css_class = ""
    if test_results[:got]
      if test_results[:got] =~ /error/ix
        css_class = "black-text"
      end
    end
    "<td class='#{css_class}'> #{html_escape(test_results[:got])} </td>"
  end
end
