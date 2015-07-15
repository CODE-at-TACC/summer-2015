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
    // If a message is waiting to be read, add it to bag
    String message = client.readString();
    println("Got:",message,"From:",client.ip());
    String[] nums = message.split(",");
    if (nums.length == 5) {
      // Convert strings to floats.
      float x = float(nums[0]);
      float y = float(nums[1]);
      float xv = float(nums[2]);
      float yv = float(nums[3]);
      float radius = float(nums[4]);
      // Added constraints on the variables to check for corrupted packets.
      if ( x >= 0 && y >= 0 && abs(xv) >= 0 && abs(yv) >= 0 && radius > 0 && radius < 500) { 
        // Create ball from parameters and make sure ball is put on this canvas.
        bag.add(xv < 0 ? width-radius : radius, y, xv, yv, radius);
      } else {
        println("Got a bad packet");
      }
    } else {
      println("Got a bad packet");
    }
  }
}

class Bag {
  // The Bag class keeps track of, updates, and draws balls
  // around the screen. 
  ArrayList < Ball > balls;
  Bag() {
    // Initialize the bag with an empty ArrayList of balls.
    this.balls = new ArrayList < Ball > ();
  }

  void update() {
    // Update all balls and remove them if they're sent
    // to another computer.
    ArrayList < Ball > clearList = new ArrayList < Ball > ();
    for (Ball ball: this.balls) {
      if (ball.update()) {
        clearList.add(ball);
      }
    }
    this.balls.removeAll(clearList);
  }

  void draw() {
    // Iterate over all balls and then draw them
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
    //assumes y will never be < 0
    this.x = x;
    this.y = min(y, height - radius); // makes y fit different canvases
    this.xv = xv;
    this.yv = yv;
    this.radius = radius;
    println("Created:",this.x, this.y, this.xv, this.yv, this.radius);
  }

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

    // It would be cool if the balls sped up when they were
    // over a certain area.
    
    return false;
  }

  boolean goTo(Computer computer) {
    // If there is no computer to send do, the ball just bounces.
    if(computer.send(this)) {
      return true;
    }
    flipX();
    return false;
  }

  // nf turns floats into strings
  // join turns arrays of strings into strings
  String toString() {
    float[] points = {this.x, this.y, this.xv, this.yv, this.radius};
    return join(nf(points, 0, 0), ",");
  }

  void draw() {
    float diam = this.radius*2;
    ellipse(this.x, this.y, diam, diam);
  }

  void flipX() {
    this.xv *= -1.0;
  }

  void flipY() {
    this.yv *= -1.0;
  }
}

class Computer {
  // Class to handle dynamic connections
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
