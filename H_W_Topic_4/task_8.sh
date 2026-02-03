log_file="backup.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
}

echo "Введите путь к директории:"
read source_dir

if [ -z "$source_dir" ]; then
    log_message "Директория не введена"
    exit 1
fi

if [ ! -d "$source_dir" ]; then
    log_message "Директория '$source_dir' не существует"
    exit 1
fi

current_date=$(date +"%Y-%m-%d")
current_time=$(date +"%H-%M-%S")
log_message "Начало резервного копирования директории: $source_dir"

backup_dir="${source_dir}_backup_${current_date}_${current_time}"

if mkdir -p "$backup_dir"; then
    log_message "Создана директория для бэкапа: $backup_dir"
else
    log_message "Не удалось создать директорию $backup_dir"
    exit 1
fi

if cp -r "$source_dir"/* "$backup_dir"/ 2>/dev/null; then
    log_message "Копирование файлов завершено успешно"
else
    log_message "Возникли ошибки при копировании некоторых файлов"
fi

file_count=$(find "$backup_dir" -type f | wc -l)

log_message "Резервное копирование завершено УСПЕШНО"
log_message "Скопировано файлов: $file_count"
log_message "Резервная копия сохранена в: $backup_dir"
log_message "Логи сохранены в: $log_file"
log_message "=========================================="

echo "=== РЕЗЕРВНОЕ КОПИРОВАНИЕ ЗАВЕРШЕНО ==="
echo "Директория: $source_dir"
echo "Резервная копия: $backup_dir"
echo "Скопировано файлов: $file_count"
echo "Логи: $log_file"

