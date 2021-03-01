void intro() {
  //general
  background(toDark(red));
  fill(white);
  textSize(256);
  text("title", width/2, height/2);
}//-------------------------------------------------- intro --------------------------------------------------

void introMousePressed() {
  mode = GAME;
}//-------------------------------------------------- introMousePressed --------------------------------------------------
