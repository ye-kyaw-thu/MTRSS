#!/bin/bash

for folder in *; do
    if [ -d "$folder" ]; then
    for file in $folder/*; do
        echo "Adding speaker id to $file"
        perl add-spu_id.pl $file > $file.id 
     done
    fi
done
