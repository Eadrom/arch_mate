mkdir aur ; cd aur
for i in `find ../*/ | grep -v .git | grep -v .SRCINFO | grep -v PKGBUILD | grep -v patch | grep -v aur | tr -d './'` ; do git clone git+ssh://aur@aur.archlinux.org/$(echo `echo $i | cut -d '/' -f 7`-1.15-gtk3.git) ; done
for i in `find ../*/ | grep -v .git | grep -v .SRCINFO | grep -v PKGBUILD | grep -v patch | grep -v aur | tr -d './'` ; do cp -r  ../$i/* ./$(echo $i-1.15-gtk3) ; done
cd ..
