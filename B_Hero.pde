class Hero {

  //instance variables
  float x, y, r, speed;
  int currentHP, maxHP, charge;
  String actionToDo;

  //constructor(s)
  Hero() {
    //basic
    x = width/2;
    y = height/2;
    r = (width*height)/40000;
    speed = dist(0, 0, width, height)/200;

    maxHP = 100;
    currentHP = maxHP;
    charge = 1;
    
    actionToDo = "";
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y, float r, float speed, int cHP, int mHP) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.speed = speed;

    this.currentHP = cHP;
    this.maxHP = mHP;
    charge = 1;
    
    actionToDo = "";
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    x = copyHero.x;
    y = copyHero.y;
    r = copyHero.r;
    speed = copyHero.speed;

    currentHP = copyHero.currentHP;
    maxHP = copyHero.maxHP;
    charge = copyHero.charge;
    
    actionToDo = copyHero.actionToDo;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    //image
    noStroke();
    if (turn == HERO || turn == ACTION) {
      if (charge == 1) fill(yellow);
      else fill(toLight(yellow));
    } else if (turn == ENEMY){
      fill (toDark(yellow));
    }
    ellipse(x, y, 2*r, 2*r);

    //HP bar
    if (mode == BATTLE || mode == MENU) healthBar();
  }//-------------------------------------------------- show --------------------------------------------------

  void act() {
    //movement
    if (upKey)    y -= speed;
    if (downKey)  y += speed;
    if (leftKey)  x -= speed;
    if (rightKey) x += speed;

    //wall collision detection
    //use height instead of width so padding is consistant
    if (!west && x - r <= height * wallRatio) x = height * wallRatio + r;

    if (!north && y - r <= height * wallRatio) y = height * wallRatio + r;

    //use height instead of width so padding is consistant
    if (!east && x + r >= width - (height * wallRatio)) x = width - (height * wallRatio) - r;

    if (!south && y + r >= height * (1 - wallRatio)) y = height * (1 - wallRatio) - r;

    //checks for paths
    if (west) checkWest();
    if (north) checkNorth();
    if (east) checkEast();
    if (south) checkSouth();
  }//-------------------------------------------------- show --------------------------------------------------

  void checkWest() {
    if (west && x - r <= 0) {
      roomX--;
      switchRoom();
      x = width * (1 - wallRatio) - r;
    }
  }//-------------------------------------------------- checkWest --------------------------------------------------

  void checkNorth() {
    if (north && y - r <= 0) {
      roomY--;
      switchRoom();
      y = height * (1 - wallRatio) - r;
    }
  }//-------------------------------------------------- checkNorth --------------------------------------------------

  void checkEast() {
    if (east && x + r >= width) {
      roomX++;
      switchRoom();
      x = width * wallRatio + r;
    }
  }//-------------------------------------------------- checkEast --------------------------------------------------

  void checkSouth() {
    if (south && y + r >= height) {
      roomY++;
      switchRoom();
      y = height * wallRatio + r;
    }
  }//-------------------------------------------------- cehckSouth --------------------------------------------------

  private void healthBar() {
    float HP_X = map(currentHP, 0, maxHP, 0, 2*r);

    //inner health
    rectMode(CORNER);
    noStroke();
    fill(toLight(pink));
    rect(x - r, y - r*1.75, HP_X, r/2);

    //outer shell
    rectMode(CENTER);
    stroke(2);
    noFill();
    rect(x, y - r*1.5, 2*r, r/2);

    //text amount
    fill(toDark(pink));
    textSize(r/4);
    text ("" + currentHP, x, y - r*1.5);
  }//-------------------------------------------------- healthBar --------------------------------------------------

  void action() {
    int rand = 0;
    if (actionToDo.equals("normal attack")) {
      rand = (int)random(8, 12);
      battleEnemy.damage(rand*charge);
      charge = 1;
    } else if (actionToDo.equals("risky attack")) {
      rand = (int)random(10, 20);
      battleEnemy.damage(rand*charge);
      charge = 1;
    } else if (actionToDo.equals("charge up")) {
      charge = 2;
    } else if (actionToDo.equals("heal")) {
      rand = (int)random(10, 20);
      if (currentHP + rand*charge < maxHP) {
        currentHP += rand*charge;
      } else currentHP = maxHP;
      charge = 1;
    }
  }//-------------------------------------------------- action --------------------------------------------------

  void damage(int drop) { 
    if (currentHP - drop <= 0) {
      mode = INTRO;
    } else currentHP -= drop;
  }//-------------------------------------------------- healthBar --------------------------------------------------
}//-------------------------------------------------- Hero --------------------------------------------------
