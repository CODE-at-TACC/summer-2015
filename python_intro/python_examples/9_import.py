import time                 # imports functions from a library called time

print "Going to sleep for 5 seconds....Zzzzzzz"

start_time = time.time()    # time.time() returns the number of seconds since Jan 1, 1970
time.sleep(5)               # waits 5 seconds
stop_time = time.time()

nap_time = stop_time - start_time

print "I actually slept for " + str( nap_time ) + " seconds."
