import processing.net.*;

Server me;
Client you;
String yourIP = "";
int port = 5204;
String myMessage = "";
String yourMessage = "";

void setup() {
  me = new Server(this, port);
  println("Server Running - Press any key to send message");
}

void keyPressed() {
  you = new Client(this, yourIP, port);
  yourMessage = you.readString();
  println(yourMessage);
}
