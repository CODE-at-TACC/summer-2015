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
