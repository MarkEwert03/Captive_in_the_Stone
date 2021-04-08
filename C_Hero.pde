class Hero extends Person {
  //Hero variables
  final float speed = dist(0, 0, width, height)/400;
  boolean countering = false;
  float multiplier = 1;
  String actionToDo = "";

  Hero() {
    //super
    super();
    c = blue;

    //Hero
    actionToDo = "";

    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y) {
    //super
    super(x, y);
    c = blue;

    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, cHP, mHP, c);

    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    //super
    super(copyHero);

    //Hero
    countering = copyHero.countering;
    actionToDo = copyHero.actionToDo;

    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == HERO || turn == ACTION) {
        tint(white);
      } else if (turn == ENEMY) {
        if (countering) tint(cyan);
        else tint(toDark(grey));
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
    float rand = 0;
    int crit;
    int miss;
    if (actionToDo.equals("poised strike")) {
      crit = int(random(8));
      miss = int(random(8));
      if (crit == 0) battleEnemy.battleText = "crit!";
      if (miss == 0) {
        battleEnemy.battleText = "miss...";
      } else {
        rand = random(8, 12);
        if (crit == 0) battleEnemy.damage(int(2*rand*multiplier));
        else battleEnemy.damage(int(rand*multiplier));
      }
    } 
    //-------------------------------------------
    else if (actionToDo.equals("reckless slash")) {
      crit = int(random(4));
      miss = int(random(2));
      if (crit == 0) battleEnemy.battleText = "crit!";
      if (miss == 0) {
        battleEnemy.battleText = "miss...";
      } else {
        rand = random(5, 20);
        if (crit == 0) battleEnemy.damage(int(2*rand*multiplier));
        else battleEnemy.damage(int(rand*multiplier));
      }
    } 
    //-------------------------------------------
    else if (actionToDo.equals("invigorate")) {
      battleEnemy.battleText = "invigorate!";
    } 
    //-------------------------------------------
    else if (actionToDo.equals("counter")) {
      countering = true;
    }
  }//-------------------------------------------------- action --------------------------------------------------

  void damage(int drop) { 
    super.damage(drop);
    if (currentHP <= 0) mode = LOSE;
  }//-------------------------------------------------- damage --------------------------------------------------
}//-------------------------------------------------- Hero --------------------------------------------------
