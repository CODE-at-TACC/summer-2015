import processing.net.*;

Server me;
Client partner;
String partnerIP = "";
int port = 5204;
String myMessage = "";
String partnerMessage = "";
boolean connected = false;

void setup() {
  me = new Server(this, port);
  println("Server Running");
  while( !connected ){
    partner = new Client(this, partnerIP, port);
    if( partner.active() ) {
      connected = true;
    }
  }
  println("Connected to partner at "+partnerIP);
}

void draw() {
  if( partner.available() > 0 ) {
    partnerMessage = partner.readString();
    println("Recieved: "+partnerMessage);
  }
}

void keyPressed() {
  println("Sending my message");
  me.write(myMessage);
}
