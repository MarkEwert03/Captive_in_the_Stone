void win() {
  //general
  background(toLight(yellow));
  noTint();
  image(winText, width/2, imageY);
  //good speed is 0.5 pixels/second
  if (imageY > height/2) imageY -= 0.5;
  else imageY = height/2;

  winTheme.play();
}//-------------------------------------------------- win --------------------------------------------------

void winMousePressed() {
}//-------------------------------------------------- winMousePressed --------------------------------------------------
