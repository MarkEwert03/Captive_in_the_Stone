void game() {
  drawRoom();

  //Hero
  myHero.show();
  myHero.act();
}//-------------------------------------------------- game --------------------------------------------------

void gameMousePressed() {
  mode = MENU;
}//-------------------------------------------------- gameMousePressed --------------------------------------------------

void switchRoom() {
  //initialize all paths to be closed
  north = south = east = west = false;

  hereColor  = map.get(roomX, roomY);
  westColor  = map.get(roomX-1, roomY);
  northColor = map.get(roomX, roomY-1);
  eastColor  = map.get(roomX+1, roomY);
  southColor = map.get(roomX, roomY+1);

  //checks map for bording rooms based on adjacent pixel colours
  if (hereColor != grey) {
    if (westColor  != grey) west  = true;
    if (northColor != grey) north = true;
    if (eastColor  != grey) east  = true;
    if (southColor != grey) south = true;
  } else {
    //bug checking
    println("In a nonexistent room so hereColor is" + hereColor);
    println("roomX = " + roomX + "and roomY = " + roomY);
  }
}//-------------------------------------------------- switchRoom --------------------------------------------------

void drawRoom() {
  background(hereColor);

  //drawing the barriers
  rectMode(CORNERS);
  fill(grey);

  if (!west)  rect(0, 0, width * wallRatio, height);
  
  if (!north) rect(0, 0, width, height * wallRatio);
  
  if (!east)  rect(width * (1 - wallRatio), 0, width, height);
  
  if (!south) rect(0, height * (1 - wallRatio), width, height);
  rectMode(CENTER);
}//-------------------------------------------------- drawRoom --------------------------------------------------
