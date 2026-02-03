echo "Введите сообщение"
read sms
curl -s "https://api.telegram.org/bot8215181843:AAGF_Ul9C0AIIhkI_c2TpT2HNhOx5xp6Oe0/getUpdates"
curl -s -X POST "https://api.telegram.org/bot8215181843:AAGF_Ul9C0AIIhkI_c2TpT2HNhOx5xp6Oe0/sendMessage" -d chat_id="832509486" -d text="$sms"
