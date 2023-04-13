oldifs="${IFS}"
IFS="	"
while read -a myArray
do
  echo ${myArray[3]}
  echo $(echo $aLine | cut -f2)
done < test.txt
IFS="${oldifs}"


