export name=$1
url="$2""SHA1SUMS"
upd=$3

declare -a shas
declare -a pkgs
declare -a vers

update_ver (){
  counter=0
  cd ~/arch_mate/
  echo ${pkgs[@]}

  for i in ${pkgs[@]} ; do
    cd ${pkgs[$counter]}

    new_ver=${vers[$counter]}
    sed -i -e "s/pkgver=\${_ver}.*/pkgver=\${_ver}.$new_ver/g" ./PKGBUILD

    old_sha=$(cat PKGBUILD | grep sha1sums= | sed -e 's/sha1sums=//g' | tr -d "''()")
    new_sha=${shas[$counter]}
    sed -i -e "s/$old_sha/$new_sha/g" ./PKGBUILD

    cd ..
    counter=$((counter + 1))
  done
}

notify_user () {
echo "$name was updated" >> ~/maintain.txt
manipulate $(diff SHA1SUMS.old SHA1SUMS | grep '>')
}

mod_pkg () {
new_pkg=$(echo $@ | tr -d '[:digit:].' | sed -e 's/-tarxz//g')
pkgs=( ${pkgs[@]} $new_pkg )

new_ver=$(echo $@ | tr -d '[:alpha:]-' | cut -d '.' -f 3)
vers=( ${vers[@]} $new_ver )
}

manipulate () {
while true; do
  case $1 in
    ''		) break ;;
    '>'		) shift ;;
    *-*		) mod_pkg $1 ; shift ;;
    *		) shas=( ${shas[@]} $1 ) ; shift ;;
  esac
done 
}

if [ ! -e ~/.cache/notify-$name ] ; then mkdir ~/.cache/notify-$name
  first_run=1 ; fi

cd ~/.cache/notify-$name

if [ "$first_run" == '1' ]
  then wget $url 2> /dev/null ; echo $(sha1sum SHA1SUMS) > ./sha1
  else mv SHA1SUMS SHA1SUMS.old
    wget $url 2> /dev/null
    a=$(cat ./sha1)
    b=$(echo $(sha1sum SHA1SUMS))
    if [ "$a" == "$b" ]
      then echo Same
      else notify_user 
        if [ "$upd" == "yes" ]
          then update_ver
          else echo ${pkgs[@]}
        fi
        echo $b > ./sha1
  fi
  rm SHA1SUMS.old
fi

