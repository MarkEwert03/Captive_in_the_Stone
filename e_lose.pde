void lose() {
  //general
  background(toDark(navy));
  fill(white);
  textSize(256);
  text("lose", width/2, height/2);
  
  //music
  loseTheme.play();
}//-------------------------------------------------- lose --------------------------------------------------

void loseMousePressed() {
}//-------------------------------------------------- loseMousePressed --------------------------------------------------
