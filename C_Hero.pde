class Hero extends Person {
  //Hero variables
  final float speed = dist(0, 0, width, height)/200;
  int charge;
  String actionToDo;

  Hero() {
    //takes care of x, y, r, currentHP, and maxHP
    super();
    c = blue;

    actionToDo = "";
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y) {
    super(x, y);
    c = blue;

    charge = 1;
    actionToDo = "";

    //Animation
    spriteNumber = 0;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(float x, float y, float r, int mHP, int cHP, int c) {
    super(x, y, r, cHP, mHP, c);

    charge = 1;
    actionToDo = "";

    //Animation
    spriteNumber = 0;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    super(copyHero);

    charge = copyHero.charge;
    actionToDo = copyHero.actionToDo;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == HERO || turn == ACTION) {
        if (charge == 1) tint(white);
        if (charge == 2) tint(toLight(green));
      } else if (turn == ENEMY) {
        tint(toDark(grey));
      }
    }

    //basic
    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

  void act() {
    //movement
    if (leftKey || upKey || rightKey || downKey) idle.clear();
    if (leftKey) {
      x -= speed;
      currentAction = walkLeft;
      idle.add(walkLeft.get(spriteNumber));
    }
    if (upKey) {
      y -= speed;
      currentAction = walkUp;
      idle.add(walkUp.get(spriteNumber));
    }
    if (rightKey) {
      x += speed;
      currentAction = walkRight;
      idle.add(walkRight.get(spriteNumber));
    }
    if (downKey) {
      y += speed;
      currentAction = walkDown;
      idle.add(walkDown.get(spriteNumber));
    }
    if (!leftKey && !upKey &&! rightKey && !downKey) {
      currentAction = idle;
    }

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
  }//-------------------------------------------------- act --------------------------------------------------

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
    super.damage(drop);
    if (currentHP <= 0) mode = LOSE;
  }//-------------------------------------------------- healthBar --------------------------------------------------
}//-------------------------------------------------- Hero --------------------------------------------------
