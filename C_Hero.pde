class Hero extends Person {
  //Hero variables
  final float speed = dist(0, 0, width, height)/150;
  boolean countering = false;

  Hero() {
    //super
    super();
    c = pink;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y, float r) {
    //super
    super(x, y, r);
    c = pink;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, cHP, mHP, c);

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    //super
    super(copyHero);
    x = width/2;
    y = height/2;
    r = height/4;

    //Hero
    countering = copyHero.countering;
    actionToDo = copyHero.actionToDo;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  private void allHeroConstructor() {
    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Charge", 7, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- allHeroConstructor --------------------------------------------------

  void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == HERO || turn == ACTION) {
        noTint();
      } else if (turn == ENEMY) {
        if (countering) tint(pink);
        else tint(toDark(grey));
      }
      fill(black);
      textSize(64);
      text(goodRound(powerLevels[progress], 1) + "x", x - 1.5*r, y);
    }

    //basic
    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

  void act() {
    if (hereColor == pink) currentHP = maxHP;

    //movement
    if (leftKey || upKey || rightKey || downKey) idle.clear();
    if (leftKey && !rightKey) {
      x -= speed;
      currentAction = walkLeft;
      idle.add(walkLeft.get(spriteNumber));
    }
    if (upKey && !downKey) {
      y -= speed;
      currentAction = walkUp;
      idle.add(walkUp.get(spriteNumber));
    }
    if (rightKey && !leftKey) {
      x += speed;
      currentAction = walkRight;
      idle.add(walkRight.get(spriteNumber));
    }
    if (downKey && !upKey) {
      y += speed;
      currentAction = walkDown;
      idle.add(walkDown.get(spriteNumber));
    }
    if (!leftKey && !upKey &&! rightKey && !downKey) {
      currentAction = idle;
    }

    //wall collision detection
    //use height instead of width so padding is consistant
    if (wWall && x - r*2/3 <= height * wallRatio) x = height * wallRatio + r*2/3;

    if (nWall && y - r*2/3 <= height * wallRatio) y = height * wallRatio + r*2/3;

    //use height instead of width so padding is consistant
    if (eWall && x + r*2/3 >= width - (height * wallRatio)) x = width - (height * wallRatio) - r*2/3;

    if (sWall && y + r >= height * (1 - wallRatio)) y = height * (1 - wallRatio) - r;

    //checks for paths
    if (west) checkWest();
    if (north) checkNorth();
    if (east) checkEast();
    if (south) checkSouth();
  }//-------------------------------------------------- act --------------------------------------------------

  void checkWest() {
    if (west && x - r <= 0) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomX--;
      switchRoom();
      x = width * (1 - wallRatio);
    }
  }//-------------------------------------------------- checkWest --------------------------------------------------

  void checkNorth() {
    if (north && y - r <= 0) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomY--;
      switchRoom();
      y = height * (1 - wallRatio);
    }
  }//-------------------------------------------------- checkNorth --------------------------------------------------

  void checkEast() {
    if (east && x + r >= width) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomX++;
      switchRoom();
      x = width * wallRatio;
    }
  }//-------------------------------------------------- checkEast --------------------------------------------------

  void checkSouth() {
    if (south && y + r >= height) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomY++;
      switchRoom();
      y = height * wallRatio;
    }
  }//-------------------------------------------------- checkSouth --------------------------------------------------

  void toBattle() {
    if (actionToDo.equals("poised strike") || actionToDo.equals("reckless slash")) {
      threshold = 5;
      //enemy moves to attack hero
      float dist = width/2 - r - battleEnemy.r;
      float speed = dist / (BATTLE_PACE/2);

      //hero starts to move towards enemy
      if (0 <= timer && timer < BATTLE_PACE/2) {
        x += speed;
        currentAction = walkRight;
      }   

      //after half time seconds the hero attacks
      if (timer == BATTLE_PACE/2) {
        currentAction = attackRight;
        animate();
        action();
      }

      //hero retreats back to starting position
      if (timer > BATTLE_PACE) {
        x -= speed;
        currentAction = walkRight;
      }
    } else {
      //invigorate or counter
      if (timer == 0) {
        myHero.threshold = BATTLE_PACE/15;
        if (actionToDo.equals("invigorate")) currentAction = chargeDown;
        else if (actionToDo.equals("counter")) currentAction = chargeRight;
        animate();
        action();
      }
    }

    //after full time it is Enemy's turn
    if (timer == BATTLE_PACE*1.5) {
      currentAction = idle;
      if (reverseOrder) {
        turn = HERO;
        actionToDo = "";
        battleEnemy.actionToDo = "";
      } else turn = ENEMY;
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ACTION) timer++;
    else timer = -BATTLE_PACE/2;
  }//-------------------------------------------------- toBattle --------------------------------------------------

  void action() {
    float rand;
    int crit, miss;

    if (actionToDo.equals("poised strike")) {
      crit = floor(random(15));
      miss = floor(random(20));
      if (!battleEnemy.anticipating) {
        if (crit == 0) battleEnemy.battleText = "crit!";
        if (miss == 0) {
          battleEnemy.battleText = "miss...";
        } else {
          rand = random(40, 60);
          if (crit == 0) battleEnemy.damage(int(2*rand*powerLevels[progress]));
          else battleEnemy.damage(int(rand*powerLevels[progress]));
        }
      } else {
        damage(int(powerLevels[battleEnemy.progress]*maxHP/10));
        battleEnemy.anticipating = false;
      }
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("reckless slash")) {
      crit = floor(random(2));
      miss = floor(random(4));
      if (!battleEnemy.anticipating) {
        if (crit == 0) battleEnemy.battleText = "crit!";
        if (miss == 0) {
          battleEnemy.battleText = "miss...";
        } else {
          rand = random(25, 100);
          if (crit == 0) battleEnemy.damage(int(2*rand*powerLevels[progress]));
          else battleEnemy.damage(int(rand*powerLevels[progress]));
        }
      } else {
        damage(int(powerLevels[battleEnemy.progress]*maxHP/10));
        battleEnemy.anticipating = false;
      }
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("invigorate")) {
      if (progress < 6) progress++;
      else battleText = "power level is maxed";
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("counter")) {
      countering = true;
    }
    //- - - - - - - - - - - - - - - - - - - - - -
    else {
      print("error! not a valid action");
    }
  }//-------------------------------------------------- action --------------------------------------------------

  void resetCounter() {
    if (currentAction != dead) {
      spriteNumber = 0;
      spriteNumber = 0;
      threshold = 10;
      currentAction = dead;
    }
    if (countering) {
      if (spriteNumber >= 5) {
        damage(maxHP/10);
        spriteNumber = 0;
        count = 0;
        currentAction = idle;
        threshold = 5;
        countering = false;
      }
    }
  }//-------------------------------------------------- resetCounter --------------------------------------------------

}//-------------------------------------------------- Hero --------------------------------------------------
