mate_ver=1.15
theme_ver=3.20
declare -a list
declare -a aurlist

temp=$(find ./*/ -maxdepth 0 | grep -v mate-themes | grep -v caja-extensions | grep -v aur | tr -d ./)

for i in $(echo $temp)
 do list=(${list[@]} $i)
done

mkdir aur &> /dev/null ; if [ "$?" = '0' ]
then
  cd aur
  for i in ${list[@]} caja-extensions-common ; do git clone git+ssh://aur@aur.archlinux.org/$i-$mate_ver-gtk3.git ; done
  git clone  git+ssh://aur@aur.archlinux.org/mate-themes-$theme_ver-gtk3.git
else
  cd aur
fi

for i in ${list[@]} caja-extensions-common ; do cp -r  ../$i/* ./$i-$mate_ver-gtk3/ ; done
cp ../mate-themes/* ./mate-themes-$theme_ver-gtk3/


for i in ${list[@]}
  do aurlist=(${aurlist[@]} $i-$mate_ver-gtk3)
done

aurlist=(${aurlist[@]} mate-themes-$theme_ver-gtk3)

b='pkgname="${_pkgbase}-${_ver}-gtk3"'
c='>=1.15'
d='-1.15-gtk3'
for i in ${aurlist[@]}
  do a=$(cat $i/PKGBUILD | grep 'pkgname="${_pkgbase}"') ; if [ ! -z $a ]
    then sed -i -e "s/$a/$b/g" $i/PKGBUILD
  fi
  sed -i -e "s/$c/$d/g" $i/PKGBUILD
done

a='caja>=1.15' ; b='caja-1.15-gtk3' ; sed -i -e "s/$a/$b/g" ./caja-extensions-common-1.15-gtk3/PKGBUILD

a='-1.15-gtk3' ; b='>=1.15' ;
for i in 'caja-extensions-common' 'caja-gksu' 'caja-image-converter' 'caja-open-terminal' 'caja-sendto' 'caja-share' ; do
  sed -i -e "s/$b//g" ./caja-extensions-common-1.15-gtk3/PKGBUILD
  sed -i -e "s/$i/$i$a/g" ./caja-extensions-common-1.15-gtk3/PKGBUILD
  sed -i -e "s/$i$a-gtk3/$i' '$i-gtk3/g" ./caja-extensions-common-1.15-gtk3/PKGBUILD
done

#gen meta package
a='depends=(' ; b=$(echo ${aurlist[@]/mate-meta-1.15-gtk3} caja-extensions-common-1.15-gtk3)
sed -i -e "/$a/a $b" mate-meta-1.15-gtk3/PKGBUILD

status() {
  if [ -z "$(git status -s)" ]
    then return 0
    else return 1
  fi
}

for i in ./*/
  do cd $i
    status ; if [ "$?" = '1' ]
    then
      echo "Commiting changes in $(echo $i | sed -e "s/-1.15-gtk3\///g" | sed -e "s/.\///g")"
      makepkg --printsrcinfo > .SRCINFO
      git commit -a -m 'auto - see github.com/nicman23/mate_arch' &> /dev/null
      git push &> /dev/null
    fi
  cd ..
done

