file="$1"
last=$(stat -c %Y "$file")

while true; do
    current=$(stat -c %Y "$file")
    if [ "$current" -ne "$last" ]; then
        echo "Файл $file изменен"
        last=$current
    fi
    sleep 1
done

