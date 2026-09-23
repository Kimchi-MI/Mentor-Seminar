echo "Список всех файлов и их типов:"
file *

if [ -f "$1" ]; then
	echo "Файл есть"
else
	echo "Файла нет"
fi 


for file in *
do
	echo "Файл: $file"
	ls -l "$file"
done
