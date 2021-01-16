class Hero {
  
  //instance variables
  float x, y, speed;
  
  
  //constructor(s)
  Hero() {
    //basic
    x = width/2;
    y = height/2;
    speed = 5;
    
  }//-------------------------------------------------- Hero() --------------------------------------------------
  
  //behavior functions
  void show(){
    //image
    noStroke();
    fill(lightYellow);
    rect(x, y, 100, 100);
    
  }//-------------------------------------------------- show --------------------------------------------------
  
  void act(){
    //movement
    if (upKey)    y -= speed;
    if (downKey)  y += speed;
    if (leftKey)  x -= speed;
    if (rightKey) x += speed;
  }//-------------------------------------------------- show --------------------------------------------------
  
  
}//-------------------------------------------------- Hero --------------------------------------------------
