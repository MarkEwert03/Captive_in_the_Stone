class Enemy extends Person {

  Enemy() {
    //super
    super();
    c = red;

    //Animation
    idle.add     (loadImage("Animation/Down 1.png"));
    walkUp.add   (loadImage("Animation/Up 1.png"));
    walkUp.add   (loadImage("Animation/Up 2.png"));
    walkDown.add (loadImage("Animation/Down 1.png"));
    walkDown.add (loadImage("Animation/Down 2.png"));
    walkRight.add(loadImage("Animation/Right 1.png"));
    walkRight.add(loadImage("Animation/Right 2.png"));
    walkLeft.add (loadImage("Animation/Left 1.png"));
    walkLeft.add (loadImage("Animation/Left 2.png"));
    currentAction = idle;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y) {
    //super
    super(x, y);
    c = red;

    //Animation
    idle.add     (loadImage("Animation/Down 1.png"));
    walkUp.add   (loadImage("Animation/Up 1.png"));
    walkUp.add   (loadImage("Animation/Up 2.png"));
    walkDown.add (loadImage("Animation/Down 1.png"));
    walkDown.add (loadImage("Animation/Down 2.png"));
    walkRight.add(loadImage("Animation/Right 1.png"));
    walkRight.add(loadImage("Animation/Right 2.png"));
    walkLeft.add (loadImage("Animation/Left 1.png"));
    walkLeft.add (loadImage("Animation/Left 2.png"));
    currentAction = idle;
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, mHP, cHP, c);
    c = red;

    //Animation
    idle.add     (loadImage("Animation/Down 1.png"));
    walkUp.add   (loadImage("Animation/Up 1.png"));
    walkUp.add   (loadImage("Animation/Up 2.png"));
    walkDown.add (loadImage("Animation/Down 1.png"));
    walkDown.add (loadImage("Animation/Down 2.png"));
    walkRight.add(loadImage("Animation/Right 1.png"));
    walkRight.add(loadImage("Animation/Right 2.png"));
    walkLeft.add (loadImage("Animation/Left 1.png"));
    walkLeft.add (loadImage("Animation/Left 2.png"));
    currentAction = idle;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Enemy(Enemy copyEnemy) {
    //super
    super(copyEnemy);
    c = red;

    //Animation
    idle.add     (loadImage("Animation/Down 1.png"));
    walkUp.add   (loadImage("Animation/Up 1.png"));
    walkUp.add   (loadImage("Animation/Up 2.png"));
    walkDown.add (loadImage("Animation/Down 1.png"));
    walkDown.add (loadImage("Animation/Down 2.png"));
    walkRight.add(loadImage("Animation/Right 1.png"));
    walkRight.add(loadImage("Animation/Right 2.png"));
    walkLeft.add (loadImage("Animation/Left 1.png"));
    walkLeft.add (loadImage("Animation/Left 2.png"));
    currentAction = idle;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    if (mode == BATTLE) animate();
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
