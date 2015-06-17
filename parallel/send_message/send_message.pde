import processing.net.*;

Server me;
Client partner;
String partnerIP = "10.0.1.39";
int port = 5204;
String myMessage = "fewfew";
String partnerMessage = "";
boolean connected = false;

void setup() {
  me = new Server(this, port);
  println("Server Running");
  while( !connected ){
    try {
      partner = new Client(this, partnerIP, port);
    } finally {
      //if(partner.active()){
        connected = true;
      //}
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
