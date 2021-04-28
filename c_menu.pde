void menu() {
  //general
  background(toDark(pink));
  
  Hero menuHero = new Hero(myHero);
  menuHero.show();
  
  //minimap
  image(bigMap, width*3/4, height/2);
  
  //player icon
  float bigMapX = map(roomX, 0, 6, width*3/4-(bigMap.width/2), width*3/4+(bigMap.width/2)-(bigMap.width/7)) + bigMap.width/14;
  float bigMapY = map(roomY, 0, 7, height/2-(bigMap.height/2), height/2+(bigMap.height/2)-(bigMap.height/8)) + bigMap.height/16;
  float alpha = 127 + 127*sin(millis()*2.0*PI/2000.0);
  rectMode(CENTER);
  fill(white, alpha);
  noStroke();
  rect(bigMapX, bigMapY, bigMap.width/7, bigMap.height/8);
  
  //outer shell
  rectMode(CENTER);
  strokeWeight(5);
  stroke(white);
  noFill();
  rect(width*3/4, height/2, bigMap.width, bigMap.height);
}//-------------------------------------------------- menu --------------------------------------------------

void menuMousePressed() {
}//-------------------------------------------------- menuMousePressed --------------------------------------------------
