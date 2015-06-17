# Distributed Graphics

As everyone at TACC already knows, the world depends on parallel code to drive technological advancement because physicists won't be making silicon processors any faster. Luckily, we'll be writing distributed parallel code in this section using the Processing [Network library](https://processing.org/reference/libraries/net/). We will start by using Processing to visualize our distributed operations and then combine all our Raspberry Pis and construct a super computer at the end of the day and run a real benchmark.

#### Objectives

1. Send a message between computers
2. Send a ball between computers
3. Compute Pi
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
Server Running
Connected to partner at N.N.N.N
```

If you don't see the "connected" message, make sure your partner launched their program and then verify that the IP address you filled in before trying again. If you did, hit any key while the small sketch window is selected to send your message to their server. This is done with the `keyPressed()` block of code.

```processing
void keyPressed() {
  println("Sending: "+myMessage);
  partner.write(myMessage);
}
```

All types of networked communication works though interactions of this manner. Internet browsers are clients asking servers for files residing in a specific location at an internet addresss. Open MPI passes messages between programs on a network to coordinate work because separate nodes have no shared memory. Welcome to the world of distributed computing! This was your first step, but this will be the first test we run after assembling the cluster for Graph500.

While I'm sure you're really impressed that you got a sentence to your partner's computer, I bet you're wondering how you could send a graphic over there.

# Send a ball

Take a look at the base example `bouncing_network/bouncing_network.pde`. Depending on how you and your partner are seated, we want to send a message whenever the ball hits the edge that you share. If you're on the left, this means your right edge. If you're seated on the right, your left edge.

**[ L ] [ R ]**

The message that Processing will send from each computer will be the parameters for the ball, and not an actual graphic. Since we assume that the incoming message will be for a ball, we only need to send the

(x-coordinate, y-coordinate, x-velocity, and y-velocity)

all encoded as a string.

"x-coordinate,y-coordinate,x-velocity,y-velocity"

The only problem with this is that we won't be able to handle different sizes.

## Add Click

## Challenge

Make the balls slow down
Make the balls bounce off eachother
Make add an accellerator

As long as you're not changing the structure of the ball, you can do whatever you want on your end.

# Next

:white_check_mark: [Learn about sequential and parallel computation](01-introduction.md)  
:white_check_mark: [Make simple graphics](02-simple-graphics.md)  
:white_check_mark: [Make distributed graphics](03-distributed-graphics.md)  
[:arrow_right: Graph500](04-grap500.md)
