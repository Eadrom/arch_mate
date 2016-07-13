mkdir aur ; cd aur
for i in ../*/ ; do git clone git+ssh://aur@aur.archlinux.org/$(echo `echo $i | cut -d '/' -f 7`-1.15-gtk3.git) ; done
