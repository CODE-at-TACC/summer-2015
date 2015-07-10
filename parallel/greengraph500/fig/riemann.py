#!/usr/bin/env python

import numpy as np
import matplotlib.pyplot as plt


def f(x):
  return 4. / (1 + x**2)


def riemannplot(fct,a,b,n):
  smoothh= (b-a)/100.0
  x = np.arange(a,b+smoothh,smoothh)
  plt.plot(x,fct(x))
  h = (float(b)-float(a))/float(n)
  riemannx = np.arange(a+h/2,b,h)
  riemanny = fct(riemannx)
  plt.bar(riemannx,riemanny,width=h,alpha=0.5,facecolor='orange',align='center')
  plt.xlabel('x')
  plt.xlim([a,b])
  plt.ylabel('f(x)')
  plt.title(r'Riemann Midpoint Sum for $f(x) = \frac{4}{1+x^2}; N =$' + str(n), y=1.02)

  plt.savefig("riemann_" + str(n) + ".png", dpi=300, facecolor='w', edgecolor='w',
  orientation='portrait', papertype=None, format='png',
  transparent=False, bbox_inches='tight', pad_inches=0.1,
  frameon=None)



if __name__ == "__main__":
  riemannplot(f, 0, 1, 10)
