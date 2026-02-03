alias ll='ls -la'
echo "alias ll='ls -la'" >> ~/.bashrc


echo "Применяем изменения"
source ~/.bashrc

echo "Проверяем работу alias:"
ll

echo ""
echo "Объяснение:"
echo "Alias добавлен в ~/.bashrc, который выполняется при каждом запуске терминала"

