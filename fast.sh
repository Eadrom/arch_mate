for i in ../*/ ; do cp -r  $i/* ./$(echo `echo $i | cut -d '/' -f 7`-1.15-gtk3) ; done
b='pkgname="${_pkgbase}-${_ver}-gtk3"' ; for i in `cat ../list' ; do a=$(cat $i/PKGBUILD | grep 'pkgname="${_pkgbase}"') ; if [ ! -z $a ] ; then sed -i -e "s/$a/$b/g" $i/PKGBUILD ; fi ; done
b='"' ; c='-1.15-gtk3"' ; for i in caja-extensions-common caja-gksu caja-image-converter caja-open-terminal caja-sendto caja-share ; do sed -i -e "s/$i/$b$i$c/g" ./caja-extensions-1.15-gtk3/PKGBUILD ; done ; sed -i -e "s/package_\"/package_/g" ./caja-extensions-1.15-gtk3/PKGBUILD ; sed -i -e 's/"()/()/g' ./caja-extensions-1.15-gtk3/PKGBUILD
a='>=1.15' ; b='-1.15-gtk3' ; for i in ./*/PKGBUILD ; do sed -i -e "s/$a/$b/g" $i ; done
for i in ./*/ ; do echo $i ; cd $i ; makepkg --printsrcinfo > .SRCINFO ; git commit -a -m 'loop' ; git push ; cd .. ; done
