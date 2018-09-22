sed 's/ //g' $1 | grep -E '^[^ ]{'$2','$3'}$' | awk '{print $0}'
