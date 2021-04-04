class Person {
  //basic
  float x, y, r;
  int maxHP, currentHP;
  color c;

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
  ArrayList<PImage> dead          = new ArrayList<PImage>();
  ArrayList<PImage> currentAction = new ArrayList<PImage>();

  //animation
  int count = 0;
  int spriteNumber = 0; //Current sprite shown
  final int threshold = 10; //How many frames until you change spriteNumber

  Person() {
    //basic
    x = width/2;
    y = height/2;
    r = (width*height)/40000;
    maxHP = 100;
    currentHP = maxHP;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Person(float x, float y) {
    //basic
    this.x = x;
    this.y = y;
    this.r = (width*height)/40000;
    this.maxHP = 100;
    this.currentHP = maxHP;
    this.c = grey;
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
    //image that is actually showing
    image(currentAction.get(spriteNumber), x, y, 2*r, 2*r);

    //HP bar
    if (mode == BATTLE || mode == MENU) healthBar(c);
  }//-------------------------------------------------- show --------------------------------------------------

  void animate() {
    //animating sprite
    //continue conting until count equals threshold (5) and then go to next sprite
    count++; 
    if (count == threshold) {
      count = 0;
      spriteNumber++;
    }

    //if we get to the last sprite, go back to the beginning
    if (currentAction.size() <= spriteNumber) {
      spriteNumber = 0;
    }
  }//-------------------------------------------------- animate --------------------------------------------------

  private void healthBar(color c) {
    float HP_X = map(currentHP, 0, maxHP, 0, 2*r);

    //inner health
    rectMode(CORNER);
    noStroke();
    fill(toLight(c));
    rect(x - r, y - r*1.75, HP_X, r/2);

    //outer shell
    rectMode(CENTER);
    stroke(2);
    noFill();
    rect(x, y - r*1.5, 2*r, r/2);

    //text amount
    fill(toDark(c));
    textSize(r/4);
    text ("" + currentHP, x, y - r*1.5);
  }//-------------------------------------------------- healthBar --------------------------------------------------

  void damage(int drop) { 
    currentHP -= drop;
  }//-------------------------------------------------- healthBar --------------------------------------------------

  void bulkImageImport(String name, String action, int total, boolean directional) {
    //determining which list to add to
    ArrayList<PImage> tempLeft  = new ArrayList<PImage>();
    ArrayList<PImage> tempUp    = new ArrayList<PImage>();
    ArrayList<PImage> tempRight = new ArrayList<PImage>();
    ArrayList<PImage> tempDown  = new ArrayList<PImage>();
    if (action.equals("Walk")) {
      tempLeft = walkLeft;
      tempUp = walkUp;
      tempRight = walkRight;
      tempDown = walkDown;
    } else if (action.equals("Attack")) {
      tempLeft = attackLeft;
      tempUp = attackUp;
      tempRight = attackRight;
      tempDown = attackDown;
    }


    String direction = "";
    for (int dir = 0; dir < 4; dir++) {
      //outer directional loop
      if (dir == 0) direction = "Left ";
      else if (dir == 1) direction = "Up ";
      else if (dir == 2) direction = "Right ";
      else if (dir == 3) direction = "Down ";

      //inner numerical loop
      for (int num = 1; num <= total; num++) {
        if (directional) {
          PImage image = loadImage("Animation/" + name + "/" + direction + action + " (" + num + ").png");
          if (dir == 0) tempLeft.add(image);
          else if (dir == 1) tempUp.add(image);
          else if (dir == 2) tempRight.add(image);
          else if (dir == 3) tempDown.add(image);
        } else {
          PImage image = loadImage("Animation/" + name + "/" + action + " (" + num + ").png");
          dead.add(image);
        }
      }
    }
  }//-------------------------------------------------- bulkImageImport --------------------------------------------------
}//-------------------------------------------------- ~Person~ --------------------------------------------------
