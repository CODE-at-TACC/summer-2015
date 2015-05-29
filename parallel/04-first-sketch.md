# First Sketch

Lets make a really simple first sketch.

```processing
rectangle(25,25,50,50);
````

Now press play!

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




