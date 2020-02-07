#!/bin/bash

rm -R romart
rm -R png

cd assets

root=$PWD
width=128
bar="⣿"
rm -R romart
rm -R png
systems=($(ls -F | grep /))
mkdir romart
mkdir png

echo "--------------------------------------------------------------------------"
echo -e "root -> ${root}"
echo "--------------------------------------------------------------------------"
for system in "${systems[@]}"
do
  system="${system%?}";
  cd $system;
  total=($(ls -l | grep -v ^l | wc -l))
  echo "$system - has $total files";

  mkdir "${root}/png/${system}"
  mkdir "${root}/romart/${system}"

  complete=0
  percent=0
  calc=0
  find . -type f -name "*.png" -print0 | while IFS= read -r -d '' file;
  do
    bars=""
    complete=$((complete+1))
    calc=$(( (100 * complete / total + (1000 * complete / total % 10 >= 5 ? 1 : 0)) / 2 ))

    if [ "$calc" -gt "$percent" ];then
      clear
      percent=$calc
      for (( i=0; i<$percent; ++i)); do
        bars="${bars}${bar}"
      done
      echo "--------------------------------------------------------------------------"
      echo -e "Converting -> ${system}  files: ${complete}/${total}"
      echo "$((percent * 2 ))% ${bars}"
      echo "--------------------------------------------------------------------------"
    fi

    convert "${file}" -resize ${width} "${root}/png/${system}/${file}"
  done


  cd $root
done

cp -r png ../png
cp -r romart ../romart
rm -R png
rm -R romart
