Introducing Python
==================

Python is a language for computer scripts.  It can be run on practically any computer.

Python is easy to learn, and plays well with others.

Python, when given a text file as input, will “execute” the actions described in the text file.

#### Objectives
1. Read Python scripts
2. Run Python scripts
3. Edit Python scripts
4. Love Python scripts (extra credit)



## Let's start at the very beginning

When learning a new language, the first word learned is often “Hello”.  Similarly, when learning a new computer language, the first computer program written is “Hello world!” This is a computer program that, when run, will print to the screen the words “Hello world!”

![Hello world!](images/HelloWorld.png)

In Python, writing this first program is very simple and a very good place to start. It uses the keyword **print**

```print "Hello world!"```

***Notice!*** Python recognizes the difference between uppercase and lowercase.  **print** is a keyword, however *Print* and *PRINT* are not keywords in Python.

#### Challenge

Use Python to say hello to the person on your right.  For convenience, you already have the scripts.  

1. Open the file *1_hello_world.py* in Leafpad.
2. Make you change and save the file.
3. To run the script, type *python 1_hello_world.py* into the terminal

#### What you learned

1. How to use the keyword **print**.
2. How to view, edit, and run a Python script.
3. Python is case-sensitive.



## This time with variables

In algebra, you learned that a **variable** is a quantity that can change within the context of a mathematical problem, and is represented by a single letter.  For example, x = 3 + y.

In programming, *information* can be assigned to a **variable**, and variables are identified by one or more letters.

Let us take a look at Hello world again, this time with variables.

```
greeting = "Hello"

name = "world"

salutation = greeting + " " + name + "!"

print salutation
```


*greeting* is assigned the information "Hello" using the **=** symbol.

*name* is assigned the information "world”.

The quotes indicate that the type of the information is a **string**.  A string is a list of characters such as numbers, letters, and symbols.

Then, *salutation* is assigned the combination of *greeting*, a space, *name*, and an exclamation mark.

Multiple strings can be combined into one string using the plus symbol, **+**

Finally, the information in *salutation* is printed to the screen.

***Notice!*** Computer scripts execute from top to bottom, just like we read text.  Importantly, variables should be assigned information before a script asks for the information with the variable.


#### Challenge

Use *2_hello_world_again.py* to say hello to the person on your left by changing the information stored in  *name*

#### What you learned

1. How to assign information to a variable.
2. What a **string** is.
3. How to combine strings.
4. A script reads and runs from top to bottom
5. A variable needs to associate with information before using the variable


## Putting the “fun” into function

When performing essentially the same set of actions repeatedly, you can create a *function* for these set of actions. Because computers are generally used to perform repeated tasks, we are almost always creating a lot of functions.

![Function meme](images/FunctionAllTheThings.jpg)

Functions in Python always start with the keyword **def** which is short for define, followed by the name of the function.  Defining a function does not cause it to run.  It just lets Python know what to do when the function is run.  Functions have to be defined before being called upon to run.


```
def greet( name ):
    print "Hello " + name + "!"
    print "Nice to see you."
    print "Thank you for coming to CODE@TACC."

greet( "world" )
greet( "friend" )
```

***Notice!*** The print statements are part of the function *greet*, and they are indented using **4 spaces**.  Python relies on indenting to determine which lines are part of the function.  

Now when the function *greet* is called with the input "world", the variable *name* is given the information "world".

Less coding, less editing, more reliable.

#### Challenge

Add "I look forward to seeing you tomorrow!" to the greeting.

Also greet the people to your left and right.

#### What you learned

1. Functions are used for any task that is repeated.
2. How to define a function in Python.
3. How to send information to a function.
4. Functions need to be defined before being called upon.





## I got a blank space and I’ll write your name

Functions not only perform tasks, but can be used to **return** results.  Using the keyword **return** in a function will cause information to output from the function.  

![Function machine](images/FunctionMachine.png)

In this example, the function *get_name* outputs the information of the variable *result*

```
def get_name():
    result = raw_input( "What is your name? ")
    return result

def greet( name ):
    print "Hello " + name + "!"

your_name = get_name()

greet( your_name )
```

***Notice!*** The keyword **return** will cause the function to stop.

Also note that the function *get_name* has no input.  

The variable *result* is assigned the information that you type in when prompted by the built-in function **raw_input**.

**raw_input** lets you enter information into a variable using your keyboard while the script is running.

#### Challenge

1. Create a function called *get_favorite_color* that uses **raw_input** and returns a string.
2. Incorporate this string into the function *greet*.

#### What you learned

1. Functions can return information.
2. A function will end if it performs a **return**. 
3. **raw_input** allows input from keyboards


## Basic math

Raspberry Pi is good at math.

Go ahead and run the script: *python 5_math.py*

```
print ""
print "Basic Math Operations"
print ""
print "4 + 3 is " + str( 4 + 3 )        # Addition, 4 plus 3
print "4 - 3 is " + str( 4 - 3 )        # Subtraction, 4 minus 3
print ""
print "4 * 3 is " + str( 4 * 3 )        # Multiplication, 4 times 3
print "4 ** 3 is " + str( 4 ** 3 )      # Exponentiation, 4 to the 3rd power
print ""
print "4 / 3 is " + str( 4 / 3 )        # Division, 4 divided by 3. Rounds down to integer
print "4 % 3 is " + str( 4 % 3 )        # Modulo, remainder of 4 divided by 3
print ""
print "4.0 / 3 is " + str( 4.0 / 3 )	# Division, 4 divided by 3, not rounded
print ""
# your_number = raw_input( "Enter a number: " )     
# answer = float( your_number ) * 3 + 2
# print "Your result is " + str( answer )
```

