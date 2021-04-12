void battleSetup() {
  //Hero
  myHero.x = width/4;
  myHero.y = height/4;
  myHero.r = height/6;
  myHero.threshold = 5;

  //Enemy
  battleEnemy = new Enemy(width*3/4, height/4, height/6, 500, 500, black);
  battleEnemy.threshold = 5;

  //hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkRight.get(0));
  myHero.currentAction = myHero.idle;

  //enemy animation
  battleEnemy.idle.clear();
  battleEnemy.idle.add(battleEnemy.walkLeft.get(0));
  battleEnemy.currentAction = battleEnemy.idle;
}//-------------------------------------------------- battleSetup --------------------------------------------------

void battle() {
  battleUI();

  //Hero
  myHero.show();
  if (!myHero.actionToDo.isEmpty())myHero.textFade();
  if (turn == ACTION) {
    if (myHero.actionToDo.equals("poised strike") || myHero.actionToDo.equals("reckless slash")) {
      //enemy moves to attack hero
      float dist = width/2 - myHero.r - battleEnemy.r;
      float speed = dist / (BATTLE_PACE/2);

      //hero starts to move towards enemy
      if (timer < BATTLE_PACE/2) {
        myHero.x += speed;
        myHero.currentAction = myHero.walkRight;
      }   

      //after half time seconds the hero attacks
      if (timer == BATTLE_PACE/2) {
        myHero.currentAction = myHero.attackRight;
        myHero.animate();
        myHero.action();
      }

      //hero retreats back to starting position
      if (timer > BATTLE_PACE) {
        myHero.x -= speed;
        myHero.currentAction = myHero.walkRight;
      }

      //after full time it is Enemy's turn
      if (timer == BATTLE_PACE*1.5) {
        myHero.currentAction = myHero.idle;
        turn = ENEMY;
      }

      //keep couting until enemy's turn is done and then reset timer
      if (turn == ACTION) timer++;
      else timer = -BATTLE_PACE/2;
    } else {
      myHero.action();
      myHero.currentAction = myHero.idle;
      turn = ENEMY;
    }
  }

  //Enemy
  battleEnemy.show();
  if (!battleEnemy.battleText.isEmpty()) battleEnemy.textFade();
  if (turn == ENEMY) {
    //enemy moves to attack hero
    float dist = width/2 - battleEnemy.r - myHero.r;
    float speed = dist / (BATTLE_PACE/2);
    if (0 <= timer && timer <= BATTLE_PACE/2) {
      battleEnemy.x -= speed;
      battleEnemy.currentAction = battleEnemy.walkLeft;
    }

    //after half time the enemy attacks
    if (timer == BATTLE_PACE/2) {
      battleEnemy.currentAction = battleEnemy.attackLeft;
      battleEnemy.animate();
      int rand = (int)random(8, 12);
      myHero.damage(rand);
    }


    //enemy retreats back to starting position
    if (timer > BATTLE_PACE) {
      battleEnemy.x += speed;
      battleEnemy.currentAction = battleEnemy.walkLeft;
    }

    //after full time it is Hero's turn
    if (timer == BATTLE_PACE*1.5) {
      myHero.countering = false;
      battleEnemy.currentAction = battleEnemy.idle;
      turn = HERO;
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }
}//-------------------------------------------------- battle --------------------------------------------------

void battleMousePressed() {
  if (turn == HERO && !heroChoice.isEmpty()) {
    turn = ACTION;
    myHero.actionToDo = heroChoice;
  }
}//-------------------------------------------------- battleMousePressed --------------------------------------------------

void battleUI() {
  //General
  background(toDark(hereColor));
  if (turn == HERO) {
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
  } else{
    noStroke();
    fill(hereColor);
    rectMode(CORNER);
    rect(0, height/2, width, height/2);
    fill(black);
    textSize(96);
    if (turn == ACTION) text("Hero uses " + myHero.actionToDo + "!", width/2, height*3/4);
    else if (turn == ENEMY) text("Opposing enemy uses unruly stab!", width/2, height*3/4);
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
