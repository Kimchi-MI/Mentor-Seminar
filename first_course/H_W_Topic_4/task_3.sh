echo "Введите целое число"
read x

if [ "$x" -gt 0 ]; then
    echo "Число положительное"
    
    i=1
    while [ "$i" -le "$x" ];
    do
        echo "$i"
        ((i++))
    done
    
elif [ "$x" -lt 0 ]; then
    echo "Число отрицательное"
else
    echo "Число равно нулю"
fi
