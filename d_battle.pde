void battleSetup() {
  //Hero
  myHero.x = width/4;
  myHero.y = height/4;
  myHero.r = height/6;
  myHero.threshold = 5;

  //Enemy
  battleEnemy = new Enemy(width*3/4, height/4, height/6, hereColor);
  battleEnemy.threshold = 5;

  //hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkRight.get(0));
  myHero.currentAction = myHero.idle;

  //enemy animation
  battleEnemy.idle.clear();
  battleEnemy.idle.add(battleEnemy.walkLeft.get(0));
  battleEnemy.currentAction = battleEnemy.idle;

  //music
  battleTheme.rewind();

  //other
  timer = 0;
  turn = HERO;
}//-------------------------------------------------- battleSetup --------------------------------------------------

void battle() {
  battleUI();

  if (turn == HERO) {
    //other
    reverseOrder = false;
    myHero.threshold = BATTLE_PACE/20;
    battleEnemy.threshold = BATTLE_PACE/20;

    //reset counter
    myHero.resetCounter();

    //reset anticipate
    battleEnemy.resetCounter();
  }

  //Hero
  myHero.show();
  if (!myHero.battleText.isEmpty()) myHero.textFade();
  if (turn == ACTION) {
    myHero.toBattle();
  }

  //Enemy
  battleEnemy.show();
  if (battleEnemy.actionToDo.isEmpty()) battleEnemy.decideAction();
  if (!battleEnemy.battleText.isEmpty()) battleEnemy.textFade();
  if (turn == ENEMY) {
    battleEnemy.toBattle();
  }

  if (turn != ACTION && battleEnemy.currentHP == 0) {
    clearedRooms[roomX][roomY] = true;
    gameSetup();
    switchRoom();
    battleTheme.pause();
    mode = GAME;
  }

  //music
  if (battleTheme.position() >= battleTheme.length() || !battleTheme.isPlaying()) battleTheme.rewind();
  if (mode == BATTLE) battleTheme.play();
}//-------------------------------------------------- battle --------------------------------------------------

void battleMousePressed() {
  if (turn == HERO && !heroChoice.isEmpty()) {
    timer = -BATTLE_PACE/2;
    if (battleEnemy.actionToDo.equals("anticipate") && !heroChoice.equals("counter")) {
      reverseOrder = true;
      turn = ENEMY;
    } else turn = ACTION;
    myHero.actionToDo = heroChoice;
  }
}//-------------------------------------------------- battleMousePressed --------------------------------------------------

void battleUI() {
  //General
  background(toDark(hereColor));
  if (turn == HERO && !(myHero.countering || battleEnemy.anticipating)) {
    stroke(white);
    strokeWeight(5);
    line(width/2, height/2, width/2, height);
    line(0, height/2, width, height/2);
    line(0, height*3/4, width, height*3/4);

    //Buttons
    //top left
    battleButton(width/4, height*5/8, "poised strike");

    //top right
    battleButton(width*3/4, height*5/8, "reckless slash");

    //bottom left
    battleButton(width/4, height*7/8, "invigorate");

    //bottom right
    battleButton(width*3/4, height*7/8, "counter");
  } else {
    noStroke();
    fill(hereColor);
    rectMode(CORNER);
    rect(0, height/2, width, height/2);
    fill(black);
    textSize(width/20);
    if (turn == ACTION) text("Hero uses " + myHero.actionToDo + "!", width/2, height*3/4);
    else if (turn == ENEMY) text("Opposing enemy uses " + battleEnemy.actionToDo, width/2, height*3/4);
  }
}//-------------------------------------------------- battleUI --------------------------------------------------

void battleButton(float x, float y, String txt) {
  rectMode(CENTER);
  //tactile
  float left = x - width*7/32;
  float right = x + width*7/32;
  float top = y - height/16;
  float bottom = y + height/16;
  if (mouseX > left && mouseY > top && mouseX < right && mouseY < bottom) {
    fill (toLight(hereColor));
    heroChoice = txt;
  } else {
    fill(white);
    if (txt.equals("normal attack")) heroChoice = "";
  }

  //button base
  stroke(black);
  rect(x, y, width*7/16, height/8, 10);

  //text
  if (turn == HERO) fill(black);
  else fill(grey);
  textSize(height/16);
  text(txt, x, y);
}//-------------------------------------------------- battleButton --------------------------------------------------
