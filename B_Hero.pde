class Hero {

  //instance variables
  float x, y, r, speed;

  //constructor(s)
  Hero() {
    //basic
    x = width/2;
    y = height/2;
    r = (width*height)/20000;
    speed = sqrt(sq(width) + sq(height))/200;
  }//-------------------------------------------------- ~default constructor~ --------------------------------------------------

  Hero(float x, float y, float r, float speed) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.speed = speed;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

  Hero(Hero copyHero) {
    x = copyHero.x;
    y = copyHero.y;
    r = copyHero.r;
    speed = copyHero.speed;
  }//-------------------------------------------------- ~copy constructor~ --------------------------------------------------

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
  }//-------------------------------------------------- checkWest --------------------------------------------------

  void checkNorth() {
    if (north && y - r <= 0) {
      roomY--;
      switchRoom();
      y = height * (1 - wallRatio) - r;
    }
  }//-------------------------------------------------- checkNorth --------------------------------------------------

  void checkEast() {
    if (east && x + r >= width) {
      roomX++;
      switchRoom();
      x = width * wallRatio + r;
    }
  }//-------------------------------------------------- checkEast --------------------------------------------------

  void checkSouth() {
    if (south && y + r >= height) {
      roomY++;
      switchRoom();
      y = height * wallRatio + r;
    }
  }//-------------------------------------------------- cehckSouth --------------------------------------------------
}//-------------------------------------------------- Hero --------------------------------------------------
