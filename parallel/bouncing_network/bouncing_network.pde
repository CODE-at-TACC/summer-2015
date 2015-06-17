import processing.net.*;

Server sMe;

String leftIP = "";
String rightIP = "";
Client left, right;

int port = 2342;

float radius = 25; // radius
float diam = radius*2;

boolean connLeft = false;
boolean connRight = false;

int j;

bag b1 = new bag();

void setup() {
  size(500, 500);
  fill(0);
  sMe = new Server(this, port);
  while ( !connLeft || !connRight ) {
      if( leftIP != "" && !connLeft) {
        left = new Client(this, leftIP, port);
        if( left.active() ) { connLeft = true; }
      } else { connLeft = true; }
      if( rightIP != "" && !connRight) {
        right = new Client(this, rightIP, port);
        if( right.active() ) { connRight = true; }
      } else { connRight = true; }
  }
  background(255);
  b1.addBall(25,25,1,2);
  println(b1.balls.get(0).ret(0));
}

void mouseClicked() {
  b1.addBall(float(mouseX), float(mouseY), random(0.5,5), random(0.5,5));
}

void draw() {
  background(255);
  b1.update();
  b1.draw();
  Client fClient = sMe.available();
  if ( fClient != null ) {
    println("Got message");
    String bString = fClient.readString();
    String[] bList = bString.split(",");
    float[] fList = new float[4];
    for(j = 0; j<4; j++) {
      fList[j] = float(bList[j]);
    }
    if(fList[2] < 0) {
      b1.addBall(width+radius, fList[1], fList[2], fList[3]);
    } else {
      b1.addBall(-radius, fList[1], fList[2], fList[3]);
    }
  }
}



class bag {
  ArrayList<ball> balls;
  int i;
  ball b;
  bag() {
    balls = new ArrayList<ball>();
  }
  void update() {
    if(balls == null){return;}
    for(i=balls.size()-1; i>=0; i--) {
      b = balls.get(i);
      if( b.ret(0) < radius ) {
        if( leftIP != "" ) {
          println("sending left");
          left.write(b.toStr());
          balls.remove(i);
        } else {
          println("left flop");
          b.flop(2);
          b.update();
        }
      } else if ( b.ret(0) > width-radius ) {
        if( rightIP != "" ) {
          println("sending right");
          right.write(b.toStr());
          balls.remove(i);
        } else {
          println("right flop");
          b.flop(2);
          b.update();
        }
      } else if ( b.ret(1) > height-radius || b.ret(1) < radius ) {
        println("flop y");
        b.flop(3);
        b.update();
      } else { b.update(); }
    }
  }
  void draw() {
    for(i=0; i<balls.size(); i++) {
      ball b = balls.get(i);
      b.draw();
    }
  }
  void addBall(float x, float y, float xv, float yv) {
    balls.add(new ball(x, y, xv, yv));
  }
}


class ball {
  //float[] ballAr = {25,25,2,3};
  float[] ballAr = new float[4];
  ball(float x, float y, float xv, float yv) {
    ballAr[0] = x;
    ballAr[1] = y;
    ballAr[2] = xv;
    ballAr[3] = yv;
  }
  void update() {
    ballAr[0] += ballAr[2];
    ballAr[1] += ballAr[3];
  }
  String toStr() {
    String[] sList = nf(ballAr, 0, 0);
    return join(sList,",");
  }
  void draw() {
    ellipse(ballAr[0], ballAr[1], diam, diam);
  }
  float ret(int i) {
    return ballAr[i];
  }
  void flop(int i) {
    ballAr[i] *= -1;
  }
}
