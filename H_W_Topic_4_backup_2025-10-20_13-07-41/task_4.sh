hello() {
    echo "Hello, $1"
}

sum() {
    local result=$(( $1 + $2 ))
    echo $result
}

echo "Функция 1"
read -p "Введите ваше имя" name
hello "$name"

echo ""
echo "Функция 2"
read -p "Введите первое число" num1
read -p "Введите второе число" num2
result1=$(sum "$num1" "$num2" )
echo "Сумма $num1 + $num2 = $result1"



 
