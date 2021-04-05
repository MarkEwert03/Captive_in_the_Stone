void battleSetup() {
  //Hero
  myHero.x = width/4;
  myHero.y = height/4;
  myHero.r = height/8;

  //Enemy
  battleEnemy = new Enemy(width*3/4, height/4, height/8, 100, 100, red);
  
  //hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkRight.get(0));
  myHero.currentAction = myHero.idle;
}

void battle() {
  //general
  background(toDark(cyan));
  stroke(white);
  strokeWeight(5);
  line(width/2, height/2, width/2, height);
  line(0, height/2, width, height/2);
  line(0, height*3/4, width, height*3/4);

  //Hero
  myHero.show();
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
      else timer = 0;
    } else {
      myHero.action();
      myHero.currentAction = myHero.idle;
      turn = ENEMY;
    }
  }

  //Enemy
  battleEnemy.show();
  if (turn == ENEMY) {
    //enemy moves to attack hero
    float dist = width/2 - battleEnemy.r - myHero.r;
    float speed = dist / (BATTLE_PACE/2);
    if (timer <= BATTLE_PACE/2) {
      battleEnemy.x -= speed;
    }

    //after half time the enemy attacks
    if (timer == BATTLE_PACE/2) {
      int rand = (int)random(8, 12);
      myHero.damage(rand);
    }

    //enemy retreats back to starting position
    if (timer >= BATTLE_PACE/2) {
      battleEnemy.x += speed;
    }

    //after full time it is Hero's turn
    if (timer == BATTLE_PACE) {
      myHero.countering = false;
      turn = HERO;
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }

  //Buttons
  //top left
  battleButton(width/4, height*5/8, "poised strike");

  //top right
  battleButton(width*3/4, height*5/8, "reckless slash");

  //bottom left
  battleButton(width/4, height*7/8, "invigorate");

  //bottom right
  battleButton(width*3/4, height*7/8, "counter");
}//-------------------------------------------------- battle --------------------------------------------------

void battleMousePressed() {
  if (turn == HERO) {
    turn = ACTION;
    myHero.actionToDo = heroChoice;
  }
}//-------------------------------------------------- battleMousePressed --------------------------------------------------

void battleButton(float x, float y, String txt) {
  rectMode(CENTER);
  //tactile
  float left = x - width*7/32;
  float right = x + width*7/32;
  float top = y - height/16;
  float bottom = y + height/16;
  if (mouseX > left && mouseY > top && mouseX < right && mouseY < bottom) {
    if (turn == HERO) fill (toLight(cyan));
    else fill(white);
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
