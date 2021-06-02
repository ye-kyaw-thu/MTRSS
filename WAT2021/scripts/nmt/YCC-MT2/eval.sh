#!/bin/bash

## for BLEU score evaluation
## written by Ye Kyaw Thu, LST, NECTEC, Thailand
## ./eval.sh <reference> <hypothesis> <output-filename>
## e.g. ./eval.sh ./data/test.en ./ensembling-results/2.hyp.s2s-plus-transformer.en1 ./ensembling-results/2.s2s-plus-transformer-0.4-0.6.myen.results.txt

ref=$1;
hyp=$2;
output=$3;

perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl $ref < $hyp > $output;
cat $output;
