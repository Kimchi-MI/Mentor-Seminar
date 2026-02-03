echo "Введите имя файла"
read name
if [ -f "$name" ]; then
echo "Файл найден."
else
echo "Файл не найден."
fi
