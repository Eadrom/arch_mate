mkdir ../built
for i in `cat ./order`
  do a=$(($a+1))
done

for i in `cat ./order` 
  do cd $i ; echo building $i , $a left to build
  makepkg -si --noconfirm > /dev/null 2> /dev/null ; echo $i $? >> ../../built/built.log
  mv *pkg.tar* ../../built  
  makepkg --clean --nobuild --nodeps  --noextract > /dev/null 2> /dev/null ; rm *.xz
  cd ..
  a=$(($a-1))
done
