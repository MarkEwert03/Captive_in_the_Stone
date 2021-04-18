class Enemy extends Person {
  boolean anticipating = false;

  Enemy() {
    //super
    super();
    c = red;

    //animation
    allEnemyConstructor();
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y, int direction) {
    //super
    super(x, y);
    c = red;
    
    //animation
    allEnemyConstructor();
    idle.clear();
    if (direction == 'w') idle.add(attackRight.get(4));
    else if (direction == 'n') idle.add(attackDown.get(4));
    else if (direction == 'e') idle.add(attackLeft.get(4));
    else if (direction == 's') idle.add(attackUp.get(4));
    else idle.add(dead.get(4));

  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, mHP, cHP, c);
    c = red;

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
        tint(white);
      } else if (turn == HERO || turn == ACTION) {
        tint(toDark(grey));
      }
    }

    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

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
        if (actionToDo.equals("enrage")) currentAction = chargeDown;
        else if (actionToDo.equals("anticipate")) currentAction = chargeLeft;
        animate();
        action();
      }
    }

    //after full time it is Hero's turn
    if (timer == BATTLE_PACE*1.5) {
      currentAction = idle;
      turn = HERO;
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }//-------------------------------------------------- toBattle --------------------------------------------------

  void decideAction(color roomC) {
    //0 = unruly stab
    //1 = barbaric thrust
    //2 = enrage
    //3 = anticipate
    int[] choices;

    choices = new int[]{0, 1, 2, 3};
    int chosenAction = choices[floor(random(choices.length))];
    if (chosenAction == 0) actionToDo = "unruly stab";
    else if (chosenAction == 1) actionToDo = "barbaric thrust";
    else if (chosenAction == 2) actionToDo = "enrage";
    else if (chosenAction == 3) actionToDo = "anticipate";
    else actionToDo = "error! not a valid action";
  }//-------------------------------------------------- decideAction --------------------------------------------------

  void action() {
    float rand;
    int crit, miss;

    if (actionToDo.equals("unruly stab")) {
      crit = floor(random(20));
      miss = floor(random(15));
      if (crit == 0) myHero.battleText = "crit...";
      if (miss == 0) myHero.battleText = "miss!";
      else {
        rand = random(40, 60);
        if (crit == 0) myHero.damage(int(2*rand*multiplier));
        else myHero.damage(int(rand*multiplier));
      }
    }
    //- - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("barbaric thrust")) {
      crit = floor(random(6));
      miss = floor(random(4));
      if (crit == 0) myHero.battleText = "crit...";
      if (miss == 0) myHero.battleText = "miss!";
      else {
        rand = random(25, 75);
        if (crit == 0) myHero.damage(int(2*rand*multiplier));
        else myHero.damage(int(rand*multiplier));
      }
    }
    // - - - - - - - - - - - - - - - - - - - - 
    else if (actionToDo.equals("enrage")) {
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
