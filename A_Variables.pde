//mode framework
final int INTRO  = 0;
final int GAME   = 1;
final int MENU   = 2;
final int BATTLE = 3;
final int LOSE   = 4;
final int WIN    = 5;
int mode = INTRO;

//Hero
Hero myHero, battleHero;
String heroChoice = "";

//Enemy
ArrayList<Enemy> enemyList;
Enemy battleEnemy;

//keyboard
boolean leftKey, upKey, rightKey, downKey, spaceKey;

//map
PImage map; 
int roomX, roomY; //xy coordinates of map's pixels
boolean west, north, east, south; //indicates if each direction is avalible to go to for the next room
float wallRatio = 1.0/8;

//battle
final int HERO = 0;
final int ACTION = 1;
final int ENEMY = 2;
final int BATTLE_PACE = 120;
int turn = HERO;
int timer = 0;

//other
boolean transition = false;

//colour pallete
final color red             = #df2020;
final color orange          = #df8020;
final color yellow          = #dfdf20;
final color lime            = #80df20;
final color green           = #50df20;
final color mint            = #20df50;
final color cyan            = #20dfdf;
final color blue            = #2080df;
final color navy            = #2020df;
final color purple          = #8020df;
final color violet          = #df20df;
final color pink            = #df2080;
final color white           = #ffffff;
final color grey            = #808080;
final color black           = #000000;

//map colors
color hereColor;
color northColor;
color southColor;
color eastColor;
color westColor;
