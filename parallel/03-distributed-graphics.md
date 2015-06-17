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

Exchange ip addresses with your neighbor to fill in the `partnerIP` variable in the `send_mesage` sketch. Now, you just need to fill in a message to send to your partner by modifying `myMessage`. After you've both modified these variables, run your sketch and you should see output that looks like:

```
Server Running
Connected to partner at N.N.N.N
```

If you don't see the connected message, make sure your partner launched their program and then verify that the IP address you filled in before trying again. If you did, hit any key while the small sketch window is selected to send your message to their server. This is done with the `keyPressed()` block of code.

```processing
void keyPressed() {
  println("Sending: "+myMessage);
  partner.write(myMessage);
}
```

# Send a ball

# Compute Pi

# Next

:white_check_mark: [Learn about sequential and parallel computation](01-introduction.md)  
:white_check_mark: [Make simple graphics](02-simple-graphics.md)  
:white_check_mark: [Make distributed graphics](03-distributed-graphics.md)  
[:arrow_right: Graph500](04-grap500.md)
