
var resizeEditArea = function(){
  unfocusEditArea()	
  resizeEditAreaDimensions()
  resizeExerciseTextDimensions()
  flashEditArea()
}
window.onresize = resizeEditArea

function unfocusEditArea(){
  dummy_div = document.getElementById('dummy-unfocus-div')
  dummy_div.focus()
}

function resizeEditAreaDimensions(){
  width_offset = -50

  edit_area = document.getElementById('textarea_1')
  edit_area.style.width = twoThirdsWindowWidth(width_offset) 
  edit_area.style.height = calcHeight() 
}

function resizeExerciseTextDimensions(){
  width_offset = 0

  exercise_text = document.getElementById('exercise_problem_text')
  exercise_text.style.width = oneThirdWindowWidth(width_offset) 
  exercise_text.style.height = calcHeight(); 
}

function flashEditArea(){
  editAreaLoader.hide('textarea_1')
  editAreaLoader.show('textarea_1')
}

function twoThirdsWindowWidth(offset){
  return ((window.innerWidth / 3) * 2) + offset + 'px'
}
function oneThirdWindowWidth(offset){
  width = window.innerWidth
  return (width / 3) + offset + 'px'
}

function calcHeight(){
  height_offset = -200
  return window.innerHeight + height_offset + 'px'
}
