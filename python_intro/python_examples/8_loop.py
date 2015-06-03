# range( ) creates a list of numbers starting at 0
print range(10)
print ""

# 'for' sets a variable to each value in a list
for x in range(5):
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
