class Enemy {
  //instance variables
  float x, y, r, speed;
  int currentHP, maxHP;

  //constructor(s)
  Enemy() {
    //basic
    x = width*3/4;
    y = height/4;
    r = (width*height)/60000;
    speed = sqrt(sq(width) + sq(height))/400;

    maxHP = 100;
    currentHP = maxHP;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, float speed, int cHP, int mHP) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.speed = speed;

    this.currentHP = cHP;
    this.maxHP = mHP;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  Enemy(Enemy copyEnemy) {
    x = copyEnemy.x;
    y = copyEnemy.y;
    r = copyEnemy.r;
    speed = copyEnemy.speed;

    currentHP = copyEnemy.currentHP;
    maxHP = copyEnemy.maxHP;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    //image
    noStroke();
    if (turn == ENEMY) fill(red);
    else if (turn == HERO) fill(toDark(red));
    ellipse(x, y, 2*r, 2*r);

    //HP bar
    if (mode == BATTLE || mode == MENU) healthBar();
  }//-------------------------------------------------- show --------------------------------------------------

  void act() {
  }//-------------------------------------------------- show --------------------------------------------------

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

  void damage(int drop) { 
    if (currentHP - drop <= 0) {
      gameSetup();
      mode = GAME;
    } else currentHP -= drop;
  }//-------------------------------------------------- damage --------------------------------------------------
  
  float move(float edge, int sec){
    float startX = x;
    
    float dist = abs( (width*3/4) - edge );
    float speed = dist/(sec*60);
    println(x, edge, dist, speed);
    x -= speed;
    
    return startX;
  }//-------------------------------------------------- damage --------------------------------------------------
}//-------------------------------------------------- Enemy --------------------------------------------------
