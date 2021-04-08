class Enemy extends Person {

  Enemy() {
    //super
    super();
    c = red;

    //animation
    bulkImageImport("Enemy", "Walk", 9, true);
    bulkImageImport("Enemy", "Attack", 8, true);
    bulkImageImport("Enemy", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y) {
    //super
    super(x, y);
    c = red;

    //animation
    bulkImageImport("Enemy", "Walk", 9, true);
    bulkImageImport("Enemy", "Attack", 8, true);
    bulkImageImport("Enemy", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = attackLeft;
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, mHP, cHP, c);
    c = red;

    //animation
    bulkImageImport("Enemy", "Walk", 9, true);
    bulkImageImport("Enemy", "Attack", 8, true);
    bulkImageImport("Enemy", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Enemy(Enemy copyEnemy) {
    //super
    super(copyEnemy);
    c = red;

    //animation
    bulkImageImport("Enemy", "Walk", 9, true);
    bulkImageImport("Enemy", "Attack", 8, true);
    bulkImageImport("Enemy", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

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

  void damage(int drop) { 
    super.damage(drop);
    if (currentHP <= 0) mode = GAME;
  }//-------------------------------------------------- damage --------------------------------------------------

  float move(float edge, int sec) {
    float startX = x;

    float dist = abs( (width*3/4) - edge );
    float speed = dist/(sec*60);
    x -= speed;

    return startX;
  }//-------------------------------------------------- move --------------------------------------------------
}//-------------------------------------------------- Enemy --------------------------------------------------
