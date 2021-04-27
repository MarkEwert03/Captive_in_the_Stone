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

  //music
  gameTheme.rewind();
}

void game() {
  //boss check
  if (roomX == 5 && roomY == 2) bossTime = true;
  
  //checkpoint check
  if (hereColor == violet) checkPoint = true;
  
  //room
  drawRoom();

  //Hero
  myHero.show();
  myHero.act();

  //music
  if (gameTheme.position() == gameTheme.length()) gameTheme.rewind();
  gameTheme.play();

  //Enemy
  for (Enemy e : enemyList) {
    e.show();
    if (dist(myHero.x, myHero.y, e.x, e.y) < myHero.r + e.r) {
      gameTheme.pause();
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
    println("In a nonexistent room so hereColor is " + hereColor);
    println("roomX = " + roomX + " and roomY = " + roomY);
  }

  //adding enemies
  enemyList.clear();
  if (clearedRooms[roomX][roomY] == false) {
    if (west && roomX != pRoomX+1)  enemyList.add(new Enemy(width * wallRatio, height*random(0.25, 0.75), 'w'));
    if (north && roomY != pRoomY+1) enemyList.add(new Enemy(width*random(0.25, 0.75), height * 2*wallRatio, 'n'));
    if (east && roomX != pRoomX-1)  enemyList.add(new Enemy(width * (1 - wallRatio), height*random(0.25, 0.75), 'e'));
    if (south && roomY != pRoomY-1) enemyList.add(new Enemy(width*random(0.25, 0.75), height * (1 - 2*wallRatio), 's'));

    if (roomX == 5 && roomY == 2) enemyList.add(new Enemy(width/2, height*2*wallRatio, width/10, hereColor));
  }
}//-------------------------------------------------- switchRoom --------------------------------------------------

void drawRoom() {
  background(white);
  tint(hereColor);
  imageMode(CENTER);
  for (int w = 140; w < width*1.25; w += 280) {
    for (int h = 140; h < height*1.25; h += 280) {
      image(floor, w, h);
    }
  }

  imageMode(CORNER);
  for (int w = 0; w < width; w += wall.width/2) {
    for (int h = 0; h < height; h += wall.height/2) {
      if (w == 0 && wWall) image(wall, w, h);
      else if (h == 0 && nWall) image(wall, w, h);
      else if (w >= width - (height * wallRatio) && eWall) image(wall, width - wall.width, h);
      else if (h >= height * (1 - wallRatio) && sWall) image(wall, w, height - wall.height);
    }
  }

  //drawing the barriers
  noStroke();
  rectMode(CORNERS);

  boolean cleared = clearedRooms[roomX][roomY];
  //use height instead of width so padding is consistant

  //left wall
  if (!west) {
    fill(black, 192);
    rect(0, 0, height * wallRatio, height);
    wWall = true;
  } else if (!cleared && roomX != pRoomX+1 || roomX == 5) {
    fill(toDark(map.get(roomX-1, roomY)), 128);
    rect(0, 0, height * wallRatio, height);
    wWall = true;
  } else wWall = false;

  //top wall
  if (!north) {
    fill(black, 192);
    rect(0, 0, width, height * wallRatio);
    nWall = true;
  } else if (!cleared && roomY != pRoomY+1) {
    fill(toDark(map.get(roomX, roomY-1)), 128);
    rect(0, 0, width, height * wallRatio);
    nWall = true;
  } else nWall = false;

  //use height instead of width so padding is consistant
  //right wall
  if (!east) {
    fill(black, 192);
    rect(width - (height * wallRatio), 0, width, height);
    eWall = true;
  } else if (!cleared && roomX != pRoomX-1) {
    fill(toDark(map.get(roomX+1, roomY)), 128);
    rect(width - (height * wallRatio), 0, width, height);
    eWall = true;
  } else eWall = false;

  //bottom wall
  if (!south) {
    fill(black, 192);
    rect(0, height * (1 - wallRatio), width, height);
    sWall = true;
  } else if (!cleared && roomY != pRoomY-1) {
    fill(toDark(map.get(roomX, roomY+1)), 128);
    rect(0, height * (1 - wallRatio), width, height);
    sWall = true;
  } else sWall = false;

  //corner pieces
  fill(black);
  rect(0, 0, height*wallRatio, height*wallRatio);
  rect(width - (height * wallRatio), 0, width, height*wallRatio);
  rect(0, height * (1-wallRatio), height*wallRatio, height);
  rect(width - (height*wallRatio), height * (1-wallRatio), width, height);
  rectMode(CENTER);
}//-------------------------------------------------- drawRoom --------------------------------------------------

void battleTransition() {
}//-------------------------------------------------- battletransition --------------------------------------------------
