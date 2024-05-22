#!/bin/bash

# Get the list of GPUs
gpu_list=$(nvidia-smi --list-gpus)

# Initialize JSON
json="{\"data\":["

# Loop through the GPU list and construct JSON
index=0
while IFS= read -r gpu; do
  # Extract GPU name and UUID
  gpu_name=$(echo "$gpu" | sed -n 's/^GPU [0-9]: \(.*\) (UUID: .*)$/\1/p')
  gpu_uuid=$(echo "$gpu" | sed -n 's/^GPU [0-9]: .* (UUID: \(.*\))$/\1/p')

  if [ $index -ne 0 ]; then
    json="$json,"
  fi
  json="$json{\"{#GPU}\":\"$gpu_name\",\"{#GPUINDEX}\":\"$index\",\"{#GPUUUID}\":\"$gpu_uuid\"}"
  index=$((index + 1))
done <<< "$gpu_list"

# Close JSON
json="$json]}"

# Output JSON
echo $json

# EOF