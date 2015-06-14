def get_name():
    typed_name = raw_input( "What is your name? ")
    return typed_name

def greet( name ):
    print "Hello " + name + "!"

your_name = get_name()

greet( your_name )
