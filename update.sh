
if [ ! -z $@ ]
  then
    if [ -e $@ ]
      then
        source $@
      else
        name=$1
        url=$2
        dl=$3
        upd=$4
      fi
  else
    source ./update.conf
fi

url="$url$dl"

declare -a shas
declare -a pkgs
declare -a vers
dir=$PWD

update_ver (){
  cd $dir

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

if [ "$counter" -gt 1 ] ; then
  export copular_verb='were'
else
  export copular_verb='was'
fi

}

notify_user () {
counter=0

for i in ${pkgs[@]} ; do
  echo $i'	' "${shas[$counter]}" >> $dir/maintain.txt
  counter=$((counter + 1))
done

}

mod_pkg () {
new_pkg=$(echo $@ | tr -d '[:digit:].' | sed -e 's/-tarxz//g')
pkgs=( ${pkgs[@]} $new_pkg )

new_ver=$(echo $@ | tr -d '[:alpha:]-' | cut -d '.' -f 3)
vers=( ${vers[@]} $new_ver )
}

manipulate () {
hackyhack=$(echo $@ | tr -d ' >')

if [ -z $hackyhack ]
  then echo Same
    rm ~/.cache/notify-$name/$dl
    exit 2
fi

echo "$name was updated" > $dir/maintain.txt

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
  then wget $url 2> /dev/null
    echo First run
    mv ~/.cache/notify-$name/$dl ~/.cache/notify-$name/$dl.old
    exit 3
fi

wget $url 2> /dev/null

manipulate $(diff ~/.cache/notify-$name/$dl.old ~/.cache/notify-$name/$dl | grep '>')

if [ "$upd" == "yes" ]
  then update_ver
    rm ~/.cache/notify-$name/$dl.old
    mv ~/.cache/notify-$name/$dl ~/.cache/notify-$name/$dl.old
    echo Will commit
    git commit -a -m "$(echo ${pkgs[@]}) $copular_verb updated"
#    git push
  else rm ~/.cache/notify-$name/$dl
fi

notify_user
cat $dir/maintain.txt
