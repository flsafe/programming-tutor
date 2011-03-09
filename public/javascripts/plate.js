var canvasElement;
var plate;
var ctx;
var sceneObjects;
var clickedCallBack;
var allDoneCallBack;

function initPlate(canvElem, json, clickedOnCallback, doneCallback){
  canvasElement = canvElem;
  canvasElement.addEventListener('mousemove', onMouseOver, false);
  canvasElement.addEventListener('click', onClick, false);
  ctx = canvasElement.getContext("2d");
  plate = json.plate;
  sceneObjects = plate2scene();
  clickedCallBack = clickedOnCallback;
  allDoneCallBack = doneCallback;

  if (plateDone())
    allDoneCallBack();

  clickOnFirst();
}

function clickOnFirst(){
  sceneObjects[0].clicked = true;
  clickedCallBack(sceneObjects[0]);
}

function plateDone(){
  if (sceneObjects.length == 0)
    return false;

  for (var i = 0 ; i < sceneObjects.length ; i++)
    if (sceneObjects[i].grade != 100)
      return false;

  return true;
}

function onMouseOver(e){
  var p = getCursorPosition(e);

  for (var i = 0 ; i < sceneObjects.length ; i++)
    if (pointInside(p, sceneObjects[i])){
      canvasElement.style.cursor = "pointer";
      return;
  }
  canvasElement.style.cursor = "";
}

function onClick(e){
  var p = getCursorPosition(e)
  clickOnPlateItem(p);
}

function clickOnPlateItem(p){
 for (var i = 0 ; i < sceneObjects.length ; i++)
   sceneObjects[i].clicked = false;
  
 for (var i = 0 ; i < sceneObjects.length ; i++)
   if (pointInside(p, sceneObjects[i])){
     sceneObjects[i].clicked = true;
     clickedCallBack(sceneObjects[i]);
   }

  drawSceneObjects();
}

function pointInside(p, sceneObject){
  return p.x >= sceneObject.x && 
         p.y >= sceneObject.y &&
         p.x <= sceneObject.x + sceneObject.width &&
         p.y <= sceneObject.y + sceneObject.height;
}

function getCursorPosition(e) {
  /* returns Cell with .row and .column properties */
  var x;
  var y;
  if (e.pageX != undefined && e.pageY != undefined) {
    x = e.pageX;
    y = e.pageY;
  }
  else {
    x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
    y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
  }
  x -= canvasElement.offsetLeft;
  y -= canvasElement.offsetTop;
  return {x:x,y:y};
}

function plate2scene(){
  var conv = plate2sceneConverter({plate:plate});

  if (plate.length == 3)
    withThree(conv);
  else if (plate.length == 6)
    withSix(conv);
  else if (plate.length == 10)
    withTen(conv);
  else
    withSix(conv);

  return conv.sceneObjects;
}

function withThree(conv){
  conv.organizeRow(2);
  conv.nextRow();
  conv.organizeRow(1);
}

function withSix(conv){
  conv.organizeRow(3);
  conv.nextRow();
  conv.organizeRow(2);
  conv.nextRow();
  conv.organizeRow(1);
}

function withTen(conv){
  conv.organizeRow(4);
  conv.nextRow();
  conv.organizeRow(3);
  conv.nextRow();
  conv.organizeRow(2);
  conv.nextRow();
  conv.organizeRow(1);
}

function drawSceneObjects(){
  ctx.clearRect(0, 0, 500, 500);

  for (var i = 0 ;  i < sceneObjects.length ; i++){
    drawBorder(sceneObjects[i]);
    drawRect(sceneObjects[i]);
    drawText(sceneObjects[i]);
  }
}

function drawBorder(sceneObject){
  ctx.lineJoin = "round";
  if (sceneObject.clicked){
    ctx.lineWidth = 6;
    ctx.strokeStyle = "rgb(40, 40, 40)";
  }
  else{
    ctx.lineWidth = 3;
    ctx.strokeStyle = "rgb(60, 60, 60)";
  }
  ctx.strokeRect(sceneObject.x,sceneObject.y,sceneObject.width,sceneObject.height);
}

function drawRect(sceneObject){
  if (sceneObject.grade == 100)
    ctx.fillStyle = "rgb(150, 200, 100)";
  else if (sceneObject.grade != undefined){
    ctx.fillStyle = "rgb(230, 250, 230)";
  }
  else {
    ctx.fillStyle = "rgb(230, 230, 230)";
  }

  ctx.fillRect(sceneObject.x, sceneObject.y, sceneObject.width, sceneObject.height);
}

function drawText(sceneObject){
  ctx.font = "18px serif"
  ctx.fillStyle = "black";
  ctx.textAlign = "center";

  if(sceneObject.grade == 100)
    ctx.fillText("Done!", sceneObject.x + sceneObject.width/2, sceneObject.y + sceneObject.height/2);
  else if (sceneObject.grade == undefined)
    ctx.fillText("Exercise "+ sceneObject.order, sceneObject.x + sceneObject.width/2, sceneObject.y + sceneObject.height/2);
  else
    ctx.fillText(sceneObject.grade, sceneObject.x + sceneObject.width/2, sceneObject.y + sceneObject.height/2);
}

var plate2sceneConverter = function(spec){
  var that = {};

  var startX = spec.startX || 150.5;
  var startY = spec.startY || 275.5;
  var width = spec.width  || 100;
  var height = spec.height || width;
  var between = spec.between || 5;
  var currentItem = 0;
  if (spec.plate == undefined){
  throw{ name:"No Plate Specified", message: "Specifiy a plate item array"};
  }
  var plate = spec.plate.sort(function(a, b){
    return a.order - b.order
  });
  var objects = [];
  that.sceneObjects = objects;

  var organizeRow = function(nItems){
    for (var i = 0 ; i < nItems && currentItem < plate.length ; i++){
      var x = startX + (i * (width + between));
      var y = startY;
      objects.push({x: x, y: y, 
                     width: width, height: height,
                     ex_id: plate[currentItem].ex_id, 
                     order: plate[currentItem].order,
                     grade: plate[currentItem].grade,
                     clicked: false});
      currentItem++;
    }
  };
  that.organizeRow = organizeRow;

  var nextRow = function(){
   startX += width/2;
   startY -= height + between;
  }
  that.nextRow = nextRow;

  return that;
}

