def get_name():
    result = raw_input( "What is your name? ")
    return result

def greet( name ):
    print "Hello " + name + "!"

your_name = get_name()

greet( your_name )
