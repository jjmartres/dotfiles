#!/usr/bin/env fish
# For Mac Apple Silicon (M1/M2/M3).

set page_size (vm_stat | awk '/page size of/ {print $8}')
set stats (vm_stat | awk -v ps=$page_size '
  /Pages active:/ {gsub(/\./,"",$3); active=$3} 
  /Pages wired down:/ {gsub(/\./,"",$4); wired=$4}
  /Pages occupied by compressor:/ {gsub(/\./,"",$5); compressed=$5}
  END {
    # Mémoire utilisée (formule macOS)
    used_gb = (wired + active + compressed) * ps / 1024 / 1024 / 1024
    printf "%d", used_gb
  }
')
set total_gb (math (sysctl -n hw.memsize) " / 1024 / 1024 / 1024")
echo "$stats"G/"$total_gb"G
