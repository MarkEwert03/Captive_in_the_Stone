 //Mark Ewert
//Jan 10, 2020

void setup() {
  //general
  fullScreen(); //size(1920, 1080);

  //shapes
  noStroke();
  colorMode(HSB, 360, 100, 100);
  rectMode(CENTER);

  //text
  textSize(24);
  textAlign(CENTER, CENTER);

  //image
  imageMode(CENTER);
  map = loadImage("Map.png");

  roomX = 1;
  roomY = 1;
  switchRoom();

  //Hero
  myHero = new Hero();
  idle      = new ArrayList<PImage>();
  walkUp    = new ArrayList<PImage>();
  walkDown  = new ArrayList<PImage>();
  walkRight = new ArrayList<PImage>();
  walkLeft  = new ArrayList<PImage>();
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

  //Enemy
  enemyList = new ArrayList<Enemy>();
}//-------------------------------------------------- setup --------------------------------------------------

void draw() {
  //Mode FrameWork
  if      (mode == INTRO)  intro();
  else if (mode == GAME)   game();
  else if (mode == MENU)   menu();
  else if (mode == BATTLE) battle();
  else if (mode == LOSE)   lose();
  else if (mode == WIN)    win();
}//-------------------------------------------------- draw --------------------------------------------------

void mousePressed() {
  if      (mode == INTRO)  introMousePressed();
  else if (mode == GAME)   gameMousePressed();
  else if (mode == MENU)   menuMousePressed();
  else if (mode == BATTLE) battleMousePressed();
  else if (mode == LOSE)   loseMousePressed();
  else if (mode == WIN)    winMousePressed();
}//-------------------------------------------------- mousePressed --------------------------------------------------

void keyPressed() {
  if (key == 'a' || keyCode == LEFT)  leftKey = true;
  if (key == 'w' || keyCode == UP)    upKey = true;
  if (key == 'd' || keyCode == RIGHT) rightKey = true;
  if (key == 's' || keyCode == DOWN)  downKey = true;
  if (key == ' ') {
  }
}//-------------------------------------------------- keyPressed --------------------------------------------------

void keyReleased() {
  if (key == 'a' || keyCode == LEFT)  leftKey = false;
  if (key == 'w' || keyCode == UP)    upKey = false;
  if (key == 'd' || keyCode == RIGHT) rightKey = false;
  if (key == 's' || keyCode == DOWN)  downKey = false;
}//-------------------------------------------------- keyReleased --------------------------------------------------

color toLight(color c) {
  color returnC;
  if (saturation(c) == 0) returnC = color(0, 0, 75);
  else returnC = color(hue(c), 50, 100);
  return returnC;
}//-------------------------------------------------- toLight --------------------------------------------------

color toDark(color c) {
  color returnC;
  if (saturation(c) == 0) returnC = color(0, 0, 25);
  else returnC = color(hue(c), 100, 50);
  return returnC;
}//-------------------------------------------------- toDark --------------------------------------------------
