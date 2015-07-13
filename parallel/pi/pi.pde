import processing.net.*;
import java.net.*;

Server me;
Client partner;
String partnerIP = "N.N.N.N";
int port = 1234;

float x, y, d;
int canvSize = 700; // canvas size
int radius = canvSize/2;
color fillC;
float inCircle = 0; // counter for points in the circle
float count = 0;    // counter for all points

void setup() {
  size(canvSize, canvSize);
  background(0);
  noStroke();
  // Cooperative PI Computation Code
  //////////////////////////////////
  /* remove this line to uncomment
  me = new Server(this, port);
  connectToPartner(this);
  */
}

void draw() {
  // Generate a random x,y poitn on the canvase
  x = random(canvSize);
  y = random(canvSize);
  // Calculate the point's distance from the center of the canvas
  d = dist(radius,radius,x,y);
  if(d < radius) {
    inCircle++;
    fillC = #448AFF; //blue 
  } else {
    fillC = #FFC107; //amber
  }
  fill(fillC, 30);
  ellipse(x,y,50,50);
  count++;
  if( count % 500 == 0 ) {
    // Print PI approximation every 500 loops
    println("After",count,"loops");
    println("Alone: PI ~",nf(4.0*inCircle/count,1,6),(char)177,
      nf(1.0/sqrt(count),1,6));
    if(pingable()) { // If partner is reachable
      // Send my data
      partner.write(nf(inCircle,0,0)+","+nf(count,0,0));
      // Receive and combine their data
      getMessage();
    } 
  }
}

void connectToPartner(PApplet parent) {
  while(!pingable()) {
    delay(500);
  }
  partner = new Client(parent, partnerIP, port);
}

void getMessage() {
  Client fromPartner = me.available();
  while(fromPartner == null){
    delay(500);
    fromPartner = me.available(); 
  }
  String partnerMessage = fromPartner.readString();
  String[] nums = partnerMessage.split(",");
  float pIN = float(nums[0]);
  float pCount = float(nums[1]);
  println("Combined: PI ~",nf(4.0*(inCircle+pIN)/(count+pCount),1,6),(char)177,
        nf(1.0/sqrt(count+pCount),1,6));
}

boolean pingable() {
  // Determines if a server is reachable
  // by opening a socket connection.
  try {
    Socket soc = new Socket(partnerIP, port);
    return true; 
  } catch(UnknownHostException e) {
    return false;
  } catch(IOException e) {
    return false;
  }
}
