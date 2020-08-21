#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

gpu_temperature_format="%i"

print_gpu_temperature() {
  gpu_temperature_format=$(get_tmux_option "@gpu_temperature_format" "$gpu_temperature_format")

  if command_exists "nvidia-smi"; then
    loads=$(cached_eval nvidia-smi)
  elif command_exists "cuda-smi"; then
    loads=$(cached_eval cuda-smi)
  else
    echo "No GPU"
    return
  fi
  # echo $loads

  load=$(nvidia-smi --query-gpu=temperature.gpu --format=csv | tail -n 2 | sort -n | tail -n 1)
  # loads=$(echo "$loads" | sed -nr 's/.*\s([0-9]+)C.*/\1/p' |
  echo $load
  # gpus=$(echo "$loads" | wc -l)
  echo "$load" | awk -v format="$gpu_temperature_format" '{printf format,$1}'
}

main() {
  print_gpu_temperature
}
main
