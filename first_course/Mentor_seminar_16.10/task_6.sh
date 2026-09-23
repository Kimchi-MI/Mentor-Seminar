echo "Введите имя директории"
read directory

if [ ! -d "$directory" ]; then
    echo "Директория не найдена"
    exit 1
fi

echo "Файлы для удаления (старше 7 дней):"
find "$directory" -type f -mtime +7 -print

read -p "Удалить эти файлы? (y/n): " confirm

if [ "$confirm" = "y" ]; then
    find "$directory" -type f -mtime +7 -delete
    echo "Файлы удалены"
else
    echo "Удаление отменено"
fi

