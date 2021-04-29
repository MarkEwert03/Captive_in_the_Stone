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
  endTimer = 0;
  turn = HERO;
  myHero.progress = 0;
  battleEnemy.progress = 0;
  battleEnd = false;
}//-------------------------------------------------- battleSetup --------------------------------------------------

void battle() {
  //UI
  battleUI();

  //Hero
  myHero.show();

  //codes the battle
  if (!battleEnd) {
    battleSequence();
  } else {
    if (endTimer == 0) battleTheme.pause();
    if (endTimer < BATTLE_PACE) {
      rectMode(CORNER);
      if (myHero.currentHP > 0) {
        fill(toLight(hereColor));
        rect(0, 0, width, height);
        fill(black);
        textSize(width/8);
        text("You defeated\nthe wastling!", width/2, height/2);
      } else {
        fill(toDark(hereColor));
        rect(0, 0, width, height);
        myHero.show();
      }
      endTimer++;
    } else {
      if (myHero.currentHP > 0) {
        clearedRooms[roomX][roomY] = true;
        gameSetup();
        switchRoom();
        battleEnd = false;
        mode = GAME;
      } else {
        battleTheme.close();
        bossTheme.close();
        mode = LOSE;
      }
    }
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

void battleSequence() {
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
      battleEnd = true;
    }
  }

  if (turn == HERO && myHero.currentHP <= 0) {
    myHero.currentAction = myHero.dead;
    myHero.threshold = BATTLE_PACE/3;
    battleEnd = true;
  }

  //music
  if (bossTime) {
    if (bossTheme.position() >= bossTheme.length() || !bossTheme.isPlaying()) bossTheme.rewind();
    if (mode == BATTLE) bossTheme.play();
  } else {
    if (battleTheme.position() >= battleTheme.length() || !battleTheme.isPlaying()) battleTheme.rewind();
    if (mode == BATTLE) battleTheme.play();
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
