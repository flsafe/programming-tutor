class ExerciseRecomendationList

  attr_reader :list

  def initialize(recomendation_list_as_string)
    @list = recomendation_list_as_string.split(/,/).map {|str_id| str_id.to_i}
  end
end
