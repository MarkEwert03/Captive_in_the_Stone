class Hero {

  //instance variables
  float x, y, r, speed;


  //constructor(s)
  Hero() {
    //basic
    x = width/2;
    y = height/2;
    r = 50;
    speed = 10;
  }//-------------------------------------------------- Hero() --------------------------------------------------

  //behavior functions
  void show() {
    //image
    noStroke();
    fill(white);
    ellipse(x, y, 2*r, 2*r);
  }//-------------------------------------------------- show --------------------------------------------------

  void act() {
    //movement
    if (upKey)    y -= speed;
    if (downKey)  y += speed;
    if (leftKey)  x -= speed;
    if (rightKey) x += speed;

    //wall collision detection
    //use height instead of width so padding is consistant
    if (!west && x - r <= height * wallRatio) x = height * wallRatio + r;

    if (!north && y - r <= height * wallRatio) y = height * wallRatio + r;

    //use height instead of width so padding is consistant
    if (!east && x + r >= width - (height * wallRatio)) x = width - (height * wallRatio) - r;

    if (!south && y + r >= height * (1 - wallRatio)) y = height * (1 - wallRatio) - r;

    //checks for paths
    if (west) checkWest();
    if (north) checkNorth();
    if (east) checkEast();
    if (south) checkSouth();
  }//-------------------------------------------------- show --------------------------------------------------

  void checkWest() {
    if (west && x - r <= 0) {
      roomX--;
      switchRoom();
      x = width * (1 - wallRatio) - r;
    }
  }//-------------------------------------------------- goWest --------------------------------------------------

  void checkNorth() {
    if (north && y - r <= 0) {
      roomY--;
      switchRoom();
      y = height * (1 - wallRatio) - r;
    }
  }//-------------------------------------------------- goNorth --------------------------------------------------

  void checkEast() {
    if (east && x + r >= width) {
      roomX++;
      switchRoom();
      x = width * wallRatio + r;
    }
  }//-------------------------------------------------- goEast --------------------------------------------------

  void checkSouth() {
    if (south && y + r >= height) {
      roomY++;
      switchRoom();
      y = height * wallRatio + r;
    }
  }//-------------------------------------------------- goSouth --------------------------------------------------
}//-------------------------------------------------- Hero --------------------------------------------------
