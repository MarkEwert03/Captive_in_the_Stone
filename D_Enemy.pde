class Enemy extends Person {

  Enemy() {
    //takes care of x, y, r, currentHP, and maxHP
    super();
    c = red;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y) {
    super(x, y);
    c = red;
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, int mHP, int cHP, int c) {
    super(x, y, r, mHP, cHP, c);
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Enemy(Enemy copyEnemy) {
    x = copyEnemy.x;
    y = copyEnemy.y;
    r = copyEnemy.r;

    currentHP = copyEnemy.currentHP;
    maxHP = copyEnemy.maxHP;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    if (mode == BATTLE) animate();
    super.show();
    println(spriteNumber);
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
  }//-------------------------------------------------- damage --------------------------------------------------
}//-------------------------------------------------- Enemy --------------------------------------------------
