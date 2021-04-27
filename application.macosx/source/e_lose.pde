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
}//-------------------------------------------------- loseMousePressed --------------------------------------------------
