answer=$(curl -s "https://api.telegram.org/bot8215181843:AAGF_Ul9C0AIIhkI_c2TpT2HNhOx5xp6Oe0/getUpdates")
l_m=$(echo "$answer" | grep -o '"text":"[^"]*"' | tail -1 | cut -d'"' -f4)  

if [ "$l_m" = "date" ]; then
        current_date=$(date +"%Y-%m-%d %H:%M:%S")
	curl -s -X POST "https://api.telegram.org/bot8215181843:AAGF_Ul9C0AIIhkI_c2TpT2HNhOx5xp6Oe0/sendMessage" -d chat_id="832509486" -d text="$current_date"
fi