***Notice!*** The **#** symbol indicates that the following text in the line should be ignored.  One use of this is to add a comment to the script that helps explain the script to others.  Another use of **#** is to disable specific lines of the script.

***Notice!*** A number must be converted into a string using build-in function **str** before being combined with a string.  Convert a string to an integer using **int** and to a decimal using **float**.

If you are working with integers, Python keep answers as integers by rounding down. To force Python to use decimals, put decimals into your numbers.

#### Challenge

Enable the last 3 lines of the script and run it again.

#### What you learned

1. Using Python to do basic math.
2. How to force Python to use decimals in calculations.
3. How to use comments
4. Converting numbers into strings, and strings into numbers.


## To be or not to be

![Calvin Hamlet](images/CalvinHamlet.png)

Run the script: *python 6_comparisons.py*

```
print ""
print "Comparisons"
print ""
print "4 > 3 is " + str( 4 > 3 )	# 4 greater than 3
print "4 < 3 is " + str( 4 < 3 )	# 4 less than 3
print "4 == 3 is " + str( 4 == 3 )      # 4 equal to 3
print "4 >= 3 is " + str( 4 >= 3 )      # 4 greater than or equal to 3
print "4 <= 3 is " + str( 4 <= 3 )      # 4 less than or equal to 3
print "4 != 3 is " + str( 4 != 3 )	# 4 not equal to 3
print ""
print "Boolean Operators - not, and, or"
print ""
print "not True is " + str( not True )
print "not False is " + str( not False )
print ""
print "True and True is " + str( True and True )
print "True and False is " + str( True and False )
print "False and False is " + str( False and False )
print ""
print "True or True is " + str( True or True )
print "True or False is " + str( True or False )
print "False or False is " + str( False or False )
print ""
print "not ( False or (False and True) ) is " + str( not ( False or (False and True) ) )
```

***Notice!*** Capitalize the first letter of **True** and **False**.

Knowing if something is True or False can be useful when making decisions, as we will see in the next section.

####  What you learned

1. How comparisons and boolean operators evaluate.



## If, elif, else

Now that we know how to compare, we can evaluate situations and take different actions accordingly.

In this example, we use the built-in function **len** that returns the number of characters in a string.

```
my_name = "Raspberry Pi"
print "My name is " + my_name

your_name = raw_input( "What is your name? " )

# Check to see if your_name was entered
if len( your_name ) == 0:
    # name was not entered
    print "I really would like to know your name."
    your_name = raw_input( "What is your name? " )

# Compare length of your_name to my_name
if  len( your_name ) > len( my_name ) :
    print "Oh, what a long name you have"
elif len( your_name ) < len( my_name ) :        # elif is python for 'else, if'
    print "Oh, what a short name you have"
else:
    print "Your name is the same length as my name"
```

***Notice!*** You can have up to 1 **else** with an **if**. You can have as many **elif** as your need.

#### What you learned

1. How to use **if**, **elif**, and **else**.
2. What **len** does with strings


## I really really really really really really really like loops

Computers can do the same task over and over and never get bored.  Python has two types of loops: **for** loops and **while** loops.

![Rollercoaster](images/Rollercoaster.gif)


```
# range( ) creates a list of integers starting at 0
print range( 10 )
print ""

# 'for' sets a variable to each value in a list
for x in range( 5 ):
    print "x = " + str(x)

print ""

# 'while' will repeat as long as its condition is True
x = 5
while x > 0:
    print "x = " + str(x)
    x = x - 1

print ""

# Putting it together

haters_gonna_hate = True

shakes=0

print "I'm just gonna..."

while haters_gonna_hate:
    print "shake"
    shakes = shakes + 1
    if shakes >= 5:
        haters_gonna_hate = False
```

#### Challenge 

Python treats strings as a list of characters.  What would you expect the following script to do?

```
your_name = raw_input( "What is your name? ")
for each_character in your_name:
    print each_character
```

#### What you learned

1. How to generate a list of numbers using **range**
2. How to use **for** loops
3. How to use **while** loops


## The end is near

While Python has many built-in functions like **range** and **len**, one can using keyword **import** to bring in even more functions. The keyword **from** can be used with **import**.

Functions have different *methods* that you can access, as seen in the script below.

```
# get direct access to the datetime library
from datetime import datetime

current_time = datetime.now()

print "The year is " + str( current_time.year )
print "The month is " + str( current_time.month )
print "The day is " + str( current_time.day )
print "The hour is " + str( current_time.hour )
print "The minute is " + str( current_time.minute )
print "The second is " + str( current_time.second )

# you can *import* with this style that does not use *from*
import time

print "Going to sleep for 5 seconds....Zzzzzzz"

start_time = time.time()    # time.time() returns the number of seconds since Jan 1, 1970
time.sleep(5)               # waits 5 seconds
stop_time = time.time()

nap_time = stop_time - start_time

print "I actually slept for " + str( nap_time ) + " seconds."
```

#### What you learned

1. Accessing more functions using **import**
2. How to measure time elapsed
3. How to add a delay to your script

![The End is Near](images/the_end_is_near.png)





