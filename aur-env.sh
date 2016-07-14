mkdir aur ; cd aur
find ../*/ | grep -v mate-themes | grep -v .git | grep -v .SRCINFO | grep -v PKGBUILD | grep -v patch | grep -v aur | tr -d './' > ./list
for i in `cat list` ; do git clone git+ssh://aur@aur.archlinux.org/$(echo `echo $i | cut -d '/' -f 7`-1.15-gtk3.git) ; done
for i in `cat list` ; do cp -r  ../$i/* ./$(echo $i-1.15-gtk3) ; done 
git clone git+ssh://aur@aur.archlinux.org/mate-themes-3.20-gtk3.git ;  cp ../mate-themes/* ./mate-themes-3.20-gtk3
#sh ../fast.sh
