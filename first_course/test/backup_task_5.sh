echo "Введите путь к директории"
read name

if [ ! -d "$name" ]; then
    echo "Директории не существует"
    exit 1
fi

echo "Работаем с директорией: $name"
echo "Содержимое до обработки:"
ls -la "$name"

for file in "$name"/*
do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Переименовываем: $file в $name/backup_$filename"
        mv "$file" "$name/backup_$filename"
    fi
done

echo "Содержимое после обработки:"
ls -la "$name"

