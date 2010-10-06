
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
  width_offset = -20
  height_offset = -155

  edit_area = document.getElementById('textarea_1')
  edit_area.style.width = oneThirdWindowWidth() * 2 + width_offset + 'px'
  height = window.innerHeight
  edit_area.style.height = height + height_offset + 'px'
}

function resizeExerciseTextDimensions(){
  width_offset = -25
  height_offset = -155

  exercise_text = document.getElementById('exercise_problem_text')
  exercise_text.style.width = oneThirdWindowWidth() + width_offset + 'px'
  exercise_text.style.height = window.innerHeight + height_offset + 'px'
}

function flashEditArea(){
  editAreaLoader.hide('textarea_1')
  editAreaLoader.show('textarea_1')
}

function oneThirdWindowWidth(){
  width = window.innerWidth
  return width / 3
}

function calcHeight(){
  height_offset = -155
  return window.innerHeight + height_offset + 'px'
}
