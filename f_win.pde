void win() {
  //general
  background(toDark(violet));
  fill(white);
  textSize(256);
  text("win", width/2, height/2);
}//-------------------------------------------------- win --------------------------------------------------

void winMousePressed() {
  mode = INTRO;
}//-------------------------------------------------- winMousePressed --------------------------------------------------
