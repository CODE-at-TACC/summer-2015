---
---
Taking Screenshots with Scrot
=============================

1. Install Scrot

```
sudo apt-get install scrot
```

2. Create the following alias in either your .bashrc or .bash_aliases file

```
alias sc='mkdir -p ~/images/ && scrot "%Y-%m-%d_\$wx\$h_scrot.png" -t 25 -c -d 5 -u -e "mv \$f ~/images/ &&  mv \$m ~/images/"'
```

3. Type *sc* into any Terminal window, then select the window you want to capture. Scrot will display a countdown in the originating Terminal window (5 sec) then capture the image. The image and its thumbnail will be delivered to your ~/images/ directory.



