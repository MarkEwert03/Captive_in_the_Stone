void battleSetup() {
  //Hero
  battleHero = new Hero(width/4, height/4, height/8, 0, myHero.currentHP, myHero.maxHP);


  //Battle
  battleEnemy = new Enemy(width*3/4, height/4, height/8, 0, 100, 100);
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
  battleHero.show();

  //Enemy
  battleEnemy.show();
  if (turn == ENEMY){
    //after 3 seconds the enemy attacks
    if (timer == 180) {
      int rand = (int)random(8, 12);
      battleHero.damage(rand);
    }
    
    //after 6 seconds it is Hero's turn
    if (timer == 360) {
      turn = HERO;
    }
    
    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }

  //Buttons
  //top left
  battleButton(width/4, height*5/8, "normal attack");

  //top right
  battleButton(width*3/4, height*5/8, "risky attack");

  //bottom left
  battleButton(width/4, height*7/8, "charge up");

  //bottom right
  battleButton(width*3/4, height*7/8, "heal");
}//-------------------------------------------------- battle --------------------------------------------------

void battleMousePressed() {
  if (turn == HERO) {
    battleHero.action(heroChoice);
    turn = ENEMY;
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
