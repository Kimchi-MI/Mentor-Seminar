TARGET_DIR="/c/Users/Admin/Desktop/MY/Учеба/ВШЭ/Bash/Howe_work/H_W_Topic_4"
LOG_FILE="$HOME/logs"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

create_folder() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        log_message "Создана папка: $1"
    fi
}

move_files() {
    local extension="$1"
    local target_folder="$2"
    local file_type="$3"
    
    for file in "$TARGET_DIR"/$extension; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            mv "$file" "$TARGET_DIR/$target_folder/"
            log_message "$file_type: $filename -> $target_folder/"
        fi
    done
}

log_message "Старт сортировки $TARGET_DIR"

if [ ! -d "$TARGET_DIR" ]; then
    log_message "Папка $TARGET_DIR не существует!"
    echo "Папка $TARGET_DIR не найдена!"
    exit 1
fi

create_folder "$TARGET_DIR/Images"
create_folder "$TARGET_DIR/Documents"

log_message "Сортировка картинок..."
move_files "*.jpg" "Images" "Картинка"
move_files "*.png" "Images" "Картинка" 
move_files "*.gif" "Images" "Картинка"

log_message "Сортировка документов..."
move_files "*.txt" "Documents" "Документ"
move_files "*.pdf" "Documents" "Документ"
move_files "*.docx" "Documents" "Документ"

log_message "Сортировка завершена"

echo "Сортировка завершена!"
echo "Проверь папки Images и Documents"
echo "Логи в файле: $LOG_FILE"
