echo "МОНИТОРИНГ РЕСУРСОВ СИСТЕМЫ"

total_memory=$(free | grep Mem: | awk '{print $2}')
used_memory=$(free | grep Mem: | awk '{print $3}')
memory_usage=$(( (used_memory * 100) / total_memory ))

cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)

cpu_usage_int=$(printf "%.0f" "$cpu_usage")

disk_usage=$(df / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

echo "Текущее состояние системы:"
echo "Память: ${memory_usage}%"
echo "CPU: ${cpu_usage}%"
echo "Диск: ${disk_usage}%"

if [ $memory_usage -gt 80 ]; then
    echo "Использование памяти высокое!"
    echo "Топ-5 процессов по памяти:"
    ps aux --sort=-%mem | head -6
fi


