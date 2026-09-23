greet() {
    echo $(($1 + $2))
}

echo "Введите число №1"
read num1
echo "Введите число №2"
read num2

result=$(greet $num1 $num2)
echo "Сумма двух чисел: $result"
