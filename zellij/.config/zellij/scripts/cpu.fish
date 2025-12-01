#!/usr/bin/env fish
# For Mac Apple Silicon (M1/M2/M3)

set load (sysctl -n vm.loadavg | awk '{print $2}')
set cores (sysctl -n hw.ncpu)
math "round($load / $cores * 100)"
