import numpy as np
import matplotlib.pyplot as plt


fig = plt.figure(figsize=(3,3))

ax = plt.gca()
ax.spines['left'].set_position('center')
ax.spines['right'].set_color('none')
ax.spines['bottom'].set_position('center')
ax.spines['top'].set_color('none')
ax.spines['left'].set_smart_bounds(True)
ax.spines['bottom'].set_smart_bounds(True)
ax.xaxis.set_ticks_position('bottom')
ax.yaxis.set_ticks_position('left')
plt.xlim((-10,10))
plt.ylim((-10,10))

fig = plt.figure(figsize=(3,3))
ax = plt.gca()
#ax.spines['left'].set_position('center')
ax.spines['right'].set_color('none')
ax.spines['bottom'].set_color('none')
ax.spines['left'].set_smart_bounds(True)
ax.spines['top'].set_smart_bounds(True)
ax.xaxis.set_ticks_position('top')
ax.yaxis.set_ticks_position('left')
ax.invert_yaxis()
plt.xlim((0,20))
plt.ylim((20,0))

plt.show()