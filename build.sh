mkdir ../built
for i in `cat ./order` 
  do cd $i ; makepkg -si 
  makepkg --clean --nobuild --nodeps  --noextract
  mv *pkg.tar* ../../built  
  cd ..
done
