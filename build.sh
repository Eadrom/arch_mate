for i in `cat ./order` ; do cd $i ; makepkg -si ; cd .. ; done
