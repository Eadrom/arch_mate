mkdir ../built
for i in `cat ./order` 
  do cd $i ; makepkg -si ; echo $i $? >> ../../built/built.log
  mv *pkg.tar* ../../built  
  makepkg --clean --nobuild --nodeps  --noextract ; rm *.xz
  cd ..
done
