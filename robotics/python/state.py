import time

state = None

def waiting():
    global state
    print "Waiting"
    if touched():
        state = going

def touched():
    if True:
        print "touched"
        return True
    else:
        return False

def going():
    global state
    print "Going"
    if hitTheWall():
        state = waiting

def hitTheWall():
    if True:
        print "hit the wall!"
        return True
    else:
        return False

state = waiting

while True:
    state()
    time.sleep(1)
