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
    println("got message");
    String message = client.readString();
    String[] nums = message.split(",");

    float x = float(nums[0]);
    float y = float(nums[1]);
    float xv = float(nums[2]);
    float yv = float(nums[3]);
    float radius = float(nums[4]);

    Ball ball = new Ball(x < radius ? width - radius : radius, y, xv, yv, radius);

    bag.add(ball);
  }
}

class Bag {
  ArrayList < Ball > balls;

  Bag() {
    balls = new ArrayList < Ball > ();
  }

  // We can't remove items from a list when we're
  // actively iterating over it. Instead of directly
  // removing something from a list we add it to a
  // 'remove List' which we clear from the bag after
  // the iteration process is done.
  void update() {
    ArrayList < Ball > clearList = new ArrayList < Ball > ();

    for (Ball ball: balls) {
      if (ball.update()) {
        clearList.add(ball);
      }
    }

    balls.removeAll(clearList);
  }

  void draw() {
    for (Ball ball: balls) {
      ball.draw();
    }
  }

  void add(float x, float y, float xv, float yv, float radius) {
    add(new Ball(x, y, xv, yv, radius));
  }

  void add(Ball ball) {
    balls.add(ball);
  }
}

class Ball {
  float x;
  float y;
  float xv;
  float yv;
  float radius;

  Ball(float x, float y, float xv, float yv, float radius) {
    this.x = x;
    this.y = y % height - radius;
    this.xv = xv;
    this.yv = yv;
    this.radius = radius;
  }

  // It would be cool if the balls sped up when they were
  // over a certain area.
  boolean update() {
    x += xv;
    y += yv;

    if (x < radius) {
      return goTo(left);
    } else if (x > width - radius) {
      return goTo(right);
    } else if (y > height - radius || y < radius) {
      flipY();
    }

    // Think about adding a new else if to check whether balls have collided

    return false;
  }

  boolean goTo(Computer computer) {
    if(!computer.send(this)) {
      flipX();
      return false;
    }
    return true;
  }

  // nf turns floats into strings
  // join turns arrays of strings into strings
  String toString() {
    float[] points = {x, y, xv, yv, radius};
    return join(nf(points, 0, 0), ",");
  }

  void draw() {
    ellipse(x, y, radius * 2, radius * 2);
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
