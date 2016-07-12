if [ ! -z $@ ]
  then
    name=$1
    url=$2
    dl=$3
    upd=$4
  else
    source ./update.conf
fi

url="$url$dl"

declare -a shas
declare -a pkgs
declare -a vers

update_ver (){
  counter=0
  for i in ${pkgs[@]} ; do

    cd ${pkgs[$counter]} 2> /dev/null ; if [ "$?" -eq 0 ] ; then

      new_ver=${vers[$counter]}
      sed -i -e "s/pkgver=\${_ver}.*/pkgver=\${_ver}.$new_ver/g" ./PKGBUILD

      old_sha=$(cat PKGBUILD | grep sha1sums= | sed -e 's/sha1sums=//g' | tr -d "''()")
      new_sha=${shas[$counter]}
      sed -i -e "s/$old_sha/$new_sha/g" ./PKGBUILD

    cd ..

    fi

    counter=$((counter + 1))

  done
}

notify_user () {
manipulate $(diff $dl.old $dl | grep '>')
cd $dir
echo "$name was updated" > ./maintain.txt
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

dir=$PWD
cd ~/.cache/notify-$name

if [ "$first_run" == '1' ]
  then wget $url 2> /dev/null ; echo $(sha1sum $dl) > ./sha1
    echo First run
  else wget $url 2> /dev/null
    a=$(cat ./sha1)
    b=$(echo $(sha1sum $dl))
    if [ "$a" == "$b" ]
      then echo Same > ./maintain.txt
      else notify_user
        if [ "$upd" == "yes" ]
          then update_ver
            echo $b > ~/.cache/notify-$name/sha1
            rm ~/.cache/notify-$name/$dl.old
            mv ~/.cache/notify-$name/$dl ~/.cache/notify-$name/$dl.old
          else rm ~/.cache/notify-$name/$dl
        fi
          for i in ${pkgs[@]} ; do
            echo $i >> ./maintain.txt
          done
    fi
fi

if [ "$upd" == "yes" ] && [ ! $(cat ./maintain.txt) = 'Same' ]
  then git-commit -a -m `cat ./maintain.txt`
    git push
fi
