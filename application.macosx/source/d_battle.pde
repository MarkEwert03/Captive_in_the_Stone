void battleSetup() {
  //Hero
  myHero.x = width/4;
  myHero.y = height/3.75;
  myHero.r = height/6;
  myHero.threshold = 5;

  //Enemy
  if (!bossTime) battleEnemy = new Enemy(width*3/4, height/3.75, height/6, hereColor);
  else battleEnemy = new Enemy(width*3/4, height/3.6, height/4.75, hereColor);
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
  bossTheme.rewind();

  //other
  timer = 0;
  turn = HERO;
  myHero.progress = 0;
  battleEnemy.progress = 0;
}//-------------------------------------------------- battleSetup --------------------------------------------------

void battle() {
  battleUI();

  if (turn == HERO) {
    //other
    reverseOrder = false;

    //reset counter
    if (myHero.countering) myHero.resetCounter();
    else myHero.threshold = BATTLE_PACE/20;

    //reset anticipate
    if (battleEnemy.anticipating) battleEnemy.resetCounter();
    else battleEnemy.threshold = BATTLE_PACE/20;
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

  if (turn != ACTION && battleEnemy.currentHP <= 0) {
    if (bossTime) {
      battleTheme.close();
      bossTheme.close();
      mode = WIN;
    } else {
      clearedRooms[roomX][roomY] = true;
      gameSetup();
      switchRoom();
      battleTheme.pause();
      mode = GAME;
    }
  }

  if (turn == HERO && myHero.currentHP <= 0) {
    battleTheme.close();
    bossTheme.close();
    mode = LOSE;
  }

  //music
  if (bossTime) {
    if (bossTheme.position() >= bossTheme.length() || !bossTheme.isPlaying()) bossTheme.rewind();
    if (mode == BATTLE) bossTheme.play();
  } else {
    if (battleTheme.position() >= battleTheme.length() || !battleTheme.isPlaying()) battleTheme.rewind();
    if (mode == BATTLE) battleTheme.play();
  }
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
  if (bossTime) stroke(grey);
  else stroke(black);
  rect(x, y, width*7/16, height/8, 10);

  //text
  if (turn == HERO) {
    if (bossTime) fill(grey);
    else fill(black);
  } else {
    fill(grey);
  }
  textSize(height/16);
  text(txt, x, y);
}//-------------------------------------------------- battleButton --------------------------------------------------
