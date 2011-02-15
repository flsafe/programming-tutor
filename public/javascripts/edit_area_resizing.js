
var resizeId;

// The window.onresize event fires too quickly and causes
// EditArea to crash. This queued resize function limits the
// calls to once every 100 ms.
//
function queuedResize(){ 
  window.clearTimeout(resizeId)
  resizeId = window.setTimeout('resizeEditArea()', 100);
}

var resizeEditArea = function(){
  unfocusEditArea()	
  resizeEditAreaDimensions()
  resizeExerciseTextDimensions()
  flashEditArea()
}

function unfocusEditArea(){
  dummy_div = document.getElementById('dummy-unfocus-div')
  dummy_div.focus()
}

function resizeEditAreaDimensions(){
  width_offset = -100

  edit_area = document.getElementById('textarea_1')
  edit_area.style.width = twoThirdsWindowWidth(width_offset) 
  edit_area.style.height = calcHeight() 
}

function resizeExerciseTextDimensions(){
  width_offset = 55 
  exercise_text = document.getElementById('exercise_problem_text')
  exercise_text.style.width = oneThirdWindowWidth(width_offset) 
  exercise_text.style.height = calcHeight(); 
}

function flashEditArea(){
  editAreaLoader.hide('textarea_1')
  editAreaLoader.show('textarea_1')
}

function twoThirdsWindowWidth(offset){
  return ((document.documentElement.clientWidth / 3) * 2) + offset + 'px'
}

function oneThirdWindowWidth(offset){
  var width = document.documentElement.clientWidth 
  return (width / 3) + offset + 'px'
}

function calcHeight(){
  var height_offset = -175
  return document.documentElement.clientHeight + height_offset + 'px'
}
