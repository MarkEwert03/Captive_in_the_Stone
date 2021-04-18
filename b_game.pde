void gameSetup() {
  //Hero fields
  myHero.x = width/2;
  myHero.y = height/2;
  myHero.r = height/12;
  myHero.threshold = 5;
  
  //Hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkDown.get(0));
  myHero.currentAction = myHero.idle;
}

void game() {
  //room
  drawRoom();

  //Hero
  myHero.show();
  myHero.act();

  //Enemy
  for (Enemy e : enemyList) {
    e.show();
    if (dist(myHero.x, myHero.y, e.x, e.y) < myHero.r + e.r) {
      battleSetup();
      mode = BATTLE;
    }
  }
}//-------------------------------------------------- game --------------------------------------------------

void gameMousePressed() {
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
  if (hereColor != white) {
    if (westColor  != white) west  = true;
    if (northColor != white) north = true;
    if (eastColor  != white) east  = true;
    if (southColor != white) south = true;
  } else {
    //bug checking
    println("In a nonexistent room so hereColor is" + hereColor);
    println("roomX = " + roomX + " and roomY = " + roomY);
  }

  //adding enemies
  enemyList.clear();
  if (clearedRooms[roomX][roomY] == false) {
    if (west && roomX != pRoomX+1)  enemyList.add(new Enemy(height * wallRatio, height*random(0.25, 0.75), 'w'));
    if (north && roomY != pRoomY+1) enemyList.add(new Enemy(width*random(0.25, 0.75), height * wallRatio, 'n'));
    if (east && roomX != pRoomX-1)  enemyList.add(new Enemy(width * (1 - wallRatio), height*random(0.25, 0.75), 'e'));
    if (south && roomY != pRoomY-1) enemyList.add(new Enemy(width*random(0.25, 0.75), height * (1 - wallRatio), 's'));
    
    if (roomX == 5 && roomY == 1) enemyList.add(new Enemy(width*random(0.25, 0.75), height * wallRatio, 'n'));
  }
}//-------------------------------------------------- switchRoom --------------------------------------------------

void drawRoom() {
  background(hereColor);

  //drawing the barriers
  noStroke();
  rectMode(CORNERS);
  fill(grey);

  //use height instead of width so padding is consistant
  if (!west)  rect(0, 0, height * wallRatio, height);

  if (!north) rect(0, 0, width, height * wallRatio);

  //use height instead of width so padding is consistant
  if (!east)  rect(width - (height * wallRatio), 0, width, height);

  if (!south) rect(0, height * (1 - wallRatio), width, height);
  rectMode(CENTER);
}//-------------------------------------------------- drawRoom --------------------------------------------------

void battleTransition() {
}//-------------------------------------------------- battletransition --------------------------------------------------
