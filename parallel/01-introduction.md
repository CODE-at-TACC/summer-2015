# Parallel computing

Typically, whenever software is written, it is made for serial execution. This means that commands are exectuted sequentially and on a single processor. However, processor clock rates have stopped increasing due to the limits of silicon.

![Clock rates](images/clock.png)

This means sequential (single-core) programs won't be running any faster. This means next-gernation graphics in games won't be able to rely on faster chips in our gaming systems. The lastest, fastest Mac won't be able to work through the data coming from all our internet-connected devices. Even all the videos, animations, and ads on a single web-page will drag a CPU to a halt. However, your computer keeps getting faster and all programs keep getting flashier. This is because of Moore's law, which states:

> The number of transistors incorporated in a chip will approximately double every 24 months.
> --Gordon Moore

If we take a look at the nuber of transistors in CPUs over the years, you see that the trend is exponential!

![Transistor counts](images/transistors.png)

Even though processor speed has leveled off an even slowed down in some cases, we're able to do more though parallel execution. Insead of executing a single instruction at a time, we can execute multiple simultaneously. This increasing trend of cores is present in all aspects of computing: our phones, our desktops, and our graphics processing units (GPUs). However, parallel computation isn't restricted to happening on a single physical computer. 

# Super Computers

All super computers, like Stampede here at TACC, are collections of computers networked together to facilitate efficient cooporative work on a single problem or separate work on lots of little problems. Work that is distributed across multiple computers requrires communication between the computers over the network so they know how to coordinate on a problem. To help you understand this, we'll do a quick activity in groups. Not only will this help you understand distributed parallelism, you'll also see different types of communication.

# Activity

Compute the max value from an array of numbers. Communication will happen in the following ways.

1. 1 person passes all numbers out in clockwise fashion. Everyone will return the maximum of their numbers to the original. Original person will then find the largest of those numbers.
2. 1 person passes all numbers out in clockwise fashion. Everyone will tell their largest number to everyone. Original person gets the largest number fom the person that has it.
3. Think of more ways.

Now that you've physically performed a parallel computation, we're going to learn about ways to make visualizations before we implement one.

:right_arrow: Processing Introduction

# Citations

Data for CPU freqency and transisort figures came from Danowitz et al.

1. Danowitz, Andrew, Kyle Kelley, James Mao, John P. Stevenson, and Mark Horowitz. "CPU DB: recording microprocessor history." Communications of the ACM 55, no. 4 (2012): 55-63.
