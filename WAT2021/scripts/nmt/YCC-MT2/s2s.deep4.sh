#!/bin/bash

# Preparation for WAT2021 en-my, my-en share MT task by Ye, LST, NECTEC, Thailand
## Reference: https://marian-nmt.github.io/examples/mtm2017/complex/
## Note: ဒီတစ်ခေါက် အဓိက ပြောင်းခဲ့တာ အောက်ပါ option တွေ
##  --dec-depth 2 --dec-cell lstm --dec-cell-base-depth 2 --dec-cell-high-depth 2 \
##   --max-length 100 \ (length ကို လျှော့ကြည့်တယ်)
## အဖြစ်ပြောင်းခဲ့တယ်။
## မော်ဒယ်ကိုတော့ model.s2s-3/ အောက်မှာ သိမ်းခဲ့တယ် (failed ဖြစ်သွားလို့ ဒုတိယအခေါက် run တဲ့အခါမှာ
## model.s2s-4/ အောက်မှာ သိမ်းခဲ့တယ်။

mkdir model.s2s-4;

marian \
  --type s2s \
  --train-sets data/train.en data/train.my \
  --max-length 100 \
  --valid-sets data/valid.en data/valid.my \
  --vocabs data/vocab/vocab.en.yml data/vocab/vocab.my.yml \
  --model model.s2s-4/model.npz \
  --workspace 500 \
  --enc-depth 2 --enc-type alternating --enc-cell lstm --enc-cell-depth 2 \
  --dec-depth 2 --dec-cell lstm --dec-cell-base-depth 2 --dec-cell-high-depth 2 \
  --tied-embeddings --layer-normalization --skip \
  --mini-batch-fit \
  --valid-mini-batch 32 \
  --valid-metrics cross-entropy perplexity bleu\
  --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
  --dropout-rnn 0.3 --dropout-src 0.3 --exponential-smoothing \
  --early-stopping 10 \
  --log model.s2s-4/train.log --valid-log model.s2s-4/valid.log \
  --devices 0 1 --sync-sgd --seed 1111  \
  --dump-config > model.s2s-4/config.yml
  
time marian -c model.s2s-4/config.yml  2>&1 | tee s2s.enmy.syl.log
