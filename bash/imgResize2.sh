cd "$1"
smallDirName="small$(basename $1)"
mkdir "${smallDirName}"
for picture in *.jpg
  do convert "${picture}[640x480]" "${smallDirName}/${picture}"
done
cd "${smallDirName}"
montage -tile 5 -geometry +4+4 -label "$1" -pointsize 10 -quality 30 "*.jpg[160x120]" _index.jpg

