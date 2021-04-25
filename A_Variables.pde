import java.util.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

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

//intro
PImage introText;
float imageY;

//images
PImage map, floor, wall;

//game
boolean[][] clearedRooms;
int roomX, roomY; //xy coordinates of map's pixels
int pRoomX, pRoomY; //previous xy coordinates of the map's pixels
boolean west, north, east, south; //indicates if each direction is avalible to go to for the next room
boolean wWall, nWall, eWall, sWall;
float wallRatio = 1.0/8.0;

//battle
final int HERO = 0;
final int ACTION = 1;
final int ENEMY = 2;
final int BATTLE_PACE = 120;
int turn = HERO;
int timer = 0;
boolean reverseOrder = false;

//other
boolean transition = false;

//sound
Minim minim;
AudioPlayer introTheme;
AudioPlayer gameTheme;
AudioPlayer menuTheme;
AudioPlayer battleTheme;
AudioPlayer loseTheme;
AudioPlayer winTheme;

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
final color darkGrey        = #3f3f3f;
final color black           = #000000;

//map colors
color hereColor;
color northColor;
color southColor;
color eastColor;
color westColor;
