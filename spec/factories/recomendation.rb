
Factory.sequence :recomendation_user_id_seq do |n|
  n
end

Factory.define :exercise_recomendation_list do |e|
  e.list [] 
end

Factory.define :recomendation do |r|
  r.user_id {Factory.next :recomendation_user_id_seq}
  r.exercise_recomendation_list {|e| e.association(:exercise_recomendation_list)}
end
