void battle() {
  //general
  background(toDark(cyan));
  stroke(white);
  strokeWeight(5);
  line(width/2, height/2, width/2, height);
  line(0, height/2, width, height/2);
  line(0, height*3/4, width, height*3/4);

  //Hero
  Hero battleHero = new Hero(width/4, height/4, height/8, width/8);
  battleHero.show();


  //Buttons
  //top left
  battleButton(width/4, height*5/8, "normal attack");

  //top right
  battleButton(width*3/4, height*5/8, "risky attack");

  //bottom left
  battleButton(width/4, height*7/8, "charge up");

  //bottom right
  battleButton(width*3/4, height*7/8, "heal");
}//-------------------------------------------------- battle --------------------------------------------------

void battleMousePressed() {
  //mode = LOSE;
}//-------------------------------------------------- battleMousePressed --------------------------------------------------

void battleButton(float x, float y, String txt) {
  //tactile
  float left = x - width*7/32;
  float right = x + width*7/32;
  float top = y - height/16;
  float bottom = y + height/16;
  if (mouseX > left && mouseY > top && mouseX < right && mouseY < bottom) {
    fill (toLight(grey));
  } else {
    fill(white);
  }

  //button base
  stroke(black);
  rect(x, y, width*7/16, height/8, 10);

  //text
  fill(black);
  textSize(height/16);
  text(txt, x, y);
}//-------------------------------------------------- battleButton --------------------------------------------------
