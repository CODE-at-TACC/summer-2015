Introducing Python
==================

Python is a language for computer scripts.  It can be run on practically any computer.

Python is easy to learn, and plays well with others.

Python, when given a text file as input, will “execute” the actions described in the text file.

#### Objectives
1. Read Python scripts
2. Run Python scripts
3. Edit Python scripts
4. ~~Love Python scripts~~



## Start at the very beginning

When learning a new language, the first word learned is often “Hello”.  Similarly, when learning at new computer language, the first computer program written is “Hello world!” This is a computer program that, when run, will print to the screen the words “Hello world!”

In Python, writing this first program is very simple. It uses the keyword **print**

```print "Hello world!"```

#### Challenge

Use Python to say hello to the person on your right.

To speed up this introduction, you already have the code files.  

You can open the file *1_hello_world.py* in Leafpad.

Make you change and save the file.

To run the code type *python 1_hello_world.py*

#### What you learned

How to use the keyword **print**
How to view, edit, and run a Python script



## This Time with Variables

In algebra, you learned that a **variable** is a quantity that can change within the context of a mathematical problem, and is represented by a single letter.  For example, x = 3 + y.

In programming, *information* can be assigned to a **variable**, and variables are identified by one or more letters.

Let us look at Hello world, with variables.

```greeting = "Hello"

name = "world"

salutation = greeting + " " + name + "!"

print salutation```


*greeting* is assigned the information "Hello" using the **=** symbol.

*name* is assigned the information "world”.

The quotes indicate that the type of the information is a **string**.  A string is a list of characters such as numbers, letters, and symbols.

Then, *salutation* is assigned the combination of *greeting*, a space, *name*, and an exclamation mark.

Multiple strings can be combined into one string using the plus symbol, **+**

Finally, the information in *salutation* is printed to the screen.


#### Challenge

Use *2_hello_world_again.py* to say hello to the person on your left by changing the information stored in  *name*

#### What you learned

How to assign information to a variable
What a **string** is
How to combine strings


## Putting the “fun” into Function

When performing essentially the same set of actions repeatedly, you can create a *function* for these set of actions. Because computers are generally used to perform repeated tasks, we are almost always creating a lot of functions.

![Function meme](images/FunctionAllTheThings.jpg)

Functions in Python always start with the keyword **def** which is short for define, followed by the name of the function.



```
def greet( name ):
    print "Hello " + name + "!"
    print "Nice to see you."
    print "Thank you for coming to CODE@TACC."

greet( "world" )
greet( "friend" )
```

***Notice!*** The print statements are part of the function **greet**, and they are indented using **4 spaces**.  Python relies on indenting to determine which lines are part of the function.  

Now when the function **greet** is called with the input "world”, the variable **name** is given the information "world".


#### Challenge

Add “I look forward to seeing you tomorrow!" to the greeting
Add the people to your left and right to the greeting



