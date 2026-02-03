SOURCE_DIR="/c/Users/Admin/Desktop/MY/Учеба/ВШЭ/Bash/Howe_work/Mentor_seminar_12.11"
ARCHIVE_NAME="backup_$(date +"%Y%m%d_%H%M%S").tar.gz"
REMOTE_USER="root"
REMOTE_HOST="172.17.0.2"
REMOTE_DIR="/tmp"
KEEP_COUNT=3

echo "=== Начало резервного копирования ==="

# Создаем архив папки
echo "Создаем архив папки: $SOURCE_DIR"
tar -czf "$ARCHIVE_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# Копируем на удаленный сервер по SSH
echo "Копируем архив на удаленный сервер..."
scp "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"

# Удаляем старые архивы на удаленном сервере
echo "Удаляем старые архивы (оставляем $KEEP_COUNT последних)..."
ssh "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_DIR && ls -1t backup_*.tar.gz 2>/dev/null | tail -n +$(($KEEP_COUNT + 1)) | xargs -r rm -f"
