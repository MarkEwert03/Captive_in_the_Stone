void menu() {
  //general
  background(toDark(green));
  fill(white);
  textSize(256);
  text("menu", width/2, height/2);
}//-------------------------------------------------- menu --------------------------------------------------

void menuMousePressed() {
  mode = BATTLE;
}//-------------------------------------------------- menuMousePressed --------------------------------------------------
