float radius = 25;

float xPos = 25;
float yPos = 25;

float xVel = 2;
float yVel = 3;

void setup() {
  size(500, 500);
  background(255);
  fill(0);
}

void draw() {
  background(255); //resets canvas
  ellipse(xPos, yPos, 50, 50); //draw circle
  //Move circle
  xPos = xPos + xVel;
  yPos = yPos + yVel;
  // Calculate if circle bounced
  if ( xPos > width-radius || xPos < radius ) {
    xVel *= -1;
  }
  if ( yPos > height-radius || yPos < radius ) {
    yVel *= -1;
  }
}
