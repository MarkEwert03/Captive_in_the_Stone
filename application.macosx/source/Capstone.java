import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Capstone extends PApplet {

//Mark Ewert
//Jan 10, 2020

public void setup() {
  //general
   //size(1920, 1080);

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
  imageY = height*1.5f;
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
  wall.resize(PApplet.parseInt(height*wallRatio), PApplet.parseInt(height*wallRatio));

  //map
  clearedRooms = new boolean[map.width][map.height];
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      int roomC = map.get(x, y);
      if (roomC == pink || roomC == violet) clearedRooms[x][y] = true;
    }
  }

  //default values are (3, 1) - before boss values are (5, 3)
  roomX = 3;
  roomY = 1;
  switchRoom();
}//-------------------------------------------------- setup --------------------------------------------------

public void draw() {
  //Mode FrameWork
  if      (mode == INTRO)  intro();
  else if (mode == GAME)   game();
  else if (mode == MENU)   menu();
  else if (mode == BATTLE) battle();
  else if (mode == LOSE)   lose();
  else if (mode == WIN)    win();
}//-------------------------------------------------- draw --------------------------------------------------

public void mousePressed() {
  if      (mode == INTRO)  introMousePressed();
  else if (mode == GAME)   gameMousePressed();
  else if (mode == MENU)   menuMousePressed();
  else if (mode == BATTLE) battleMousePressed();
  else if (mode == LOSE)   loseMousePressed();
  else if (mode == WIN)    winMousePressed();
}//-------------------------------------------------- mousePressed --------------------------------------------------

