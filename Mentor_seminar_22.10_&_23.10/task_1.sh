filename=$1
search_word=$2
grep -o -w "$2" "$1" | wc -l
