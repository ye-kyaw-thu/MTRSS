#!/bin/bash

## for ensembling two models
## written by Ye Kyaw Thu, LST, NECTEC, Thailand
## ./ensemble-2models.sh <model1> <model2> <weight4model1> <weight4model2> <vocab1> < vocab2> <output> <input>
## Example: ./ensemble-2models.sh model.s2s-4.my-en/model.npz model.transformer.my-en/model.npz 0.4 0.6 ./data/vocab/vocab.my.yml ./data/vocab/vocab.en.yml ./ensembling-results/2.hyp.s2s-plus-transformer.en1 ./data/test.my

model1=$1;
model2=$2;
weight1=$3;
weight2=$4;
vocab1=$5;
vocab2=$6;
output=$7;
input=$8;

time marian-decoder \
    --models  $model1 $model2 \
    --weights $weight1 $weight2 --max-length 200 \
    --vocabs $vocab1 $vocab2\
   --maxi-batch 64  --workspace 500 \
   --output $output \
    --devices 0 1 < $input
    

