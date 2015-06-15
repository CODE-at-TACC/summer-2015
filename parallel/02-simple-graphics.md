# Simple Graphics

[<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Processing_Logo_Clipped.svg/200px-Processing_Logo_Clipped.svg.png" align="left" width="75" height="75"></br></br>rocessing](https://processing.org/) is the open source language developed over the Java programming language to aid teaching computer programming through visual interactions. In this section, we will be learning the basics of processing to aid us in understanding distributed computing.

#### Objectives

1. Install Processing
2. Make a simple sketch
3. Make an animation

# Installation

First, you need to install processing on your Raspberry Pi 2. There is no official ARM version of processing available, but luckily it runs in java, making it (mostly) platform independent. Processing 2.2.1 (stable) requires Oracle Java 7, so we'll need to download and install that from the Raspbian repositories.

```shell
sudo apt-get install oracle-java7-jdk
```
Now that we have java, we can download and un-tar processing.

```shell
wget http://download.processing.org/processing-2.2.1-linux32.tgz
tar -xzf processing-2.2.1-linux32.tgz
```

The -xzf parameters tell tar to e(x)tract, un(z)ip, the (f)ile: processing-2.2.1-linux32.tgz. The gz in tgz denotes a gzipped tarball. Now, we just need to link in our new Java to make it functional.

```shell
cd processing-2.2.1
rm -rf java
ln -s /usr/lib/jvm/jdk-7-oracle-armhf java
```

The ln command makes a [symbolic link](http://en.wikipedia.org/wiki/Symbolic_link) to our Oracle Java 7 without having to move or copy the installation. We can now test to make sure everything worked by launching Processing.

```shell
./processing
```
After some messages on your console, the graphical IDE pictured below should appear.

![processing IDE](images/processing.png)

IDE stands for *Integrated Development Environment* and usually allows code editing, building, and debugging all from inside the single program. All of our Processing development will be taking place inside of this IDE, so you won't be learning any new keyboard shortcuts! Even though IDE development is easier, knowing how to edit text inside a terminal is invaluable when working on remote systems like stampede. Up next, we'll be making our first program, or sketch.

# First Sketch

Lets make a really simple first sketch.

```processing
rect(25,25,50,50);
````

Now run the program by pressing play!  

<img src="images/play.png" height="100">  

After waiting a few seconds, a window that looks like the image below should appear.

![square](images/first_program.png)

While a simple square on a window may not seem very impressive, take a look at your single line transformed into real Java code.

```java
import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class first extends PApplet {
  public void setup() {
rect(25,25,50,50);
    noLoop();
  }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "first" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
```

Scary.

This pile of Java is why Processing was developed. You don't start with the traditional "Hello World!"; you're starting with a graphic! From a single line, which the compiler turned into complicated Java code. Before we make a bigger and better program, lets learn a little about the window, or canvas, that all graphics are drawn to.

# The Processing Canvas

The processing canvas sits on a coordinate system. When the square was drawn to the canvas we drew it to point (25,25). If we were drawing the square on a calculator or a graph, (25,25) would be in the upper-right corner. However, (0,0) is the upper-left and (inf,inf) is the lower-right on a processing canvas.

| Graph | Processing |
|-------|------------|
|![center axis](images/centered_axis.png)|![processing axis](images/processing_axis.png)

Now that you how shapes are drawn on the canavs, we can experiment with the rect command. According to the [documentation](https://processing.org/reference/rect_.html), the parameters of `rect(x,y,w,h)` correspond to:

| Parameter | Description |
|---|:---|
| x | x-coordinate of the rectangle |
| y | y-coordinate of the rectangle |
| w | width of the rectangle |
| h | height of the rectangle |

## Activity

Take some time and try to replicate these examples from what we learned about the `rect()` command.

| Objective | Example |
|:--|---|
| Draw the square in the lower-left corner | ![lower left](images/lower_left.png) |
| Draw the square half on the screen | ![half left](images/half_left.png) |
| Draw a rectangle | ![rectangle](images/rectangle.png) |
| Draw multiple rectangles | ![more rectangles](images/two_rect.png) |

After recreating all examples, take a look at the "2D Primatives" in the [Processing documentation](https://processing.org/reference/) and try making other shapes. A good start would be using `ellipse()` to make a circle.

## What you learned

1. You learned how to draw rectangles of different sizes all around your Processing canvas.
2. You learned how to read the documentation to draw different shapes we didn't cover in this lesson.

# Simple Animation

Now that you can make simple shapes and understand how to draw them to different parts of the canvas, you're ready to make your first animation. Fist, lets learn about two important sections in processing code: [setup](https://processing.org/reference/setup_.html) and [draw](https://processing.org/reference/draw_.html).

## Setup

Processing automatically looks for and call the `setup()` function when a program starts. `setup()` is used to define initial environment properties like:

#### Canvas size
The canvas size can be specified with the [`size()`](https://processing.org/reference/size_.html) command, which takes the two arguments: width and height. Processing defaults to a 100 by 100 pixel canvas. If we wanted to create a canvas that was 300 pixels wide and 200 pixels tall, we could use the command

```processing
void setup() {
  size(300,200);
}
```
#### Background color
You can set the background of your canvas to either a specific color or an image using the `background()` function in your `setup()` initialization. The default background is the light gray you saw behind your white shapes, but you can change that color 4 main ways:

* background(rgb)
* background(gray)
* background(v1, v2, v3)
* background(image)

| Parameter | Type | Description |
|:----:|:----:|:---|
| rgb | int | Any value of the color datatype or a hex code|
| gray | float | Specifies a value between white and black [0,255]|
| v1 | float | Red or hue value (depending on the current color mode)|
| v2 | float | Green or saturation value (depending on the current color mode)|
| v3 | float | Blue or brightness value (depending on the current color mode)|
| image | PImage | PImage to set as background (must be same size as the sketch window)|

Lets be extra interesting and make a light blue background.

```processing
void setup() {
  background(#99CCFF);
}
```

You can also pick a different color from http://www.w3schools.com/tags/ref_colorpicker.asp.

#### Execution rate

When we finally make our animation, we can specify the framerate to render the animation at with the `frameRate()` command. By default, Processing tries to render at 60 frames per second (fps), so lets change it to a sane 30 fps for the Pis with the code:

```processing
void setup() {
  frameRate(30);
}
```

Just make sure that whatever you do, you keep it all in the same `setup()` function because there can only be one per program, and any extras won't be called.


Now that you can draw basic shapes to the Processing canvas, we're going to make our f

:white_check_mark: [Learn about sequential and parallel computation](01-introduction.md)  
:white_check_mark: [Make simple graphics](02-simple-graphics.md)  
[:arrow_right: Make distributed graphics](03-distributed-graphics.md)
