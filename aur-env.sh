mate_ver=1.15
theme_ver=3.20

mkdir aur ; cd aur
find ../*/ | grep -v mate-themes | grep -v .git | grep -v .SRCINFO | grep -v PKGBUILD | grep -v patch | grep -v aur | tr -d './' > ./list
for i in `cat list` ; do git clone git+ssh://aur@aur.archlinux.org/$(echo `echo $i | cut -d '/' -f 7`-$mate_ver-gtk3.git) ; done
for i in `cat list` ; do cp -r  ../$i/* ./$(echo $i-$mate_ver-gtk3) ; done
#git clone git+ssh://aur@aur.archlinux.org/mate-themes-$theme_ver-gtk3.git ;  cp ../mate-themes/* ./mate-themes-$theme_ver-gtk3
git clone git+ssh://aur@aur.archlinux.org/mate-themes-$theme_ver-gtk3.git ;  cp ../mate-themes/* ./mate-themes-$theme_ver-gtk3
sh ../fast.sh
