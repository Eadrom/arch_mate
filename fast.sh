find ./*/ | grep -v .git | grep -v .SRCINFO | grep -v PKGBUILD | grep -v patch | grep -v aur | grep -v caja-exten > ./list
b='pkgname="${_pkgbase}-${_ver}-gtk3"' ; for i in `cat ./list` ; do a=$(cat $i/PKGBUILD | grep 'pkgname="${_pkgbase}"') ; if [ ! -z $a ] ; then sed -i -e "s/$a/$b/g" $i/PKGBUILD ; fi ; done
b='"' ; c='-1.15-gtk3"' ; for i in caja-extensions-common caja-gksu caja-image-converter caja-open-terminal caja-sendto caja-share ; do sed -i -e "s/$i/$b$i$c/g" ./caja-extensions-common-1.15-gtk3/PKGBUILD ; done ; sed -i -e "s/package_\"/package_/g" ./caja-extensions-common-1.15-gtk3/PKGBUILD ; sed -i -e 's/"()/()/g' ./caja-extensions-common-1.15-gtk3/PKGBUILD
a='>=1.15' ; b='-1.15-gtk3' ; for i in ./*/PKGBUILD ; do sed -i -e "s/$a/$b/g" $i ; done

#gen meta package
a='PKGBUILD' ; for i in ./*/$a ; do echo $i | grep -v meta | sed -e "s/$a//g" | tr -d '/' | sed -e "s/$/'\ /g" | sed -e "s/^./'/g" | tr ' \n' '\\ ' ; done > ./list
a='depends=(' ; b=$(cat ./list) ; sed -i -e "/$a/a $b" mate-meta-1.15-gtk3/PKGBUILD

for i in ./*/ ; do cd $i ; makepkg --printsrcinfo > .SRCINFO ; cd .. ; done
for i in ./*/ ; do cd $i ; git commit -a -m 'auto - see github.com/nicman23/mate_arch' | grep 'To git+ssh' ; git push ; cd .. ; done
