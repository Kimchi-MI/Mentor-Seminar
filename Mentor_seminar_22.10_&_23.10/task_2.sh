fn=$1
sn=$2
if [ "$1" -gt "$2" ]; then
  echo "$1 больше чем $2"
elif [ "$1" -lt "$2" ]; then
  echo "$1 меньше чем $2"
else
  echo "Числа равны"
fi
