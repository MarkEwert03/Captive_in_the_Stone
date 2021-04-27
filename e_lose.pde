void lose() {
  //general
  background(toDark(hereColor));
  noTint();
  if (bossTime) image(bossText, width/2, imageY);
  else image(loseText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 0.5;
  else imageY = height/2;

  loseTheme.play();
}//-------------------------------------------------- lose --------------------------------------------------

void loseMousePressed() {
  loseTheme.pause();
  setup();
  if (checkPoint) {
    roomX = 4;
    roomY = 6;
  } else {
    roomX = 3;
    roomY = 1;
  }
  mode = GAME;
  switchRoom();
  gameSetup();
}//-------------------------------------------------- loseMousePressed --------------------------------------------------
