class Person {
  //basic
  float x, y;
  float r = height/12;
  int maxHP = 500;
  int currentHP = maxHP;
  color c = grey;

  //images
  ArrayList<PImage> idle          = new ArrayList<PImage>();
  ArrayList<PImage> walkLeft      = new ArrayList<PImage>();
  ArrayList<PImage> walkUp        = new ArrayList<PImage>();
  ArrayList<PImage> walkRight     = new ArrayList<PImage>();
  ArrayList<PImage> walkDown      = new ArrayList<PImage>();
  ArrayList<PImage> attackLeft    = new ArrayList<PImage>();
  ArrayList<PImage> attackUp      = new ArrayList<PImage>();
  ArrayList<PImage> attackRight   = new ArrayList<PImage>();
  ArrayList<PImage> attackDown    = new ArrayList<PImage>();
  ArrayList<PImage> chargeLeft    = new ArrayList<PImage>();
  ArrayList<PImage> chargeUp      = new ArrayList<PImage>();
  ArrayList<PImage> chargeRight   = new ArrayList<PImage>();
  ArrayList<PImage> chargeDown    = new ArrayList<PImage>();
  ArrayList<PImage> dead          = new ArrayList<PImage>();
  ArrayList<PImage> currentAction = new ArrayList<PImage>();

  //animation
  int count = 0;
  int spriteNumber = 0; //Current sprite shown
  int threshold = 10; //How many frames until you change spriteNumber

  //battle
  String actionToDo = "";
  String battleText = "";
  float alpha = 255;
  final float[] powerLevels = new float[]{1, 1.1, 1.3, 1.6, 2.0, 2.5, 3.0};
  int progress = 0;

  Person() {
    //basic
    x = width/2;
    y = height/2;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Person(float x, float y, float r) {
    //basic
    this.x = x;
    this.y = y;
    this.r = r;
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Person(float x, float y, float r, int mHP, int cHP, color c) {
    //basic
    this.x = x;
    this.y = y;
    this.r = r;
    this.maxHP = mHP;
    this.currentHP = cHP;
    this.c = c;
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Person(Person copyPerson) {
    x = copyPerson.x;
    y = copyPerson.y;
    r = copyPerson.r;
    maxHP = copyPerson.maxHP;
    currentHP = copyPerson.currentHP;
    c = copyPerson.c;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  void show() {
    if (mode == GAME || mode == MENU) {
      noTint();
      if (this instanceof Enemy && bossTime) tint(grey, 128);
    }

    //actual image showing
    imageMode(CENTER);
    image(currentAction.get(spriteNumber), x, y, 2*r, 2*r);

    //HP bar
    if (mode == BATTLE || mode == MENU) healthBar(c);
  }//-------------------------------------------------- show --------------------------------------------------

  void animate() {
    //animating sprite
    //continue conting until count equals threshold and then go to next sprite
    count++; 
    if (count >= threshold) {
      count = 0;
      spriteNumber++;
    }

    //if we get to the last sprite, go back to the beginning
    if (currentAction.size() <= spriteNumber) {
      spriteNumber = 0;
    }
  }//-------------------------------------------------- animate --------------------------------------------------

  private void healthBar(color c) {
    float HP_X = map(currentHP, 0, maxHP, 0, 1.6*r);

    //inner health
    rectMode(CORNER);
    noStroke();
    fill(toLight(c));
    rect(x - r*0.8, y - r*1.25, 1.6*r, r/2, 10);

    //healthbar  
    fill(c);
    rect(x - r*0.8, y - r*1.25, HP_X, r/2, 10);


    //outer shell
    rectMode(CENTER);
    noFill();
    if (mode == MENU) {
      stroke(toDark(pink));
      strokeWeight(2);
    }
    rect(x, y - r, 1.6*r, r/2, 10);

    //text amount
    fill(toDark(c));
    textSize(r/4);
    text ("" + currentHP, x, y - r);
  }//-------------------------------------------------- healthBar --------------------------------------------------

  void damage(int drop) { 
    currentHP -= drop;
    if (currentHP <= 0) {
      currentHP = 0;
    }
  }//-------------------------------------------------- healthBar --------------------------------------------------

  void bulkImageImport(String name, String action, int total, boolean directional) {
    //determining which list to add to
    ArrayList<PImage> tempLeft  = new ArrayList<PImage>();
    ArrayList<PImage> tempUp    = new ArrayList<PImage>();
    ArrayList<PImage> tempRight = new ArrayList<PImage>();
    ArrayList<PImage> tempDown  = new ArrayList<PImage>();
    if (action.equals("Walk")) {
      tempLeft  = walkLeft;
      tempUp    = walkUp;
      tempRight = walkRight;
      tempDown  = walkDown;
    } else if (action.equals("Attack")) {
      tempLeft  = attackLeft;
      tempUp    = attackUp;
      tempRight = attackRight;
      tempDown  = attackDown;
    } else if (action.equals("Charge")) {
      tempLeft  = chargeLeft;
      tempUp    = chargeUp;
      tempRight = chargeRight;
      tempDown  = chargeDown;
    }

    if (directional) {
      String direction = "";
      for (int dir = 0; dir < 4; dir++) {
        //outer directional loop
        if (dir == 0) direction = "Left ";
        else if (dir == 1) direction = "Up ";
        else if (dir == 2) direction = "Right ";
        else if (dir == 3) direction = "Down ";

        //inner numerical loop
        for (int num = 1; num <= total; num++) {
          PImage image = loadImage("Animation/" + name + "/" + direction + action + " (" + num + ").png");
          if (dir == 0) tempLeft.add(image);
          else if (dir == 1) tempUp.add(image);
          else if (dir == 2) tempRight.add(image);
          else if (dir == 3) tempDown.add(image);
        }
      }
    } else {
      for (int num = 1; num <= total; num++) {
        if (action.equals("Dead")) {
          PImage image = loadImage("Animation/" + name + "/" + action + " (" + num + ").png");
          dead.add(image);
        } else if (action.equals("Slide")) {
          PImage slide = loadImage("Transition/Slide (" + num + ").png");
          slide.resize(width, height);
          slides.add(slide);
        } else {
          println("Error: action was " + action);
        }
      }
    }
  }//-------------------------------------------------- bulkImageImport --------------------------------------------------

  void textFade() {
    textSize(height/20);
    fill(black, alpha);
    text(battleText, x, y*1.75);
    if (alpha <= 0) {
      battleText = "";
      alpha = 255;
    } else alpha -= 10;
  }//-------------------------------------------------- textFade --------------------------------------------------
}//-------------------------------------------------- ~Person~ --------------------------------------------------
