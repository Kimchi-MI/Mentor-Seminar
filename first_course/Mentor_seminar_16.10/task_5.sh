echo "Введите путь к директории"
read name

if [ ! -d "$name" ]; then
    echo "Директории не существует"
    exit 1
fi

for file in "$name"/*
do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        mv "$file" "$name/backup_$filename"
    fi
done


