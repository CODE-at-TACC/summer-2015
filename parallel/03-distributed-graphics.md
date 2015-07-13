# Distributed Graphics

As everyone at TACC already knows, the world depends on parallel code to drive technological advancement because physicists won't be making silicon processors any faster. Luckily, we'll be writing distributed parallel code in this section using the Processing [Network library](https://processing.org/reference/libraries/net/). We will start by using Processing to visualize our distributed operations and then combine all our Raspberry Pis and construct a super computer at the end of the day and run a real benchmark.

#### Objectives

1. Send a message between computers
2. Send a ball between computers
4. Construct cluster for Graph500

# Send a message

In processing, open the sketch

`~/summer-2015/parallel/send_message/send_message.pde`

You'll see that you need your partner's IP address, so your program knows *where* to send the message and if your partner's computer is even listening for one. First, get your IP address and write it down on a post-it note because we'll be using it later.

```shell
$ hostname -I
```

Exchange ip addresses with your neighbor to fill in the `partnerIP` variable in the `send_mesage` sketch. Now, you just need to make in a message to send to your partner by modifying `myMessage`. After you've both modified these variables, run both of your sketch and you Pis connect to eachother you should see the following output:

```
My server is running on port 5204
Connecting to partner at N.N.N.N:5204
Connected!
```

If you don't see the "Connected!" message, make sure your partner launched their program and then verify that partnerIP does match your partner's IP address and both of your port variables are set to 5204. The setup portion of the code is somewhat complicated but necessary because processing doesn't like to automatically establish a connection when there wasn't one.

```processing
void setup() {
  // Start up your server
  me = new Server(this, port);
  println("My server is running on port",port);
  println("Connecting to partner at",partnerIP+':'+port);
  while( !pingable(partnerIP, port) ){
    // Wait until partner's server is running.
    delay(500);
  }
  // Connect to partners server
  partner = new Client(this, partnerIP, port);
  if(!partner.active()){
    // Check to see if connection worked
    println("Something went wrong with the connection");
    println("Please restart this program");
  }
  println("Connected!"); // Wooo
}
```

This forces your program to wait until your partner's server is pingable and your connection to them is active. After you get the "Connected!" status message, switch to the canvas window and hit any key to send your message, which triggers the `keyPressed()`.

```processing
void keyPressed() {
  // Sends your message when you press any key
  println("Sending: "+myMessage);
  partner.write(myMessage);
}
```

All types of networked communication works though interactions of this manner. Internet browsers are clients asking servers for files residing in a specific location at an internet addresss. [Open MPI](https://en.wikipedia.org/wiki/Open_MPI) passes messages between programs on a network to coordinate work because separate nodes have no shared memory. Welcome to the world of distributed computing! This was your first step, but this will also be the first test we run after assembling the cluster for Graph500.

I know you're impressed with the messages we just sent, so lets work on shoving a bouncing ball through our wireless connection. If hackerman can hack anything through time, we can do this.

<img src="http://i.imgur.com/YRBRRRI.png" height="200">

# Send a ball

Take a look at the base example `bouncing_network/bouncing_network.pde`. Depending on how you and your partner are seated, we want to send a message whenever the ball hits the edge that you share. If you're on the left, this means your right edge. If you're seated on the right, your left edge.

**[ L ] [ R ]**

The message that Processing will send from each computer will be the parameters for the ball, and not an actual graphic. Since we assume that the incoming message will be for a ball, we only need to send the

(x-coordinate, y-coordinate, x-velocity, and y-velocity)

all encoded as a string.

"x-coordinate,y-coordinate,x-velocity,y-velocity"

Right now position and velocity are the only things that can change on a ball, but feel free to work with your partnet to incorporate something new. After you get the two balls bouncing back and forth between your two monitors, I have a series of challenges for you to try out.

# Challenges

#### 1. Click to add
Add a new ball wherever you click on the canvas. Take a look at the section
```processing
void mouseClicked() {
  // mouseX and mouseY are handy
  // random(lower, upper) is cool too
}
```
#### 2. Create obstacles
Add a new object to the screen that the balls either bounce off of or speed up over. I'd insert this change in the update method of the bag function.
```processing
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
          b.flop(2);
          b.update();
        }
      } else if ( b.ret(0) > width-radius ) {
        if( rightIP != "" ) {
          println("sending right");
          right.write(b.toStr());
          balls.remove(i);
        } else {
          b.flop(2);
          b.update();
        }
      } else if ( b.ret(1) > height-radius || b.ret(1) < radius ) {
        b.flop(3);
        b.update();
      } else { b.update(); }
    }
    // Think about adding a new else if to check whether balls have collided
  }
```
#### 3. Add more monitors
You have a left and a right, so try to make a ring around your table and see how crazy it gets.
#### 4. Add color
Assign a random color to each of your balls and render them that way on your screen. This would be achieved in the inital `ball()` constructor and with the `fill()` command in `ball.draw()`.
#### 5. Make the balls ricochet
Again, this would be achieved inside the `bag.update()` function, and you'll need to add another for loop to make a pairwise comparison between all balls.

You and your partner don't even need to complete the same goals and have the same code, as long as your changes don't affect the structure of the ball.

As long as you're not changing the structure of the ball, you can do whatever you want on your end.

# More information

https://github.com/shiffman/Most-Pixels-Ever-Processing

This only distributes the view, and not the computation.

# Next

:white_check_mark: [Learn about sequential and parallel computation](01-introduction.md)  
:white_check_mark: [Make simple graphics](02-simple-graphics.md)  
:white_check_mark: [Make distributed graphics](03-distributed-graphics.md)  
[:arrow_right: Green Graph500](greengraph500/01-greengraph500.md)
