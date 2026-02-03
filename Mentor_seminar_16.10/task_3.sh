echo "Введите путь к директории"
read path
if [ -d "$path" ]; then
    date=$(date "+%Y-%m-%d")
    echo "Создаем архив: ${path}_${date}.tar.gz"
    tar -czf "${path}_${date}.tar.gz" "$path"
    echo "Архив успешно создан!"
else
    echo "Директория не найдена"
fi

