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

  //Hero
  myHero = new Hero(width/2, height/2, width/12);

  //Enemy
  enemyList = new ArrayList<Enemy>();

  //sound
  minim       = new Minim(this);
  introTheme  = minim.loadFile("Music/Intro Theme.wav");
  gameTheme   = minim.loadFile("Music/Game Theme.mp3"); 
  battleTheme = minim.loadFile("Music/Battle Theme.mp3");
  battleTheme.setGain(-20);
  bossTheme = minim.loadFile("Music/Boss Theme.mp3");
  bossTheme.setGain(-20);
  loseTheme   = minim.loadFile("Music/Lose Theme.mp3");
  loseTheme.setGain(-10);
  winTheme    = minim.loadFile("Music/Win Theme.mp3");

  //text images
  imageMode(CENTER);
  imageY = height*1.5;
  introText = loadImage("Images/Intro Text.png");
  introText.resize(width, height);
  loseText  = loadImage("Images/Lose Text.png");
  loseText.resize(width, height);
  bossText  = loadImage("Images/Boss Text.png");
  bossText.resize(width, height);
  winText   = loadImage("Images/Win Text.png");
  winText.resize(width, height);

  //other images
  map       = loadImage("Images/Map.png");
  floor     = loadImage("Images/Stone.png");
  wall      = loadImage("Images/Brick.png");
  wall.resize(int(height*wallRatio), int(height*wallRatio));

  //map
  clearedRooms = new boolean[map.width][map.height];
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color roomC = map.get(x, y);
      if (roomC == pink || roomC == violet) clearedRooms[x][y] = true;
    }
  }

  //other variables
  heroChoice = "";
  reverseOrder = false;
  transition = false;
  bossTime = false;

  //default values are (3, 1) - before boss values are (5, 3)
  roomX = 3;
  roomY = 1;
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
    if (mode == GAME) {
      gameTheme.setGain(-20);
      mode = MENU;
    } else if (mode == MENU) {
      gameTheme.setGain(0);
      mode = GAME;
    }
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
  if (c == darkGrey) return black;
  else if (saturation(c) == 0) returnC = color(0, 0, 75);
  else returnC = color(hue(c), 50, 100);
  return returnC;
}//-------------------------------------------------- toLight --------------------------------------------------

color toDark(color c) {
  color returnC;
  if (c == darkGrey) return grey;
  else if (saturation(c) == 0) returnC = color(0, 0, 25);
  else returnC = color(hue(c), 100, 50);
  return returnC;
}//-------------------------------------------------- toDark --------------------------------------------------

double goodRound (double value, int precision) {
  int scale = (int) Math.pow(10, precision);
  return (double) Math.round(value * scale) / scale;
}
