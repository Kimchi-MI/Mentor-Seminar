echo "Введите имя файла"
read name

if [ ! -f "$name" ]; then
	echo "Файл не найден"
	exit 1 
fi

line_count=$(wc -l < "$name")

echo "Колличество строк в файле $name: $line_count"
