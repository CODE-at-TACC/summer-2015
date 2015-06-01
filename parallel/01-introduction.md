# Parallel computing

Typically, whenever software is written, it is made for serial execution. This means that commands are exectuted sequentially and on a single processor. However, processor clock rates have stopped increasing due to the limits of silicon.

![Clock rates](images/clock.png)

With current technology, sequential (single-core) programs won't be running any faster. Chips in our gaming systems won't be getting any faster to produce more realistic graphics. No matter how much we spend on the lastest and greatest PC, it won't be any faster than the previous generation. Even all the videos, animations, and ads on a single web-page will drag a CPU to a halt. With all this said about the speed stagnation of the CPU, computers do keep getting better and programs and graphics keep getting flashier. We went from

| Morrowind in 2002 | Skyrim in 2010 |
|----------------|-------------|
|<img src="http://img29.imageshack.us/img29/1149/morrowind20110405225039.jpg" height="200"> | <img src="http://cache.gawkerassets.com/assets/images/9/2011/11/69cd3eb274be7c06c809693adb862fa9.jpg" height="200"> |

without a major speed increase. That's because computers are increasing their throughput without relying on their clock rate. This is often measured through the number of operation a processor can perform every second, and it correlates with the number of transistors on the die. Moore's law

> The number of transistors incorporated in a chip will approximately double every 24 months.
> --Gordon Moore

still holds true today, and the trend is still exponential. Plotting the number of transistors for each processor in the Stanford CPU DB on the logarithmic scale shows that the trend is linear, and would be exponential on a linear scale.

![Transistor counts](images/transistors.png)

Since we can no longer rely on raw speed, we now push the bounds of computation through parallel methods. Insead of executing a single instruction at a time, we can execute multiple simultaneously. This increasing trend of cores is present in all aspects of computing: our phones, our desktops, and our graphics processing units (GPUs). However, parallel computation isn't restricted to happening on a single physical computer. 

# Super Computers

All super computers, like Stampede here at TACC, are collections of computers networked together to facilitate efficient cooporative work on a single problem or separate work on lots of little problems. Work that is distributed across multiple computers requrires communication between the computers over the network so they know how to coordinate on a problem. To help you understand this, we'll do a quick activity in groups. Not only will this help you understand distributed parallelism, you'll also see different types of communication.

# Activity

Compute the max value from an array of numbers. Communication will happen in the following ways.

1. 1 person passes all numbers out in clockwise fashion. Everyone will return the maximum of their numbers to the original. Original person will then find the largest of those numbers.
2. 1 person passes all numbers out in clockwise fashion. Everyone will tell their largest number to everyone. Original person gets the largest number fom the person that has it.
3. Think of more ways.

Now that you've physically performed a parallel computation, we're going to learn about ways to make visualizations before we implement one.

:arrow_right: Processing Introduction

# Citations

Data for CPU freqency and transisort figures came from Danowitz et al.

1. Danowitz, Andrew, Kyle Kelley, James Mao, John P. Stevenson, and Mark Horowitz. "CPU DB: recording microprocessor history." Communications of the ACM 55, no. 4 (2012): 55-63.
