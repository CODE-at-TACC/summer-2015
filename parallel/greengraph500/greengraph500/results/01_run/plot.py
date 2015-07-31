#!/usr/bin/env python


import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker


def eat_data(filename):
  filename_list = open(filename,"r").read().split("\n")
  filename_list.pop()

  mean  = dict()
  stdev = dict()
  print "\n\n", "Filename".rjust(20), \
    "Num Procs".rjust(10), \
    "Scale".rjust(10), \
    "TEPS".rjust(10), \
    "STDEV".rjust(10)
  for filename in filename_list:
    num_procs = int(filename.strip(".log").split("_")[1])
    scale     = int(filename.strip(".log").split("_")[2])
    result    = open(filename, "r").readlines()
    for line in result:
      if line.find("harmonic_mean_TEPS:") != -1:
        mean[(num_procs, scale)]  = float(line.strip("\n").split(" ").pop())
      if line.find("harmonic_stddev_TEPS:") != -1:
        stdev[(num_procs, scale)] = float(line.strip("\n").split(" ").pop())

    print filename.rjust(20), \
      str(num_procs).rjust(10), \
      str(scale).rjust(10), \
      str(mean[(num_procs, scale)]).rjust(10), \
      str(stdev[(num_procs, scale)]).rjust(10)

  return mean, stdev


def format_data(mean, stdev):
 
  # Put data in np.array 
  x_data  = np.array([x[1] for x in mean.keys()])
  y_data  = np.array(mean.values())
  sx_data = np.array([x[1] for x in stdev.keys()])
  sy_data = np.array(stdev.values())
  
  # Sort on x data
  x_data_map = x_data.argsort()
  x_data = x_data[x_data_map]
  y_data = y_data[x_data_map]
  sx_data_map = sx_data.argsort()
  sx_data = sx_data[sx_data_map]
  sy_data = sy_data[sx_data_map]

  return x_data, y_data, sy_data


def plot_data(x_list, y_list, s_list, l_list):

  fig = plt.figure()
  ax  = fig.add_subplot(1,1,1)
  plt.grid(which='major',b=True,ls='-',lw=0.5,color='0.65')
  plt.grid(which='minor',b=True,ls='-',lw=0.4,color='0.9')
  color_list  = [ "green", "blue", "red" ]
  marker_list = [ "s", "^", "o" ]
  marker_list = [ "o", "o", "o" ]
  for i in xrange(len(x_list)):
    ax.scatter (x_list[i], y_list[i], marker=marker_list[i], c=color_list[i], label=l_list[i], zorder=(4+len(x_list)-i))
    (_, caps, _) = ax.errorbar(x_list[i], y_list[i], yerr=s_list[i], marker=marker_list[i], c=color_list[i], ls='none', capsize=5, linewidth=2, zorder=(3+len(x_list)-i))
    for cap in caps:
      cap.set_markeredgewidth(1)
   
 
  plt.title("CODE@TACC Monty Pi-thon Raspberry Pi 2 Model B Cluster \n Graph 500 Benchmark Results") 
  ax.set_xlabel("Problem Scale (Powers of Two)")
  ax.set_ylabel("Traversed Edges Per Second (TEPS)") 
  ax.set_yscale('log')
  ax.xaxis.set_major_locator(ticker.MultipleLocator(base=2))
  ax.set_xlim([0,27])
  ax.set_ylim([1E2,5E7])
  plt.legend(loc=4, framealpha=0.5)



  filename = "results.pdf"
  plt.savefig(filename, dpi=300, facecolor='w', edgecolor='w',
  orientation='portrait', papertype=None, format='pdf',
  transparent=False, bbox_inches='tight', pad_inches=0.1,
  frameon=None)
  print "Figure saved to",filename
  
  filename = "results.svg"
  plt.savefig(filename, dpi=300, facecolor='w', edgecolor='w',
  orientation='portrait', papertype=None, format='svg',
  transparent=False, bbox_inches='tight', pad_inches=0.1,
  frameon=None)
  print "Figure saved to",filename

    


if __name__ == "__main__":
#  mean_128, stdev_128 = eat_data("128")
#  mean_64,  stdev_64  = eat_data("64")
  mean_32,  stdev_32  = eat_data("32")

#  x_128, y_128, s_128 = format_data(mean_128, stdev_128)
#  x_64,  y_64,  s_64  = format_data(mean_64, stdev_64)
  x_32,  y_32,  s_32  = format_data(mean_32, stdev_32)

  super_x = [x_32] #, x_64, x_128]
  super_y = [y_32] #, y_64, y_128]
  super_s = [s_32] #, s_64, s_128]
  super_l = ["1 MPI Process Per Pi (32 Total)"] #, "2 MPI Processes Per Pi (64 Total)", "4 MPI Processes Per Pi (128 Total)"]

  plot_data(super_x, super_y, super_s, super_l)

