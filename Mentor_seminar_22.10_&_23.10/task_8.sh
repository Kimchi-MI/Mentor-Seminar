find "$1" -type f -name "*.log" -printf "%TY-%Tm-%Td %TH:%TM:%TS %f\n" | sort -n | head -5

