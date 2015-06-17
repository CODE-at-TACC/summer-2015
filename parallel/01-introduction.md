# Parallel computing

After your Stampede tour, you should know that a super computer is actually a lot of little computers networked together. Problems are solved faster on it through parallel computation, the simultaneous use of multiple compute resources to solve a computational problem \[Barney\]. Things like games and videos are run on multiple processor cores on your personal computers. Time consuming computational problems are broken up and run on hundreds of computers inside Stampede.

To learn about Super Computing today, you will

#### Objectives
1. Learn about sequential and parallel computation
2. Make simple graphics
3. Make distributed graphics
4. Create and benchmark a cluster

# Introduction

Software is typically written for sequential execution, where tasks are completed one-by-one and in order. If you're like me and can't multitask, your typical homework workflow may look like this.

![sequential homework](images/sequential_homework.png)

This is pretty inefficient and a homework deadline may interfere with your more important cat-liking.

![super sad cat](http://cdn.meme.am/instances/57147564.jpg)

To minimize internet cat neglection, you can increase your cat-likes per minute (clpm) and homework problems per minute. The only problem is that the speed of your brain, just like the clock rate of current silicon processors, can only go so fast. According to the Stanford CPU database \[Danowitz et al.\], processors haven't gotten faster since 2005.

![Clock rates](images/clock.png)

With current technology, sequential (single-core) programs won't be running any faster. No matter how much we spend on the latest and greatest PC, it will never be any faster and performance will never improve.

| Super Mario World (1990) | Risk of Rain (2013) |
|--------------------------|---------------------|
|![mario](https://upload.wikimedia.org/wikipedia/en/f/f4/Supermarioworld.jpg)|<img src="http://riskofraingame.com/wp-content/uploads/2012/04/lava_new.png" height="238">|

| Animal Crossing (2002) | Minecraft (2011) |
|---|---|
|![animal crossing](https://upload.wikimedia.org/wikipedia/en/5/5a/Animal_Crossing_gameplay.jpg)|<img src="http://upload.wikimedia.org/wikipedia/en/c/c9/Minecraft_Mobs.png" height="192"> |

So what magic makes the graphics in games like Skyrim and Forza possible?

| Skyrim (2010) | Forza Horizon 2 (2014)|
|---|---|
|<img src="http://cms.elderscrolls.com/sites/default/files/tes/screenshots/Whiterun_wLegal.jpg" height="190">| <img src="http://petr.hospitalrecords.com/amy/HRR-RICKY.jpg" height="190">|

Parallelism. Computers are increasing their throughput without relying on their clock rate. This is often measured through the number of operation a processor can perform every second, and it correlates with the number of transistors on the die. Moore's law

> The number of transistors incorporated in a chip will approximately double every 24 months.
> --Gordon Moore

still holds true today, and the trend is still exponential. Plotting the number of transistors for each processor in the Stanford CPU DB on the logarithmic scale shows that the trend is linear, and would be exponential on a linear scale \[Danowitz et al.\].

![Transistor counts](images/transistors.png)

Since we can no longer rely on raw speed, we now push the bounds of computation through parallel methods. Insead of executing a single instruction at a time, we can execute multiple simultaneously. You can even apply this to your homework workflow.

![parallel homework](images/parallel_homework.png)

This increasing core-count trend is present in all aspects of computing: our phones, our desktops, and our graphics processing units (GPUs). This means we can solve more problems, complete more tasks, and render more polygons than ever before; even at the same speed. We can even make super computers by facilitating efficient parallel computations that are distributed across thousands of machines!

# Super Computers

All super computers, like Stampede here at TACC, are collections of computers networked together to facilitate efficient cooporative work on a single problem or separate work on lots of little problems. Work that is distributed across multiple computers requrires communication between the computers over the network so they know how to coordinate on a problem. At home, you probably have ethernet connections. At TACC we have ethernet, fiber, and a technology called [InfiniBand](https://en.wikipedia.org/wiki/InfiniBand), by Mellanox, designed for low-latency at short distances.

![IB](http://cdn2.bigcommerce.com/n-nr1m3w/uxkkta8o/products/2759/images/5292/CBL_00190_96901__02925.1431463153.220.290.jpg)

You won't get ultra-fast streaming from netflix on a protocol like this, but stampede will be able to predict where [Bill will be going](http://earth.nullschool.net/). 

# Next

Now that you have an idea of what parallel computation can be, lets learn about graphics in Processing so we can eventually make some parallel visualizations today.

#### Objectives

:white_check_mark: Learn about sequential and parallel computation  
:arrow_right: [Make simple graphics](02-simple-graphics.md)

# Citations

Data for CPU freqency and transisort figures came from Danowitz et al.

1. Barney, Blaise. "Introduction to parallel computing." Lawrence Livermore National Laboratory 6, no. 13 (2010): 10.
2. Danowitz, Andrew, Kyle Kelley, James Mao, John P. Stevenson, and Mark Horowitz. "CPU DB: recording microprocessor history." Communications of the ACM 55, no. 4 (2012): 55-63.
