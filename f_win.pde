void win() {
  //general
  background(toDark(violet));
  fill(white);
  textSize(256);
  text("win", width/2, height/2);
  
  //music
  winTheme.play();
}//-------------------------------------------------- win --------------------------------------------------

void winMousePressed() {
  
}//-------------------------------------------------- winMousePressed --------------------------------------------------
