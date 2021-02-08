//Mark Ewert
//Jan 10, 2020

void setup() {
  //general
  fullScreen(); //size(1920, 1080);

  //shapes
  noStroke();
  colorMode(HSB);
  rectMode(CENTER);

  //text
  textSize(24);
  textAlign(CENTER, CENTER);

  //image
  imageMode(CENTER);
  map = loadImage("Images/Map.png");

  //Hero
  myHero = new Hero();

  //map - correct values are: roomX = 4, roomY = 7
  roomX = 4;
  roomY = 7;
  switchRoom();
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
