module GradeSheetHelper

  def to_str(str)
    str.blank? ? '""' : str
  end

  def to_color_points_td(test_results)
    if test_results[:got].strip.chomp == test_results[:expected].strip.chomp
      css_class = "green-text"
    else
      css_class = ""
    end
    "<td class='#{css_class}'> #{test_results[:points]} </td>"
  end
end
