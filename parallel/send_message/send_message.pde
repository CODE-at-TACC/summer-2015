import processing.net.*;

Server me;
Client partner;
String partnerIP = "N.N.N.N"; //write your partner's ip here
int port = 5204;
String myMessage = ""; //write a message to send
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
  Client fClient = me.available();
  if ( fClient != null ) {
    partnerMessage = fClient.readString();
    println("Recieved: "+partnerMessage);
  }
}

void keyPressed() {
  println("Sending: "+myMessage);
  partner.write(myMessage);
}
