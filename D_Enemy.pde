class Enemy extends Person {
  boolean anticipating = false;

  Enemy() {
    //super
    super();
    c = hereColor;

    //animation
    allEnemyConstructor();
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y, int direction) {
    //super
    super(x, y, height/12);
    c = hereColor;

    //animation
    allEnemyConstructor();
    idle.clear();
    if (direction == 'w') idle.add(attackRight.get(4));
    else if (direction == 'n') idle.add(attackDown.get(4));
    else if (direction == 'e') idle.add(attackLeft.get(4));
    else if (direction == 's') idle.add(attackUp.get(4));
    else idle.add(dead.get(4));
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, color c) {
    //super
    super(x, y, r);
    this.c = hereColor;

    //health
    if (c == yellow) maxHP = 100;
    else if (c == orange || c == green) maxHP = 200;
    else if (c == cyan) maxHP = 250;
    else if (c == blue) maxHP = 300;
    else if (c == navy) maxHP = 400;
    else if (c == darkGrey) maxHP = 500;
    else maxHP = 10;
    currentHP = maxHP;

    //animation
    allEnemyConstructor();
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Enemy(Enemy copyEnemy) {
    //super
    super(copyEnemy);
    c = red;

    //animation
    allEnemyConstructor();
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  private void allEnemyConstructor() {
    //animation
    bulkImageImport("Enemy", "Walk", 9, true);
    bulkImageImport("Enemy", "Attack", 8, true);
    bulkImageImport("Enemy", "Charge", 7, true);
    bulkImageImport("Enemy", "Dead", 6, false);
    idle.add(chargeDown.get(4));
    currentAction = idle;
  }//-------------------------------------------------- allHeroConstructor --------------------------------------------------

  void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == ENEMY) {
        noTint();
      } else if (turn == HERO || turn == ACTION) {
        if (anticipating) tint(hereColor, 196);
        else tint(toDark(grey));
      }
      fill(black);
      textSize(64);
      text(goodRound(powerLevels[progress], 1) + "x", x + 2*r, y);
    }

    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

  void decideAction() {
    //0 = unruly stab
    //1 = barbaric thrust
    //2 = enrage
    //3 = anticipate
    int[] choices;
    int chosenAction;

    if (this.c == yellow) {
      chosenAction = 3;
    } else if (this.c == orange) {
      choices = new int[]{0, 1, 3, 3, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else if (this.c == green) {
      if (progress < 6) chosenAction = 2;
      else {
        choices = new int[]{0, 1};
        chosenAction = choices[floor(random(choices.length))];
      }
    } else if (this.c == cyan || this.c == blue || this.c == navy) {
      choices = new int[]{0, 1, 2, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else chosenAction = 0;




    if (chosenAction == 0) actionToDo = "unruly stab";
    else if (chosenAction == 1) actionToDo = "barbaric thrust";
    else if (chosenAction == 2) actionToDo = "enrage";
    else if (chosenAction == 3) actionToDo = "anticipate";
    else actionToDo = "error! not a valid action";
  }//-------------------------------------------------- decideAction --------------------------------------------------

  void toBattle() {
    if (actionToDo.equals("unruly stab") || actionToDo.equals("barbaric thrust")) {
      //enemy moves to attack hero
      float dist = width/2 - battleEnemy.r - myHero.r;
      float speed = dist / (BATTLE_PACE/2);
      if (0 <= timer && timer <= BATTLE_PACE/2) {
        x -= speed;
        currentAction = walkLeft;
      }

      //after half time the enemy attacks
      if (timer == BATTLE_PACE/2) {
        currentAction = attackLeft;
        animate();
        action();
      }

      //enemy retreats back to starting position
      if (timer > BATTLE_PACE) {
        x += speed;
        currentAction = walkLeft;
      }
    } else {
      //enrage or anticipate
      if (timer == 0) {
        battleEnemy.threshold = BATTLE_PACE/15;
        if (actionToDo.equals("enrage")) currentAction = chargeDown;
        else if (actionToDo.equals("anticipate")) currentAction = chargeLeft;
        animate();
        action();
      }
    }

    //after full time it is Hero's turn
    if (timer == BATTLE_PACE*1.5) {
      currentAction = idle;
      if (reverseOrder) turn = ACTION;
      else {
        turn = HERO;
        actionToDo = "";
        battleEnemy.actionToDo = "";
      }
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }//-------------------------------------------------- toBattle --------------------------------------------------

  void action() {
    float rand;
    int crit, miss;

    if (actionToDo.equals("unruly stab")) {
      crit = floor(random(20));
      miss = floor(random(15));
      if (!myHero.countering) {
        if (crit == 0) myHero.battleText = "crit...";
        if (miss == 0) {
          myHero.battleText = "miss!";
        } else {
          rand = random(40, 60);
          if (crit == 0) myHero.damage(int(2*rand*powerLevels[progress]));
          else myHero.damage(int(rand*powerLevels[progress]));
        }
      } else {
        damage(int(powerLevels[myHero.progress]*maxHP/10));
        myHero.countering = false;
      }
    }
    //- - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("barbaric thrust")) {
      crit = floor(random(6));
      miss = floor(random(4));
      if (!myHero.countering) {
        if (crit == 0) myHero.battleText = "crit...";
        if (miss == 0) myHero.battleText = "miss!";
        else {
          rand = random(25, 75);
          if (crit == 0) myHero.damage(int(2*rand*powerLevels[progress]));
          else myHero.damage(int(rand*powerLevels[progress]));
        }
      } else {
        damage(int(powerLevels[myHero.progress]*maxHP/10));
        myHero.countering = false;
      }
    }
    // - - - - - - - - - - - - - - - - - - - - 
    else if (actionToDo.equals("enrage")) {
      if (progress < 6) progress++;
      else battleText = "power level is maxed";
    } 
    // - - - - - - - - - - - - - - - - - - - - 
    else if (actionToDo.equals("anticipate")) {
      anticipating = true;
    } 
    //- - - - - - - - - - - - - - - - - - - - 
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
    if (anticipating) {
      if (spriteNumber >= 5) {
        damage(maxHP/10);
        spriteNumber = 0;
        count = 0;
        currentAction = idle;
        threshold = 5;
        anticipating = false;
      }
    }
  }//-------------------------------------------------- resetCounter --------------------------------------------------

  void damage(int drop) { 
    super.damage(drop);
    if (currentHP <= 0) {
      currentHP = 0;
    }
  }//-------------------------------------------------- damage --------------------------------------------------

  float move(float edge, int sec) {
    float startX = x;

    float dist = abs( (width*3/4) - edge );
    float speed = dist/(sec*60);
    x -= speed;

    return startX;
  }//-------------------------------------------------- move --------------------------------------------------
}//-------------------------------------------------- Enemy --------------------------------------------------
