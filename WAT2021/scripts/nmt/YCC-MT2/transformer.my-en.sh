#!/bin/bash

## Written by Ye Kyaw Thu, LST, NECTEC, Thailand
## Last updated: 1 June 2021

#     --mini-batch-fit -w 10000 --maxi-batch 1000 \
#    --mini-batch-fit -w 1000 --maxi-batch 100 \
#     --tied-embeddings-all \ 
#     --tied-embeddings \
#     --valid-metrics cross-entropy perplexity translation bleu \
#     --transformer-dropout 0.1 --label-smoothing 0.1 \
#     --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
#     --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \

mkdir model.transformer.my-en;

marian \
    --model model.transformer.my-en/model.npz --type transformer \
    --train-sets data/train.my data/train.en \
    --max-length 200 \
    --vocabs data/vocab/vocab.my.yml data/vocab/vocab.en.yml \
    --mini-batch-fit -w 1000 --maxi-batch 32 \
    --early-stopping 10 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics cross-entropy perplexity bleu \
    --valid-sets data/valid.my data/valid.en \
    --valid-translation-output data/valid.my-en.output --quiet-translation \
    --valid-mini-batch 32 \
    --beam-size 6 --normalize 0.6 \
    --log model.transformer.my-en/train.log --valid-log model.transformer.my-en/valid.log \
    --enc-depth 2 --dec-depth 2 \
    --transformer-heads 8 \
    --transformer-postprocess-emb d \
    --transformer-postprocess dan \
    --transformer-dropout 0.3 --label-smoothing 0.1 \
    --learn-rate 0.0003 --lr-warmup 0 --lr-decay-inv-sqrt 16000 --lr-report \
    --clip-norm 5 \
    --tied-embeddings \
    --devices 0 1 --sync-sgd --seed 1111 \
    --exponential-smoothing \
    --dump-config > model.transformer.my-en/config.yml
    
time marian -c model.transformer.my-en/config.yml  2>&1 | tee transformer-myen.log

