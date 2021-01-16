void game() {
  //general
  background(darkYellow);
  
  //Hero
  myHero.show();
  myHero.act();
}//-------------------------------------------------- game --------------------------------------------------

void gameMousePressed() {
  mode = MENU;
}//-------------------------------------------------- gameMousePressed --------------------------------------------------
