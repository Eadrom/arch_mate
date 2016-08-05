ver=$@

for i in */PKGBUILD ; do
  if [ ! -z $(cat $i | grep "_ver=$ver") ] ; then
    echo $i > temp.txt
  fi
done
