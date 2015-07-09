import processing.net.*;
import java.net.*;
import java.net.Socket;

Server server;
Computer left, right;

Bag bag = new Bag();

void setup() { // sets up server
  size(500, 500);
  fill(0);
  server = new Server(this, 2342);
  left = new Computer(this, "N.N.N.N", 2342); // left computer's IP
  right = new Computer(this, "N.N.N.N", 2342); // right computer's IP

  background(255);
  bag.add(50, 50, 1, 2, 25);
}

void mouseClicked() {
  // mouseX and mouseY are handy
  // random(lower, upper) is cool too
}

void draw() {
  background(255);
  bag.update();
  bag.draw();

  Client client = server.available();

  if (client != null) {
    println("Got message");
    String message = client.readString();
    String[] nums = message.split(",");

    float x = float(nums[0]);
    float y = float(nums[1]);
    float xv = float(nums[2]);
    float yv = float(nums[3]);
    float radius = float(nums[4]);

    bag.add(x, y, xv, yv, radius);
  }
}

class Bag {
  ArrayList < Ball > balls;

  Bag() {
    this.balls = new ArrayList < Ball > ();
  }

  void update() {
    ArrayList < Ball > clearList = new ArrayList < Ball > ();

    for (Ball ball: this.balls) {
      if (ball.update()) {
        clearList.add(ball);
      }
    }
    this.balls.removeAll(clearList);
  }

  void draw() {
    for (Ball ball: this.balls) {
      ball.draw();
    }
  }

  void add(float x, float y, float xv, float yv, float radius) {
    this.balls.add(new Ball(x, y, xv, yv, radius));
  }
}

class Ball {
  float x, y, xv, yv, radius;

  Ball(float x, float y, float xv, float yv, float radius) {
    //assumes x and y will never be < 0
    this.x = min(x, width - radius);
    this.y = min(y, height - radius);
    this.xv = xv;
    this.yv = yv;
    this.radius = radius;
  }

  // It would be cool if the balls sped up when they were
  // over a certain area.
  boolean update() {
    this.x += this.xv;
    this.y += this.yv;

    if (this.x < this.radius) {
      return goTo(left);
    } else if (this.x > width - this.radius) {
      return goTo(right);
    } else if (this.y > height - this.radius || this.y < this.radius) {
      flipY();
    }

    // Think about adding a new else if to check whether balls have collided

    return false;
  }

  boolean goTo(Computer computer) {
    if(computer.send(this)) {
      return true;
    }
    flipX();
    return false;
  }

  // nf turns floats into strings
  // join turns arrays of strings into strings
  String toString() {
    float[] points = {x, y, xv, yv, radius};
    return join(nf(points, 0, 0), ",");
  }

  void draw() {
    float diam = radius*2;
    ellipse(x, y, diam, diam);
  }

  void flipX() {
    xv *= -1.0;
  }

  void flipY() {
    yv *= -1.0;
  }
}

class Computer {
  // custom class to handle dynamic connections
  PApplet parent;
  Socket soc;
  String ip;
  int port;
  Client conn;

  Computer(PApplet parent, String ip, int port) {
    this.parent = parent;
    this.ip = ip;
    this.port = port;
    if(pingable()) {
      reconnect();
    }
  }
  
  boolean pingable() {
    // catchable way to see if servers are on
    try {
      this.soc = new Socket(this.ip, this.port);
      soc.close();
      return true; 
    } catch(UnknownHostException e) {
      return false;
    } catch(IOException e) {
      return false;
    }
  }

  boolean reconnect() {
    this.conn = new Client(parent, ip, port);
    return this.conn.active();
  }

  boolean send(Ball ball) {
    if(this.conn != null && this.conn.active()) {
      //send ball if connection exists and is active
      this.conn.write(ball.toString());
      return true;
    }
    if(this.pingable() && this.reconnect()) {
      //if pingable, reconnect and send
      this.conn.write(ball.toString());
      return true;
    }
    return false; //couldn't send
  }
}
