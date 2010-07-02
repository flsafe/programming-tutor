module GradeSheetHelper
  
  def valid_result?(results)
    true if results and results[:grade] and results[:tests]
  end
end