my_name = "Raspberry Pi"
print "My name is " + my_name

your_name = raw_input( "What is your name? " )

# Check to see if your_name was entered
if len( your_name ) == 0:
    # name was not entered
    print "I really really really would like to know your name."
    your_name = raw_input( "What is your name? " )

if  len( your_name ) > len( my_name ) :
    print "Oh, what a long name you have"
elif len( your_name ) < len( my_name ) :        # elif is python for 'else, if'
    print "Oh, what a short name you have"
else:
    print "Your name is the same length as my name"
