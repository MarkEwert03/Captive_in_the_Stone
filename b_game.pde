void gameSetup() {
  myHero.x = width/2;
  myHero.y = height/2;
  
  enemyList.clear();
  if (west)  enemyList.add(new Enemy());
  if (north) enemyList.add(new Enemy(width/2, height/4));
  if (east)  enemyList.add(new Enemy(height*3/4, height/2));
  if (south) enemyList.add(new Enemy(width/2, height*3/4));
  enemyList.add(new Enemy(100, 100));
  print(enemyList.size());
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
  }

  //battleCollision
  for (Enemy e : enemyList) {
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
  if (hereColor != grey) {
    if (westColor  != grey) west  = true;
    if (northColor != grey) north = true;
    if (eastColor  != grey) east  = true;
    if (southColor != grey) south = true;
  } else {
    //bug checking
    println("In a nonexistent room so hereColor is" + hereColor);
    println("roomX = " + roomX + " and roomY = " + roomY);
  }
}//-------------------------------------------------- switchRoom --------------------------------------------------

void drawRoom() {
  background(hereColor);

  //drawing the barriers
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
