void intro() {
  //general
  background(toLight(red));
  image(introText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 25;
  else imageY = height/2;
  
  introTheme.play();
}//-------------------------------------------------- intro --------------------------------------------------

void introMousePressed() {
  if (imageY == height/2) {
    gameSetup();
    mode = GAME;
    introTheme.close();
  }
}//-------------------------------------------------- introMousePressed --------------------------------------------------
