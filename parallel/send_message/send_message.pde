// Load the network library
// https://processing.org/reference/libraries/net/
import processing.net.*;
// Load java.net for Sockets and Exceptions
import java.net.*;

Server me;
Client partner;
String partnerIP = "N.N.N.N"; //write your partner's ip here
int port = 5204; // Has to be the same as your partner
String myMessage = ""; // Write a message to send

void setup() {
  // Start up your server
  me = new Server(this, port);
  println("My server is running on port",port);
  println("Connecting to partner at",partnerIP+':'+port);
  while( !pingable(partnerIP, port) ){
    // Wait until partner's server is running.
    delay(500);
  }
  // Connect to partner's server
  partner = new Client(this, partnerIP, port);
  if(!partner.active()){
    // Check to see if connection worked
    println("Something went wrong with the connection");
    println("Please restart this program");
  }
  println("Connected!"); // Wooo
}

void draw() {
  // Polls your server for available messages
  Client fClient = me.available();
  if ( fClient != null ) {
    // Read the message
    String partnerMessage = fClient.readString();
    // Print the message
    println("Recieved: "+partnerMessage);
  }
}

void keyPressed() {
  // Sends your message when you press any key
  println("Sending: "+myMessage);
  partner.write(myMessage);
}

boolean pingable(String ip, int port) {
  // Determines if a server is reachable
  // by opening a socket connection.
  try {
    Socket soc = new Socket(ip, port);
    soc.close();
    return true; 
  } catch(UnknownHostException e) {
    return false;
  } catch(IOException e) {
    return false;
  }
}
