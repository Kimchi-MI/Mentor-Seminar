ping -c1 "$1" &>/dev/null && echo "$1 доступен" || echo "$1 недоступен"
