echo "Читаем данные из input.txt:"
cat input.txt

echo ""
echo "Подсчитываем строки и записываем в output.txt:"
wc -l input.txt >> output.txt

echo ""
echo "Записываем ошибки в error.log:"
ls fake.txt 2> error.log

echo ""
echo "Проверяем результаты:"
echo "Содержимое output.txt:"
cat output.txt
echo "Содержимое error.log:"
cat error.log