public void keyPressed() {
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

public void keyReleased() {
  if (key == 'a' || keyCode == LEFT)  leftKey = false;
  if (key == 'w' || keyCode == UP)    upKey = false;
  if (key == 'd' || keyCode == RIGHT) rightKey = false;
  if (key == 's' || keyCode == DOWN)  downKey = false;
}//-------------------------------------------------- keyReleased --------------------------------------------------

public int toLight(int c) {
  int returnC;
  if (c == darkGrey) return black;
  else if (saturation(c) == 0) returnC = color(0, 0, 75);
  else returnC = color(hue(c), 50, 100);
  return returnC;
}//-------------------------------------------------- toLight --------------------------------------------------

public int toDark(int c) {
  int returnC;
  if (c == darkGrey) return grey;
  else if (saturation(c) == 0) returnC = color(0, 0, 25);
  else returnC = color(hue(c), 100, 50);
  return returnC;
}//-------------------------------------------------- toDark --------------------------------------------------

public double goodRound (double value, int precision) {
  int scale = (int) Math.pow(10, precision);
  return (double) Math.round(value * scale) / scale;
}








//mode framework
final int INTRO  = 0;
final int GAME   = 1;
final int MENU   = 2;
final int BATTLE = 3;
final int LOSE   = 4;
final int WIN    = 5;
int mode = INTRO;

//Hero
Hero myHero;
String heroChoice = "";

//Enemy
ArrayList<Enemy> enemyList;
Enemy battleEnemy;

//keyboard
boolean leftKey, upKey, rightKey, downKey, spaceKey;


//images
PImage map, floor, wall;
PImage introText, loseText, bossText, winText;
float imageY;

//game
boolean[][] clearedRooms;
int roomX, roomY; //xy coordinates of map's pixels
int pRoomX, pRoomY; //previous xy coordinates of the map's pixels
boolean west, north, east, south; //indicates if each direction is avalible to go to for the next room
boolean wWall, nWall, eWall, sWall;
float wallRatio = 1.0f/8.0f;

//battle
final int HERO = 0;
final int ACTION = 1;
final int ENEMY = 2;
final int BATTLE_PACE = 90;
int turn = HERO;
int timer = 0;
boolean reverseOrder = false;

//other
boolean transition = false;
boolean bossTime = false;

//sound
Minim minim;
AudioPlayer introTheme;
AudioPlayer gameTheme;
AudioPlayer menuTheme;
AudioPlayer battleTheme;
AudioPlayer bossTheme;
AudioPlayer loseTheme;
AudioPlayer winTheme;

//colour pallete
final int red             = 0xffdf2020;
final int orange          = 0xffdf8020;
final int yellow          = 0xffdfdf20;
final int lime            = 0xff80df20;
final int green           = 0xff50df20;
final int mint            = 0xff20df50;
final int cyan            = 0xff20dfdf;
final int blue            = 0xff2080df;
final int navy            = 0xff2020df;
final int purple          = 0xff8020df;
final int violet          = 0xffdf20df;
final int pink            = 0xffdf2080;
final int white           = 0xffffffff;
final int grey            = 0xff808080;
final int darkGrey        = 0xff3f3f3f;
final int black           = 0xff000000;

//map colors
int hereColor;
int northColor;
int southColor;
int eastColor;
int westColor;
class Person {
  //basic
  float x, y;
  float r = height/12;
  int maxHP = 500;
  int currentHP = maxHP;
  int c = grey;

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
  final float[] powerLevels = new float[]{1, 1.1f, 1.3f, 1.6f, 2.0f, 2.5f, 3.0f};
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

  Person(float x, float y, float r, int mHP, int cHP, int c) {
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

  public void show() {
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

  public void animate() {
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

  private void healthBar(int c) {
    float HP_X = map(currentHP, 0, maxHP, 0, 1.6f*r);

    //inner health
    rectMode(CORNER);
    noStroke();
    fill(toLight(c));
    rect(x - r*0.8f, y - r*1.25f, 1.6f*r, r/2, 10);

    //healthbar  
    fill(c);
    rect(x - r*0.8f, y - r*1.25f, HP_X, r/2, 10);


    //outer shell
    rectMode(CENTER);
    noFill();
    if (mode == MENU) {
      stroke(toDark(pink));
      strokeWeight(2);
    }
    rect(x, y - r, 1.6f*r, r/2, 10);

    //text amount
    fill(toDark(c));
    textSize(r/4);
    text ("" + currentHP, x, y - r);
  }//-------------------------------------------------- healthBar --------------------------------------------------

  public void damage(int drop) { 
    currentHP -= drop;
    if (currentHP <= 0) {
      currentHP = 0;
    }
  }//-------------------------------------------------- healthBar --------------------------------------------------

  public void bulkImageImport(String name, String action, int total, boolean directional) {
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

  public void textFade() {
    textSize(height/20);
    fill(black, alpha);
    text(battleText, x, y*1.75f);
    if (alpha <= 0) {
      battleText = "";
      alpha = 255;
    } else alpha -= 10;
  }//-------------------------------------------------- textFade --------------------------------------------------
}//-------------------------------------------------- ~Person~ --------------------------------------------------
class Hero extends Person {
  //Hero variables
  final float speed = dist(0, 0, width, height)/150;
  boolean countering = false;

  Hero() {
    //super
    super();
    c = pink;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y, float r) {
    //super
    super(x, y, r);
    c = pink;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(float x, float y, float r, int mHP, int cHP, int c) {
    //super
    super(x, y, r, cHP, mHP, c);

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~manual constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    //super
    super(copyHero);
    x = width/2;
    y = height/2;
    r = height/4;

    //Hero
    countering = copyHero.countering;
    actionToDo = copyHero.actionToDo;

    //other
    allHeroConstructor();
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  private void allHeroConstructor() {
    //animation
    bulkImageImport("Hero", "Walk", 9, true);
    bulkImageImport("Hero", "Charge", 7, true);
    bulkImageImport("Hero", "Attack", 6, true);
    bulkImageImport("Hero", "Dead", 6, false);
    idle.add(walkDown.get(0));
    currentAction = idle;
  }//-------------------------------------------------- allHeroConstructor --------------------------------------------------

  public void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == HERO || turn == ACTION) {
        noTint();
      } else if (turn == ENEMY) {
        if (countering) tint(pink);
        else tint(toDark(grey));
      }
      fill(black);
      textSize(height/15);
      text(goodRound(powerLevels[progress], 1) + "x", x - 1.5f*r, y);
    }

    //basic
    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

  public void act() {
    if (hereColor == pink) currentHP = maxHP;

    //movement
    if (leftKey || upKey || rightKey || downKey) idle.clear();
    if (leftKey && !rightKey) {
      x -= speed;
      currentAction = walkLeft;
      idle.add(walkLeft.get(spriteNumber));
    }
    if (upKey && !downKey) {
      y -= speed;
      currentAction = walkUp;
      idle.add(walkUp.get(spriteNumber));
    }
    if (rightKey && !leftKey) {
      x += speed;
      currentAction = walkRight;
      idle.add(walkRight.get(spriteNumber));
    }
    if (downKey && !upKey) {
      y += speed;
      currentAction = walkDown;
      idle.add(walkDown.get(spriteNumber));
    }
    if (!leftKey && !upKey &&! rightKey && !downKey) {
      currentAction = idle;
    }

    //wall collision detection
    //use height instead of width so padding is consistant
    if (wWall && x - r*2/3 <= height * wallRatio) x = height * wallRatio + r*2/3;

    if (nWall && y - r*2/3 <= height * wallRatio) y = height * wallRatio + r*2/3;

    //use height instead of width so padding is consistant
    if (eWall && x + r*2/3 >= width - (height * wallRatio)) x = width - (height * wallRatio) - r*2/3;

    if (sWall && y + r >= height * (1 - wallRatio)) y = height * (1 - wallRatio) - r;

    //checks for paths
    if (west) checkWest();
    if (north) checkNorth();
    if (east) checkEast();
    if (south) checkSouth();
  }//-------------------------------------------------- act --------------------------------------------------

  public void checkWest() {
    if (west && x - r <= 0) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomX--;
      switchRoom();
      x = width * (1 - wallRatio);
    }
  }//-------------------------------------------------- checkWest --------------------------------------------------

  public void checkNorth() {
    if (north && y - r <= 0) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomY--;
      switchRoom();
      y = height * (1 - wallRatio);
    }
  }//-------------------------------------------------- checkNorth --------------------------------------------------

  public void checkEast() {
    if (east && x + r >= width) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomX++;
      switchRoom();
      x = width * wallRatio;
    }
  }//-------------------------------------------------- checkEast --------------------------------------------------

  public void checkSouth() {
    if (south && y + r >= height) {
      pRoomX = roomX;
      pRoomY = roomY;
      roomY++;
      switchRoom();
      y = height * wallRatio;
    }
  }//-------------------------------------------------- checkSouth --------------------------------------------------

  public void toBattle() {
    if (actionToDo.equals("poised strike") || actionToDo.equals("reckless slash")) {
      threshold = 5;
      //enemy moves to attack hero
      float dist = width/2 - r - battleEnemy.r;
      float speed = dist / (BATTLE_PACE/2);

      //hero starts to move towards enemy
      if (0 <= timer && timer < BATTLE_PACE/2) {
        x += speed;
        currentAction = walkRight;
      }   

      //after half time seconds the hero attacks
      if (timer == BATTLE_PACE/2) {
        currentAction = attackRight;
        animate();
        action();
      }

      //hero retreats back to starting position
      if (timer > BATTLE_PACE) {
        x -= speed;
        currentAction = walkRight;
      }
    } else {
      //invigorate or counter
      if (timer == 0) {
        myHero.threshold = BATTLE_PACE/15;
        if (actionToDo.equals("invigorate")) currentAction = chargeDown;
        else if (actionToDo.equals("counter")) currentAction = chargeRight;
        animate();
        action();
      }
    }

    //after full time it is Enemy's turn
    if (timer == BATTLE_PACE*1.5f) {
      currentAction = idle;
      if (reverseOrder) {
        turn = HERO;
        actionToDo = "";
        battleEnemy.actionToDo = "";
      } else turn = ENEMY;
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ACTION) timer++;
    else timer = -BATTLE_PACE/2;
  }//-------------------------------------------------- toBattle --------------------------------------------------

  public void action() {
    float rand;
    int crit, miss;

    if (actionToDo.equals("poised strike")) {
      crit = floor(random(15));
      miss = floor(random(20));
      if (!battleEnemy.anticipating) {
        if (crit == 0) battleEnemy.battleText = "crit!";
        if (miss == 0) {
          battleEnemy.battleText = "miss...";
        } else {
          rand = random(40, 60);
          if (crit == 0) battleEnemy.damage(PApplet.parseInt(2*rand*powerLevels[progress]));
          else battleEnemy.damage(PApplet.parseInt(rand*powerLevels[progress]));
        }
      } else {
        damage(PApplet.parseInt(powerLevels[battleEnemy.progress]*maxHP/10));
        battleEnemy.anticipating = false;
      }
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("reckless slash")) {
      crit = floor(random(2));
      miss = floor(random(4));
      if (!battleEnemy.anticipating) {
        if (crit == 0) battleEnemy.battleText = "crit!";
        if (miss == 0) {
          battleEnemy.battleText = "miss...";
        } else {
          rand = random(25, 100);
          if (crit == 0) battleEnemy.damage(PApplet.parseInt(2*rand*powerLevels[progress]));
          else battleEnemy.damage(PApplet.parseInt(rand*powerLevels[progress]));
        }
      } else {
        damage(PApplet.parseInt(powerLevels[battleEnemy.progress]*maxHP/10));
        battleEnemy.anticipating = false;
      }
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("invigorate")) {
      if (progress < 6) progress++;
      else battleText = "power level is maxed";
    } 
    //- - - - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("counter")) {
      countering = true;
    }
    //- - - - - - - - - - - - - - - - - - - - - -
    else {
      print("error! not a valid action");
    }
  }//-------------------------------------------------- action --------------------------------------------------

  public void resetCounter() {
    if (currentAction != dead) {
      spriteNumber = 0;
      spriteNumber = 0;
      threshold = 10;
      currentAction = dead;
    }
    if (countering) {
      if (spriteNumber >= 5) {
        damage(maxHP/10);
        spriteNumber = 0;
        count = 0;
        currentAction = idle;
        threshold = 5;
        countering = false;
      }
    }
  }//-------------------------------------------------- resetCounter --------------------------------------------------

}//-------------------------------------------------- Hero --------------------------------------------------
class Enemy extends Person {
  boolean anticipating = false;

  Enemy() {
    //super
    super();
    c = hereColor;

    //animation
    allEnemyConstructor();
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  //constructor(s)
  Enemy(float x, float y, int direction) {
    //super
    super(x, y, height/12);
    c = hereColor;

    //animation
    allEnemyConstructor();
    idle.clear();
    if (direction == 'w') idle.add(attackRight.get(4));
    else if (direction == 'n') idle.add(attackDown.get(4));
    else if (direction == 'e') idle.add(attackLeft.get(4));
    else if (direction == 's') idle.add(attackUp.get(4));
    else idle.add(dead.get(4));
  }//-------------------------------------------------- ~coordinate constructor~ --------------------------------------------------

  Enemy(float x, float y, float r, int c) {
    //super
    super(x, y, r);
    this.c = hereColor;

    //health
    if (c == yellow) maxHP = 150;
    else if (c == orange || c == green) maxHP = 300;
    else if (c == navy) maxHP = 150;
    else if (c == blue) maxHP = 200;
    else if (c == cyan) maxHP = 250;
    else if (c == darkGrey) maxHP = 600;
    else maxHP = 10;
    currentHP = maxHP;

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

  public void show() {
    //battle animation
    if (mode == BATTLE) {
      if (turn == ENEMY) {
        if (bossTime) tint(black, 64);
        else noTint();
      } else if (turn == HERO || turn == ACTION) {
        if (anticipating) tint(hereColor, 196);
        else tint(toDark(grey));
      }
      fill(black);
      textSize(height/15);
      text(goodRound(powerLevels[progress], 1) + "x", x + 1.5f*r, y);
    }

    animate();
    super.show();
  }//-------------------------------------------------- show --------------------------------------------------

  public void decideAction() {
    //0 = unruly stab
    //1 = barbaric thrust
    //2 = enrage
    //3 = anticipate
    int[] choices;
    int chosenAction;

    if (this.c == yellow) {
      chosenAction = 0;
    } else if (this.c == orange) {
      choices = new int[]{0, 1, 3, 3, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else if (this.c == green) {
      if (progress < 6) chosenAction = 2;
      else {
        choices = new int[]{0, 1};
        chosenAction = choices[floor(random(choices.length))];
      }
    } else if (this.c == navy) {
      choices = new int[]{0, 1, 1};
      chosenAction = choices[floor(random(choices.length))];
    } else if (this.c == blue) {
      choices = new int[]{0, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else if (this.c == cyan) {
      choices = new int[]{1, 2, 2, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else if (this.c == toDark(grey)) {
      choices = new int[]{0, 1, 2, 3};
      chosenAction = choices[floor(random(choices.length))];
    } else {
      chosenAction = 0;
    }

    if (chosenAction == 0) actionToDo = "unruly stab";
    else if (chosenAction == 1) actionToDo = "barbaric thrust";
    else if (chosenAction == 2) actionToDo = "enrage";
    else if (chosenAction == 3) actionToDo = "anticipate";
    else actionToDo = "error! not a valid action";
  }//-------------------------------------------------- decideAction --------------------------------------------------

  public void toBattle() {
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
        battleEnemy.threshold = BATTLE_PACE/15;
        if (actionToDo.equals("enrage")) currentAction = chargeDown;
        else if (actionToDo.equals("anticipate")) currentAction = chargeLeft;
        animate();
        action();
      }
    }

    //after full time it is Hero's turn
    if (timer == BATTLE_PACE*1.5f) {
      currentAction = idle;
      if (reverseOrder) turn = ACTION;
      else {
        turn = HERO;
        actionToDo = "";
        battleEnemy.actionToDo = "";
      }
    }

    //keep couting until enemy's turn is done and then reset timer
    if (turn == ENEMY) timer++;
    else timer = 0;
  }//-------------------------------------------------- toBattle --------------------------------------------------

  public void action() {
    float rand;
    int crit, miss;

    if (actionToDo.equals("unruly stab")) {
      crit = floor(random(20));
      miss = floor(random(15));
      if (!myHero.countering) {
        if (crit == 0) myHero.battleText = "crit...";
        if (miss == 0) {
          myHero.battleText = "miss!";
        } else {
          rand = random(40, 60);
          if (crit == 0) myHero.damage(PApplet.parseInt(2*rand*powerLevels[progress]));
          else myHero.damage(PApplet.parseInt(rand*powerLevels[progress]));
        }
      } else {
        damage(PApplet.parseInt(powerLevels[myHero.progress]*maxHP/10));
        myHero.countering = false;
      }
    }
    //- - - - - - - - - - - - - - - - - - - -
    else if (actionToDo.equals("barbaric thrust")) {
      crit = floor(random(6));
      miss = floor(random(4));
      if (!myHero.countering) {
        if (crit == 0) myHero.battleText = "crit...";
        if (miss == 0) myHero.battleText = "miss!";
        else {
          rand = random(25, 75);
          if (crit == 0) myHero.damage(PApplet.parseInt(2*rand*powerLevels[progress]));
          else myHero.damage(PApplet.parseInt(rand*powerLevels[progress]));
        }
      } else {
        damage(PApplet.parseInt(powerLevels[myHero.progress]*maxHP/10));
        myHero.countering = false;
      }
    }
    // - - - - - - - - - - - - - - - - - - - - 
    else if (actionToDo.equals("enrage")) {
      if (progress < 6) progress++;
      else battleText = "power level is maxed";
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

  public void resetCounter() {
    if (currentAction != dead) {
      spriteNumber = 0;
      spriteNumber = 0;
      threshold = 10;
      currentAction = dead;
    }
    if (anticipating) {
      if (spriteNumber >= 5) {
        damage(maxHP/10);
        spriteNumber = 0;
        count = 0;
        currentAction = idle;
        threshold = 5;
        anticipating = false;
      }
    }
  }//-------------------------------------------------- resetCounter --------------------------------------------------

  public float move(float edge, int sec) {
    float startX = x;

    float dist = abs( (width*3/4) - edge );
    float speed = dist/(sec*60);
    x -= speed;

    return startX;
  }//-------------------------------------------------- move --------------------------------------------------
}//-------------------------------------------------- Enemy --------------------------------------------------
public void intro() {
  //general
  background(toLight(red));
  image(introText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 0.5f;
  else imageY = height/2;
  
  introTheme.play();
}//-------------------------------------------------- intro --------------------------------------------------

public void introMousePressed() {
  if (imageY == height/2) {
    gameSetup();
    mode = GAME;
    introTheme.close();
    imageY = height*1.5f;
  }
}//-------------------------------------------------- introMousePressed --------------------------------------------------
public void gameSetup() {
  //Hero fields
  myHero.x = width/2;
  myHero.y = height/2;
  myHero.r = height/12;
  myHero.threshold = 5;

  //Hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkDown.get(0));
  myHero.currentAction = myHero.idle;

  //music
  gameTheme.rewind();
}

public void game() {
  //boss check
  if (roomX == 5 && roomY == 2) bossTime = true;
  
  //room
  drawRoom();

  //Hero
  myHero.show();
  myHero.act();

  //music
  if (gameTheme.position() == gameTheme.length()) gameTheme.rewind();
  gameTheme.play();

  //Enemy
  for (Enemy e : enemyList) {
    e.show();
    if (dist(myHero.x, myHero.y, e.x, e.y) < myHero.r + e.r) {
      gameTheme.pause();
      battleSetup();
      mode = BATTLE;
    }
  }
}//-------------------------------------------------- game --------------------------------------------------

public void gameMousePressed() {
}//-------------------------------------------------- gameMousePressed --------------------------------------------------

public void switchRoom() {
  //initialize all paths to be closed
  north = south = east = west = false;

  hereColor  = map.get(roomX, roomY);
  westColor  = map.get(roomX-1, roomY);
  northColor = map.get(roomX, roomY-1);
  eastColor  = map.get(roomX+1, roomY);
  southColor = map.get(roomX, roomY+1);

  //checks map for bording rooms based on adjacent pixel colours
  if (hereColor != white) {
    if (westColor  != white) west  = true;
    if (northColor != white) north = true;
    if (eastColor  != white) east  = true;
    if (southColor != white) south = true;
  } else {
    //bug checking
    println("In a nonexistent room so hereColor is" + hereColor);
    println("roomX = " + roomX + " and roomY = " + roomY);
  }

  //adding enemies
  enemyList.clear();
  if (clearedRooms[roomX][roomY] == false) {
    if (west && roomX != pRoomX+1)  enemyList.add(new Enemy(width * wallRatio, height*random(0.25f, 0.75f), 'w'));
    if (north && roomY != pRoomY+1) enemyList.add(new Enemy(width*random(0.25f, 0.75f), height * 2*wallRatio, 'n'));
    if (east && roomX != pRoomX-1)  enemyList.add(new Enemy(width * (1 - wallRatio), height*random(0.25f, 0.75f), 'e'));
    if (south && roomY != pRoomY-1) enemyList.add(new Enemy(width*random(0.25f, 0.75f), height * (1 - 2*wallRatio), 's'));

    if (roomX == 5 && roomY == 2) enemyList.add(new Enemy(width/2, height*2*wallRatio, width/10, hereColor));
  }
}//-------------------------------------------------- switchRoom --------------------------------------------------

public void drawRoom() {
  background(white);
  tint(hereColor);
  imageMode(CENTER);
  for (int w = 140; w < width*1.25f; w += 280) {
    for (int h = 140; h < height*1.25f; h += 280) {
      image(floor, w, h);
    }
  }

  imageMode(CORNER);
  for (int w = 0; w < width; w += wall.width/2) {
    for (int h = 0; h < height; h += wall.height/2) {
      if (w == 0 && wWall) image(wall, w, h);
      else if (h == 0 && nWall) image(wall, w, h);
      else if (w >= width - (height * wallRatio) && eWall) image(wall, width - wall.width, h);
      else if (h >= height * (1 - wallRatio) && sWall) image(wall, w, height - wall.height);
    }
  }

  //drawing the barriers
  noStroke();
  rectMode(CORNERS);

  boolean cleared = clearedRooms[roomX][roomY];
  //use height instead of width so padding is consistant

  //left wall
  if (!west) {
    fill(black, 192);
    rect(0, 0, height * wallRatio, height);
    wWall = true;
  } else if (!cleared && roomX != pRoomX+1 || roomX == 5) {
    fill(toDark(map.get(roomX-1, roomY)), 128);
    rect(0, 0, height * wallRatio, height);
    wWall = true;
  } else wWall = false;

  //top wall
  if (!north) {
    fill(black, 192);
    rect(0, 0, width, height * wallRatio);
    nWall = true;
  } else if (!cleared && roomY != pRoomY+1) {
    fill(toDark(map.get(roomX, roomY-1)), 128);
    rect(0, 0, width, height * wallRatio);
    nWall = true;
  } else nWall = false;

  //use height instead of width so padding is consistant
  //right wall
  if (!east) {
    fill(black, 192);
    rect(width - (height * wallRatio), 0, width, height);
    eWall = true;
  } else if (!cleared && roomX != pRoomX-1) {
    fill(toDark(map.get(roomX+1, roomY)), 128);
    rect(width - (height * wallRatio), 0, width, height);
    eWall = true;
  } else eWall = false;

  //bottom wall
  if (!south) {
    fill(black, 192);
    rect(0, height * (1 - wallRatio), width, height);
    sWall = true;
  } else if (!cleared && roomY != pRoomY-1) {
    fill(toDark(map.get(roomX, roomY+1)), 128);
    rect(0, height * (1 - wallRatio), width, height);
    sWall = true;
  } else sWall = false;

  //corner pieces
  fill(black);
  rect(0, 0, height*wallRatio, height*wallRatio);
  rect(width - (height * wallRatio), 0, width, height*wallRatio);
  rect(0, height * (1-wallRatio), height*wallRatio, height);
  rect(width - (height*wallRatio), height * (1-wallRatio), width, height);
  rectMode(CENTER);
}//-------------------------------------------------- drawRoom --------------------------------------------------

public void battleTransition() {
}//-------------------------------------------------- battletransition --------------------------------------------------
public void menu() {
  //general
  background(toDark(pink));
  
  Hero menuHero = new Hero(myHero);
  menuHero.show();  
}//-------------------------------------------------- menu --------------------------------------------------

public void menuMousePressed() {
}//-------------------------------------------------- menuMousePressed --------------------------------------------------
public void battleSetup() {
  //Hero
  myHero.x = width/4;
  myHero.y = height/3.75f;
  myHero.r = height/6;
  myHero.threshold = 5;

  //Enemy
  if (!bossTime) battleEnemy = new Enemy(width*3/4, height/3.75f, height/6, hereColor);
  else battleEnemy = new Enemy(width*3/4, height/3.6f, height/4.75f, hereColor);
  battleEnemy.threshold = 5;

  //hero animation
  myHero.idle.clear();
  myHero.idle.add(myHero.walkRight.get(0));
  myHero.currentAction = myHero.idle;

  //enemy animation
  battleEnemy.idle.clear();
  battleEnemy.idle.add(battleEnemy.walkLeft.get(0));
  battleEnemy.currentAction = battleEnemy.idle;

  //music
  battleTheme.rewind();
  bossTheme.rewind();

  //other
  timer = 0;
  turn = HERO;
  myHero.progress = 0;
  battleEnemy.progress = 0;
}//-------------------------------------------------- battleSetup --------------------------------------------------

public void battle() {
  battleUI();

  if (turn == HERO) {
    //other
    reverseOrder = false;

    //reset counter
    if (myHero.countering) myHero.resetCounter();
    else myHero.threshold = BATTLE_PACE/20;

    //reset anticipate
    if (battleEnemy.anticipating) battleEnemy.resetCounter();
    else battleEnemy.threshold = BATTLE_PACE/20;
  }

  //Hero
  myHero.show();
  if (!myHero.battleText.isEmpty()) myHero.textFade();
  if (turn == ACTION) {
    myHero.toBattle();
  }

  //Enemy
  battleEnemy.show();
  if (battleEnemy.actionToDo.isEmpty()) battleEnemy.decideAction();
  if (!battleEnemy.battleText.isEmpty()) battleEnemy.textFade();
  if (turn == ENEMY) {
    battleEnemy.toBattle();
  }

  if (turn != ACTION && battleEnemy.currentHP <= 0) {
    if (bossTime) {
      battleTheme.close();
      bossTheme.close();
      mode = WIN;
    } else {
      clearedRooms[roomX][roomY] = true;
      gameSetup();
      switchRoom();
      battleTheme.pause();
      mode = GAME;
    }
  }

  if (turn == HERO && myHero.currentHP <= 0) {
    battleTheme.close();
    bossTheme.close();
    mode = LOSE;
  }

  //music
  if (bossTime) {
    if (bossTheme.position() >= bossTheme.length() || !bossTheme.isPlaying()) bossTheme.rewind();
    if (mode == BATTLE) bossTheme.play();
  } else {
    if (battleTheme.position() >= battleTheme.length() || !battleTheme.isPlaying()) battleTheme.rewind();
    if (mode == BATTLE) battleTheme.play();
  }
}//-------------------------------------------------- battle --------------------------------------------------

public void battleMousePressed() {
  if (turn == HERO && !heroChoice.isEmpty()) {
    timer = -BATTLE_PACE/2;
    if (battleEnemy.actionToDo.equals("anticipate") && !heroChoice.equals("counter")) {
      reverseOrder = true;
      turn = ENEMY;
    } else turn = ACTION;
    myHero.actionToDo = heroChoice;
  }
}//-------------------------------------------------- battleMousePressed --------------------------------------------------

public void battleUI() {
  //General
  background(toDark(hereColor));
  if (turn == HERO && !(myHero.countering || battleEnemy.anticipating)) {
    stroke(white);
    strokeWeight(5);
    line(width/2, height/2, width/2, height);
    line(0, height/2, width, height/2);
    line(0, height*3/4, width, height*3/4);

    //Buttons
    //top left
    battleButton(width/4, height*5/8, "poised strike");

    //top right
    battleButton(width*3/4, height*5/8, "reckless slash");

    //bottom left
    battleButton(width/4, height*7/8, "invigorate");

    //bottom right
    battleButton(width*3/4, height*7/8, "counter");
  } else {
    noStroke();
    fill(hereColor);
    rectMode(CORNER);
    rect(0, height/2, width, height/2);
    fill(black);
    textSize(width/20);
    if (turn == ACTION) text("Hero uses " + myHero.actionToDo + "!", width/2, height*3/4);
    else if (turn == ENEMY) text("Opposing enemy uses " + battleEnemy.actionToDo, width/2, height*3/4);
  }
}//-------------------------------------------------- battleUI --------------------------------------------------

public void battleButton(float x, float y, String txt) {
  rectMode(CENTER);
  //tactile
  float left = x - width*7/32;
  float right = x + width*7/32;
  float top = y - height/16;
  float bottom = y + height/16;
  if (mouseX > left && mouseY > top && mouseX < right && mouseY < bottom) {
    fill (toLight(hereColor));
    heroChoice = txt;
  } else {
    fill(white);
    if (txt.equals("normal attack")) heroChoice = "";
  }

  //button base
  if (bossTime) stroke(grey);
  else stroke(black);
  rect(x, y, width*7/16, height/8, 10);

  //text
  if (turn == HERO) {
    if (bossTime) fill(grey);
    else fill(black);
  } else {
    fill(grey);
  }
  textSize(height/16);
  text(txt, x, y);
}//-------------------------------------------------- battleButton --------------------------------------------------
public void lose() {
  //general
  background(toDark(hereColor));
  noTint();
  if (bossTime) image(bossText, width/2, imageY);
  else image(loseText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 0.5f;
  else imageY = height/2;
  
  loseTheme.play();
}//-------------------------------------------------- lose --------------------------------------------------

public void loseMousePressed() {
}//-------------------------------------------------- loseMousePressed --------------------------------------------------
public void win() {
  //general
  background(toLight(yellow));
  noTint();
  image(winText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 0.5f;
  else imageY = height/2;

  winTheme.play();
}//-------------------------------------------------- win --------------------------------------------------

public void winMousePressed() {
}//-------------------------------------------------- winMousePressed --------------------------------------------------
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Capstone" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
