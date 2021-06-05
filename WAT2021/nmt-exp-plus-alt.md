# Running Log of NMT Experiments (plus ALT Corpus)
Last Updated: 2 June 2021

Exp 2: Ensemble Two Models (YCC-MT2 Team) အရင် run ခဲ့တာအားလုံးကို (UCSY+ALT training data) နဲ့  
နောက်တစ်ခေါက် အစအဆုံး ပြန် run ခဲ့တဲ့ running log ပါ။   

# System-1: s2s or RNN-based

## Data that I used 2nd time SMT experiment

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data$ wc *.my
    1000    57709   550454 dev.my
    1018    58895   561443 test.my
  256102  7324636 70957711 train.my
  258120  7441240 72069608 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data$ wc *.en
    1000    27318   147768 dev.en
    1018    27929   151447 test.en
  256102  3770260 19768494 train.en
  258120  3825507 20067709 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data$
```

## Copying Data

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ cp /home/ye/exp/smt/wat2021/exp-syl4/data/*.{my,en} .
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ wc *.{en,my}
    1000    27318   147768 dev.en
    1018    27929   151447 test.en
  256102  3770260 19768494 train.en
    1000    57709   550454 dev.my
    1018    58895   561443 test.my
  256102  7324636 70957711 train.my
  516240 11266747 92137317 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ 
```

## Copying script

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:/media/ye/SP PHD U3/backup/marian/wat2021/exp-syl4$ cp s2s.deep4.sh /home/ye/exp/nmt/plus-alt/
```

## Check the script

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ gedit s2s.deep4.sh
```

## Preparing Vocab Files

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ cat ./train.en ./dev.en > ./vocab/train-dev.en
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ cat ./train.my ./dev.my > ./vocab/train-dev.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ cd vocab/
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data/vocab$ ls
train-dev.en  train-dev.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data/vocab$ time marian-vocab < ./train-dev.en > vocab.en.yml
[2021-05-26 23:03:18] Creating vocabulary...
[2021-05-26 23:03:18] [data] Creating vocabulary stdout from stdin
[2021-05-26 23:03:19] Finished

real	0m1.013s
user	0m0.924s
sys	0m0.028s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data/vocab$ time marian-vocab < ./train-dev.my > vocab.my.yml
[2021-05-26 23:03:34] Creating vocabulary...
[2021-05-26 23:03:34] [data] Creating vocabulary stdout from stdin
[2021-05-26 23:03:36] Finished

real	0m1.286s
user	0m1.274s
sys	0m0.012s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data/vocab$
```

## Changing dev to valid

```
  --valid-sets data/valid.en data/valid.my \  
```

running shell script ထဲမှာက valid ဆိုပြီး သုံးခဲ့တာမို့ dev ဖိုင်တွေကို ဖိုင်နာမည်ပြောင်းသိမ်းခဲ့...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ mv dev.my valid.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data$ mv dev.en valid.en
```

## Script for s2s (en-my, word-syl)

```bash
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
```

## Running Log

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ time ./s2s.deep4.sh 
mkdir: cannot create directory ‘model.s2s-4’: File exists
[2021-05-26 23:11:55] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-26 23:11:55] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 5050 with command line:
[2021-05-26 23:11:55] [marian] marian -c model.s2s-4/config.yml
[2021-05-26 23:11:55] [config] after: 0e
[2021-05-26 23:11:55] [config] after-batches: 0
[2021-05-26 23:11:55] [config] after-epochs: 0
[2021-05-26 23:11:55] [config] all-caps-every: 0
[2021-05-26 23:11:55] [config] allow-unk: false
[2021-05-26 23:11:55] [config] authors: false
[2021-05-26 23:11:55] [config] beam-size: 12
[2021-05-26 23:11:55] [config] bert-class-symbol: "[CLS]"
[2021-05-26 23:11:55] [config] bert-mask-symbol: "[MASK]"
[2021-05-26 23:11:55] [config] bert-masking-fraction: 0.15
[2021-05-26 23:11:55] [config] bert-sep-symbol: "[SEP]"
[2021-05-26 23:11:55] [config] bert-train-type-embeddings: true
[2021-05-26 23:11:55] [config] bert-type-vocab-size: 2
[2021-05-26 23:11:55] [config] build-info: ""
[2021-05-26 23:11:55] [config] cite: false
[2021-05-26 23:11:55] [config] clip-norm: 1
[2021-05-26 23:11:55] [config] cost-scaling:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] cost-type: ce-sum
[2021-05-26 23:11:55] [config] cpu-threads: 0
[2021-05-26 23:11:55] [config] data-weighting: ""
[2021-05-26 23:11:55] [config] data-weighting-type: sentence
[2021-05-26 23:11:55] [config] dec-cell: lstm
[2021-05-26 23:11:55] [config] dec-cell-base-depth: 2
[2021-05-26 23:11:55] [config] dec-cell-high-depth: 2
[2021-05-26 23:11:55] [config] dec-depth: 2
[2021-05-26 23:11:55] [config] devices:
[2021-05-26 23:11:55] [config]   - 0
[2021-05-26 23:11:55] [config]   - 1
[2021-05-26 23:11:55] [config] dim-emb: 512
[2021-05-26 23:11:55] [config] dim-rnn: 1024
[2021-05-26 23:11:55] [config] dim-vocabs:
[2021-05-26 23:11:55] [config]   - 0
[2021-05-26 23:11:55] [config]   - 0
[2021-05-26 23:11:55] [config] disp-first: 0
[2021-05-26 23:11:55] [config] disp-freq: 500
[2021-05-26 23:11:55] [config] disp-label-counts: true
[2021-05-26 23:11:55] [config] dropout-rnn: 0.3
[2021-05-26 23:11:55] [config] dropout-src: 0.3
[2021-05-26 23:11:55] [config] dropout-trg: 0
[2021-05-26 23:11:55] [config] dump-config: ""
[2021-05-26 23:11:55] [config] early-stopping: 10
[2021-05-26 23:11:55] [config] embedding-fix-src: false
[2021-05-26 23:11:55] [config] embedding-fix-trg: false
[2021-05-26 23:11:55] [config] embedding-normalization: false
[2021-05-26 23:11:55] [config] embedding-vectors:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] enc-cell: lstm
[2021-05-26 23:11:55] [config] enc-cell-depth: 2
[2021-05-26 23:11:55] [config] enc-depth: 2
[2021-05-26 23:11:55] [config] enc-type: alternating
[2021-05-26 23:11:55] [config] english-title-case-every: 0
[2021-05-26 23:11:55] [config] exponential-smoothing: 0.0001
[2021-05-26 23:11:55] [config] factor-weight: 1
[2021-05-26 23:11:55] [config] grad-dropping-momentum: 0
[2021-05-26 23:11:55] [config] grad-dropping-rate: 0
[2021-05-26 23:11:55] [config] grad-dropping-warmup: 100
[2021-05-26 23:11:55] [config] gradient-checkpointing: false
[2021-05-26 23:11:55] [config] guided-alignment: none
[2021-05-26 23:11:55] [config] guided-alignment-cost: mse
[2021-05-26 23:11:55] [config] guided-alignment-weight: 0.1
[2021-05-26 23:11:55] [config] ignore-model-config: false
[2021-05-26 23:11:55] [config] input-types:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] interpolate-env-vars: false
[2021-05-26 23:11:55] [config] keep-best: false
[2021-05-26 23:11:55] [config] label-smoothing: 0
[2021-05-26 23:11:55] [config] layer-normalization: true
[2021-05-26 23:11:55] [config] learn-rate: 0.0001
[2021-05-26 23:11:55] [config] lemma-dim-emb: 0
[2021-05-26 23:11:55] [config] log: model.s2s-4/train.log
[2021-05-26 23:11:55] [config] log-level: info
[2021-05-26 23:11:55] [config] log-time-zone: ""
[2021-05-26 23:11:55] [config] logical-epoch:
[2021-05-26 23:11:55] [config]   - 1e
[2021-05-26 23:11:55] [config]   - 0
[2021-05-26 23:11:55] [config] lr-decay: 0
[2021-05-26 23:11:55] [config] lr-decay-freq: 50000
[2021-05-26 23:11:55] [config] lr-decay-inv-sqrt:
[2021-05-26 23:11:55] [config]   - 0
[2021-05-26 23:11:55] [config] lr-decay-repeat-warmup: false
[2021-05-26 23:11:55] [config] lr-decay-reset-optimizer: false
[2021-05-26 23:11:55] [config] lr-decay-start:
[2021-05-26 23:11:55] [config]   - 10
[2021-05-26 23:11:55] [config]   - 1
[2021-05-26 23:11:55] [config] lr-decay-strategy: epoch+stalled
[2021-05-26 23:11:55] [config] lr-report: false
[2021-05-26 23:11:55] [config] lr-warmup: 0
[2021-05-26 23:11:55] [config] lr-warmup-at-reload: false
[2021-05-26 23:11:55] [config] lr-warmup-cycle: false
[2021-05-26 23:11:55] [config] lr-warmup-start-rate: 0
[2021-05-26 23:11:55] [config] max-length: 100
[2021-05-26 23:11:55] [config] max-length-crop: false
[2021-05-26 23:11:55] [config] max-length-factor: 3
[2021-05-26 23:11:55] [config] maxi-batch: 100
[2021-05-26 23:11:55] [config] maxi-batch-sort: trg
[2021-05-26 23:11:55] [config] mini-batch: 64
[2021-05-26 23:11:55] [config] mini-batch-fit: true
[2021-05-26 23:11:55] [config] mini-batch-fit-step: 10
[2021-05-26 23:11:55] [config] mini-batch-track-lr: false
[2021-05-26 23:11:55] [config] mini-batch-warmup: 0
[2021-05-26 23:11:55] [config] mini-batch-words: 0
[2021-05-26 23:11:55] [config] mini-batch-words-ref: 0
[2021-05-26 23:11:55] [config] model: model.s2s-4/model.npz
[2021-05-26 23:11:55] [config] multi-loss-type: sum
[2021-05-26 23:11:55] [config] multi-node: false
[2021-05-26 23:11:55] [config] multi-node-overlap: true
[2021-05-26 23:11:55] [config] n-best: false
[2021-05-26 23:11:55] [config] no-nccl: false
[2021-05-26 23:11:55] [config] no-reload: false
[2021-05-26 23:11:55] [config] no-restore-corpus: false
[2021-05-26 23:11:55] [config] normalize: 0
[2021-05-26 23:11:55] [config] normalize-gradient: false
[2021-05-26 23:11:55] [config] num-devices: 0
[2021-05-26 23:11:55] [config] optimizer: adam
[2021-05-26 23:11:55] [config] optimizer-delay: 1
[2021-05-26 23:11:55] [config] optimizer-params:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] output-omit-bias: false
[2021-05-26 23:11:55] [config] overwrite: false
[2021-05-26 23:11:55] [config] precision:
[2021-05-26 23:11:55] [config]   - float32
[2021-05-26 23:11:55] [config]   - float32
[2021-05-26 23:11:55] [config]   - float32
[2021-05-26 23:11:55] [config] pretrained-model: ""
[2021-05-26 23:11:55] [config] quantize-biases: false
[2021-05-26 23:11:55] [config] quantize-bits: 0
[2021-05-26 23:11:55] [config] quantize-log-based: false
[2021-05-26 23:11:55] [config] quantize-optimization-steps: 0
[2021-05-26 23:11:55] [config] quiet: false
[2021-05-26 23:11:55] [config] quiet-translation: false
[2021-05-26 23:11:55] [config] relative-paths: false
[2021-05-26 23:11:55] [config] right-left: false
[2021-05-26 23:11:55] [config] save-freq: 5000
[2021-05-26 23:11:55] [config] seed: 1111
[2021-05-26 23:11:55] [config] sentencepiece-alphas:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] sentencepiece-max-lines: 2000000
[2021-05-26 23:11:55] [config] sentencepiece-options: ""
[2021-05-26 23:11:55] [config] shuffle: data
[2021-05-26 23:11:55] [config] shuffle-in-ram: false
[2021-05-26 23:11:55] [config] sigterm: save-and-exit
[2021-05-26 23:11:55] [config] skip: true
[2021-05-26 23:11:55] [config] sqlite: ""
[2021-05-26 23:11:55] [config] sqlite-drop: false
[2021-05-26 23:11:55] [config] sync-sgd: true
[2021-05-26 23:11:55] [config] tempdir: /tmp
[2021-05-26 23:11:55] [config] tied-embeddings: true
[2021-05-26 23:11:55] [config] tied-embeddings-all: false
[2021-05-26 23:11:55] [config] tied-embeddings-src: false
[2021-05-26 23:11:55] [config] train-embedder-rank:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] train-sets:
[2021-05-26 23:11:55] [config]   - data/train.en
[2021-05-26 23:11:55] [config]   - data/train.my
[2021-05-26 23:11:55] [config] transformer-aan-activation: swish
[2021-05-26 23:11:55] [config] transformer-aan-depth: 2
[2021-05-26 23:11:55] [config] transformer-aan-nogate: false
[2021-05-26 23:11:55] [config] transformer-decoder-autoreg: self-attention
[2021-05-26 23:11:55] [config] transformer-depth-scaling: false
[2021-05-26 23:11:55] [config] transformer-dim-aan: 2048
[2021-05-26 23:11:55] [config] transformer-dim-ffn: 2048
[2021-05-26 23:11:55] [config] transformer-dropout: 0
[2021-05-26 23:11:55] [config] transformer-dropout-attention: 0
[2021-05-26 23:11:55] [config] transformer-dropout-ffn: 0
[2021-05-26 23:11:55] [config] transformer-ffn-activation: swish
[2021-05-26 23:11:55] [config] transformer-ffn-depth: 2
[2021-05-26 23:11:55] [config] transformer-guided-alignment-layer: last
[2021-05-26 23:11:55] [config] transformer-heads: 8
[2021-05-26 23:11:55] [config] transformer-no-projection: false
[2021-05-26 23:11:55] [config] transformer-pool: false
[2021-05-26 23:11:55] [config] transformer-postprocess: dan
[2021-05-26 23:11:55] [config] transformer-postprocess-emb: d
[2021-05-26 23:11:55] [config] transformer-postprocess-top: ""
[2021-05-26 23:11:55] [config] transformer-preprocess: ""
[2021-05-26 23:11:55] [config] transformer-tied-layers:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] transformer-train-position-embeddings: false
[2021-05-26 23:11:55] [config] tsv: false
[2021-05-26 23:11:55] [config] tsv-fields: 0
[2021-05-26 23:11:55] [config] type: s2s
[2021-05-26 23:11:55] [config] ulr: false
[2021-05-26 23:11:55] [config] ulr-dim-emb: 0
[2021-05-26 23:11:55] [config] ulr-dropout: 0
[2021-05-26 23:11:55] [config] ulr-keys-vectors: ""
[2021-05-26 23:11:55] [config] ulr-query-vectors: ""
[2021-05-26 23:11:55] [config] ulr-softmax-temperature: 1
[2021-05-26 23:11:55] [config] ulr-trainable-transformation: false
[2021-05-26 23:11:55] [config] unlikelihood-loss: false
[2021-05-26 23:11:55] [config] valid-freq: 5000
[2021-05-26 23:11:55] [config] valid-log: model.s2s-4/valid.log
[2021-05-26 23:11:55] [config] valid-max-length: 1000
[2021-05-26 23:11:55] [config] valid-metrics:
[2021-05-26 23:11:55] [config]   - cross-entropy
[2021-05-26 23:11:55] [config]   - perplexity
[2021-05-26 23:11:55] [config]   - bleu
[2021-05-26 23:11:55] [config] valid-mini-batch: 32
[2021-05-26 23:11:55] [config] valid-reset-stalled: false
[2021-05-26 23:11:55] [config] valid-script-args:
[2021-05-26 23:11:55] [config]   []
[2021-05-26 23:11:55] [config] valid-script-path: ""
[2021-05-26 23:11:55] [config] valid-sets:
[2021-05-26 23:11:55] [config]   - data/valid.en
[2021-05-26 23:11:55] [config]   - data/valid.my
[2021-05-26 23:11:55] [config] valid-translation-output: ""
[2021-05-26 23:11:55] [config] vocabs:
[2021-05-26 23:11:55] [config]   - data/vocab/vocab.en.yml
[2021-05-26 23:11:55] [config]   - data/vocab/vocab.my.yml
[2021-05-26 23:11:55] [config] word-penalty: 0
[2021-05-26 23:11:55] [config] word-scores: false
[2021-05-26 23:11:55] [config] workspace: 500
[2021-05-26 23:11:55] [config] Model is being created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-26 23:11:55] Using synchronous SGD
[2021-05-26 23:11:55] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.en.yml
[2021-05-26 23:11:55] [data] Setting vocabulary size for input 0 to 85,602
[2021-05-26 23:11:55] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.my.yml
[2021-05-26 23:11:55] [data] Setting vocabulary size for input 1 to 12,379
[2021-05-26 23:11:55] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-05-26 23:11:55] [batching] Collecting statistics for batch fitting with step size 10
[2021-05-26 23:11:55] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-05-26 23:11:55] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-05-26 23:11:55] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-26 23:11:55] [comm] NCCLCommunicator constructed successfully
[2021-05-26 23:11:55] [training] Using 2 GPUs
[2021-05-26 23:11:55] [logits] Applying loss function for 1 factor(s)
[2021-05-26 23:11:55] [memory] Reserving 526 MB, device gpu0
[2021-05-26 23:11:56] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-05-26 23:11:56] [memory] Reserving 526 MB, device gpu0
[2021-05-26 23:12:32] [batching] Done. Typical MB size is 992 target words
[2021-05-26 23:12:32] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-05-26 23:12:32] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-05-26 23:12:32] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-26 23:12:32] [comm] NCCLCommunicator constructed successfully
[2021-05-26 23:12:32] [training] Using 2 GPUs
[2021-05-26 23:12:32] Training started
[2021-05-26 23:12:32] [data] Shuffling data
[2021-05-26 23:12:32] [data] Done reading 256,102 sentences
[2021-05-26 23:12:33] [data] Done shuffling 256,102 sentences to temp files
[2021-05-26 23:12:33] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-05-26 23:12:33] [memory] Reserving 526 MB, device gpu0
[2021-05-26 23:12:33] [memory] Reserving 526 MB, device gpu1
[2021-05-26 23:12:33] [memory] Reserving 526 MB, device gpu0
[2021-05-26 23:12:33] [memory] Reserving 526 MB, device gpu1
[2021-05-26 23:12:33] [memory] Reserving 263 MB, device gpu0
[2021-05-26 23:12:33] [memory] Reserving 263 MB, device gpu1
[2021-05-26 23:12:34] [memory] Reserving 526 MB, device gpu0
[2021-05-26 23:12:34] [memory] Reserving 526 MB, device gpu1
[2021-05-26 23:22:42] Ep. 1 : Up. 500 : Sen. 15,203 : Cost 6.01253986 * 414,436 after 414,436 : Time 609.91s : 679.50 words/s
[2021-05-26 23:32:41] Ep. 1 : Up. 1000 : Sen. 31,050 : Cost 4.39333200 * 412,771 after 827,207 : Time 599.31s : 688.74 words/s
[2021-05-26 23:42:42] Ep. 1 : Up. 1500 : Sen. 46,399 : Cost 3.85080099 * 413,603 after 1,240,810 : Time 600.93s : 688.28 words/s
[2021-05-26 23:52:45] Ep. 1 : Up. 2000 : Sen. 61,839 : Cost 3.60328317 * 412,445 after 1,653,255 : Time 602.87s : 684.14 words/s
[2021-05-27 00:02:48] Ep. 1 : Up. 2500 : Sen. 77,470 : Cost 3.46699023 * 411,173 after 2,064,428 : Time 602.45s : 682.50 words/s
[2021-05-27 00:12:54] Ep. 1 : Up. 3000 : Sen. 92,747 : Cost 3.36234403 * 412,166 after 2,476,594 : Time 606.59s : 679.48 words/s
[2021-05-27 00:22:59] Ep. 1 : Up. 3500 : Sen. 108,380 : Cost 3.28403616 * 410,743 after 2,887,337 : Time 604.87s : 679.06 words/s
[2021-05-27 00:33:00] Ep. 1 : Up. 4000 : Sen. 123,619 : Cost 3.21356606 * 411,024 after 3,298,361 : Time 600.52s : 684.45 words/s
[2021-05-27 00:43:03] Ep. 1 : Up. 4500 : Sen. 139,126 : Cost 3.15203404 * 411,301 after 3,709,662 : Time 603.69s : 681.31 words/s
[2021-05-27 00:53:12] Ep. 1 : Up. 5000 : Sen. 154,472 : Cost 3.10490203 * 415,501 after 4,125,163 : Time 608.22s : 683.15 words/s
[2021-05-27 00:53:12] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 00:53:14] Saving model weights and runtime parameters to model.s2s-4/model.iter5000.npz
[2021-05-27 00:53:15] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 00:53:17] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 00:53:30] [valid] Ep. 1 : Up. 5000 : cross-entropy : 219.282 : new best
[2021-05-27 00:53:39] [valid] Ep. 1 : Up. 5000 : perplexity : 41.8906 : new best
[2021-05-27 00:53:39] Translating validation set...
[2021-05-27 00:53:45] [valid] [valid] First sentence's tokens as scored:
[2021-05-27 00:53:45] [valid] DefaultVocab keeps original segments for scoring
[2021-05-27 00:53:45] [valid] [valid]   Hyp: ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ သည် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ
[2021-05-27 00:53:45] [valid] [valid]   Ref: အ မေ ရိ ကန် ပြည် ထောင် စု သည် ၂၀၀၆ ခု နှစ် ၊ ဒီ ဇင် ဘာ လ မှ ၂၀၀၇ ခု နှစ် ၊ ဖေ ဖော် ဝါ ရီ လ အ တွင်း တွင် ပျှမ်း မျှ အ ပူ အ အေး ပ မာ ဏ များ ကြုံ တွေ့ ခဲ့ သော် လည်း ၊ အ မျိုး သား သ မုဒ္ဒ ရာ နှ င့် ကမ္ဘာ့ လေ ထု အ ဖွဲ့ အ စည်း ( အန် အို အေ အေ ) အ ရ ၊ ကမ္ဘာ့ အ ပူ ချိန် များ အား လုံး သည် မှတ် တမ်း တွင် အ ပူ ဆုံး ဖြစ် ခဲ့ သည် ။
[2021-05-27 00:54:00] Best translation 0 : ဒါ ပေ မဲ့ ကျွန် တော် တို့ နိုင် ငံ ခြား ရေး ဝန် ကြီး ဌာ န ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 00:54:00] Best translation 1 : ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင်
[2021-05-27 00:54:00] Best translation 2 : နိုင် ငံ တော် သမ္မ တ သည် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 00:54:00] Best translation 3 : အ မျိုး သ မီး များ အ နေ ဖြ င့် အ မျိုး သ မီး များ ၏ အ ခွ င့် အ ရေး များ နှ င့် အ ညီ ဆောင် ရွက် ရ မည် ။
[2021-05-27 00:54:06] Best translation 4 : နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် သမ္မ တ ဦး သိန်း စိန် က ပြော သည် ။
[2021-05-27 00:54:06] Best translation 5 : သူ တို့ က သူ တို့ ကို သူ တို့ ကို မ သိ ဘူး ။
[2021-05-27 00:54:06] Best translation 10 : နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 00:54:06] Best translation 20 : တိုင်း ဒေ သ ကြီး သို့ မ ဟုတ် ပြည် နယ် လွှတ် တော် ကိုယ် စား လှယ် များ နှ င့် အ မျိုး သ မီး များ အ နေ ဖြ င့် တိုင်း ရင်း သား လက် နက် ကိုင် အ ဖွဲ့ အ စည်း များ နှ င့် အ ညီ ဆောင် ရွက် ရ မည် ။
[2021-05-27 00:54:06] Best translation 40 : သူ မ သည် သူ မ ၏ မိ သား စု အ နေ ဖြ င့် သူ မ ၏ မိ သား စု အ နေ ဖြ င့် သူ မ ၏ မိ သား စု အ နေ ဖြ င့် အ မျိုး သ မီး များ အ တွက် သူ မ ၏ အ ခွ င့် အ ရေး တစ် ခု ဖြစ် သည် ။
[2021-05-27 00:54:06] Best translation 80 : ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ နှ င့်
[2021-05-27 00:54:06] Best translation 160 : ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ သည် နိုင် ငံ တော် သမ္မ တ သည် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 00:54:14] Best translation 320 : အ မျိုး သ မီး များ အ တွက် အ မျိုး သ မီး များ ၏ အ ခွ င့် အ ရေး များ ကို အ မျိုး သ မီး များ ၏ အ ခွ င့် အ ရေး များ နှ င့် အ ညီ ဆောင် ရွက် ရ မည် ။
[2021-05-27 00:55:03] Best translation 640 : နိုင် ငံ တော် သမ္မ တ သည် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ မြန် မာ နိုင် ငံ တော် သမ္မ တ ဦး သိန်း စိန် က ပြော သည် ။
[2021-05-27 00:55:17] Total translation time: 98.57258s
[2021-05-27 00:55:17] [valid] Ep. 1 : Up. 5000 : bleu : 0.798745 : new best
[2021-05-27 01:05:22] Ep. 1 : Up. 5500 : Sen. 169,585 : Cost 3.05163932 * 413,402 after 4,538,565 : Time 730.40s : 565.99 words/s
...
...
...
[2021-05-27 02:36:05] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 02:36:07] Saving model weights and runtime parameters to model.s2s-4/model.iter10000.npz
[2021-05-27 02:36:08] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 02:36:10] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 02:36:23] [valid] Ep. 2 : Up. 10000 : cross-entropy : 199.157 : new best
[2021-05-27 02:36:32] [valid] Ep. 2 : Up. 10000 : perplexity : 29.7333 : new best
[2021-05-27 02:36:32] Translating validation set...
[2021-05-27 02:36:47] Best translation 0 : &quot; ကျွန် တော် တို့ အ နေ နဲ့ နိုင် ငံ ရေး ဆွေး နွေး ပွဲ တွေ အ တွက် ကျွန် တော် တို့ အ တွက် အ ရေး ကြီး ပါ တယ် ။
[2021-05-27 02:36:47] Best translation 1 : အ မေ ရိ ကန် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က အ မေ ရိ ကန် ပြည် ထောင် စု သမ္မ တ မြန် မာ နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် နှ င့် တွေ့ ဆုံ ခဲ့ သည် ။
[2021-05-27 02:36:48] Best translation 2 : &quot; အ ခြေ ခံ အ ဆောက် အ အုံ တစ် ခု အ နေ နဲ့ က ရင် အ မျိုး သ မီး တစ် ဦး က ပြော တယ် ။
[2021-05-27 02:36:48] Best translation 3 : &quot; အ မျိုး သား ဒီ မို က ရေ စီ ဖက် ဒ ရယ် ပြည် ထောင် စု ငြိမ်း ချမ်း ရေး လုပ် ငန်း စဉ် တစ် ခု ဖြစ် ပါ တယ် &quot; ဟု ပြော သည် ။
[2021-05-27 02:36:51] Best translation 4 : နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 02:36:51] Best translation 5 : နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ပြော သည် ။
[2021-05-27 02:36:51] Best translation 10 : လွန် ခဲ့ တဲ့ နှစ် က စ နေ နေ့ မှာ တစ် နာ ရီ လောက် စော င့် နေ တယ် ။
[2021-05-27 02:36:51] Best translation 20 : ၂၀၁၃ ခု နှစ် ဇန် န ဝါ ရီ လ တွင် စ တင် ဆောင် ရွက် ခဲ့ သ ည့် အ ဖွဲ့ အ စည်း များ နှ င့် သ ဘာ ဝ ပတ် ဝန်း ကျင် ထိန်း သိမ်း ရေး အ ဖွဲ့ အ စည်း များ နှ င့် ပူး ပေါင်း ဆောင် ရွက် လျက် ရှိ သည် ။
[2021-05-27 02:36:51] Best translation 40 : သူ မ သည် သူ မ ၏ မိ သား စု ဝင် များ နှ င့် တွေ့ ဆုံ မေး မြန်း ခဲ့ သ ည့် အ ခါ သူ မ ၏ မိ သား စု ဝင် များ နှ င့် တွေ့ ဆုံ မေး မြန်း ခဲ့ သည် ။
[2021-05-27 02:36:51] Best translation 80 : ဗုဒ္ဓ ဘာ သာ ဝင် အ မျိုး သား အ ဆ င့် မြ င့် ပ ညာ ရေး အ ဆ င့် မြ င့် ပ ညာ ရေး အ ဆ င့် မြ င့် ပ ညာ ရေး ဆိုင် ရာ အ ခြေ ခံ အ ဆောက် အ ဦး တစ် ရပ် ရပ် အ နေ ဖြ င့် တစ် နိုင် ငံ လုံး ပစ် ခတ် တိုက် ခိုက် မှု ရပ် စဲ ရေး သ ဘော တူ ညီ ချက် ရ ရှိ ရန် လို အပ် ပါ သည် ။
[2021-05-27 02:36:51] Best translation 160 : ဒု တိ ယ သမ္မ တ သည် နိုင် ငံ တော် ၏ အ တိုင် ပင် ခံ ပုဂ္ဂိုလ် ဒေါ် အောင် ဆန်း စု ကြည် က ရ ခိုင် ပြည် နယ် အ တွင်း သို့ ရောက် ရှိ ကြ သည် ။
[2021-05-27 02:36:58] Best translation 320 : &quot; ကျွန် တော် တို့ ရဲ့ ဘ ဝ အ ခြေ အ နေ က တော့ ကျွန် တော် တို့ ရဲ့ ဘ ဝ အ တွက် အ ဓိ က အ ချက် အ လက် တွေ ရှိ ပါ တယ် ။
[2021-05-27 02:37:35] Best translation 640 : မန္တ လေး တိုင်း ဒေ သ ကြီး သို့ မ ဟုတ် ပြည် နယ် အ စိုး ရ အ နေ ဖြ င့် တိုင်း ရင်း သား လက် နက် ကိုင် အ ဖွဲ့ အ စည်း များ အ ကြား တိုက် ပွဲ များ ဖြစ် ပွား ခဲ့ သည် ။
[2021-05-27 02:37:46] Total translation time: 74.15511s
[2021-05-27 02:37:46] [valid] Ep. 2 : Up. 10000 : bleu : 3.86223 : new best
...
...
...
[2021-05-27 06:00:15] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 06:00:17] Saving model weights and runtime parameters to model.s2s-4/model.iter20000.npz
[2021-05-27 06:00:18] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 06:00:21] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 06:00:33] [valid] Ep. 3 : Up. 20000 : cross-entropy : 172.884 : new best
[2021-05-27 06:00:42] [valid] Ep. 3 : Up. 20000 : perplexity : 19.006 : new best
[2021-05-27 06:00:42] Translating validation set...
[2021-05-27 06:00:58] Best translation 0 : &quot; ကျွန် တော် တို့ ဟာ သူ့ ရဲ့ ဆုံး ရှုံး မှု တွေ အ တွက် ဝမ်း နည်း စ ရာ ကောင်း တဲ့ နိုင် ငံ တစ် နိုင် ငံ အ တွက် ဝမ်း နည်း ပါ တယ် ။
[2021-05-27 06:00:58] Best translation 1 : အ မေ ရိ ကန် ပြည် ထောင် စု ပါ တီ က အ မေ ရိ ကန် ပြည် ထောင် စု ပါ တီ က အ မေ ရိ ကန် ပြည် ထောင် စု ပါ တီ က အ မေ ရိ ကန် ပြည် ထောင် စု ပါ တီ က အ မေ ရိ ကန် ပြည် ထောင် စု ပါ တီ အ ဖြစ် သတ် မှတ် ခဲ့ ပါ တယ် ။
[2021-05-27 06:00:58] Best translation 2 : &quot; မြန် မာ နိုင် ငံ အ စိုး ရ က ပစ် ခတ် တိုက် ခိုက် မှု ရပ် စဲ ရေး သ ဘော တူ စာ ချုပ် ကို လက် ခံ ရ ရှိ ခဲ့ ပါ တယ် ။
[2021-05-27 06:00:58] Best translation 3 : &quot; သူ တို့ မှာ ရှိ တဲ့ အ ခြား တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် တ ရား ဝင် အ သိ အ မှတ် ပြု မှု တစ် ခု ရှိ ပါ တယ် &quot; ဟု ပြော သည် ။
[2021-05-27 06:01:02] Best translation 4 : အာ စီ အက်စ် အက်စ် အ ဖွဲ့ ဝင် အ ဖြစ် အ ဆ င့် မြ င့် ပ ညာ ရှင် အ ဖွဲ့ ဝင် တစ် ဦး ဖြစ် သည် ဟု ပြော သည် ။
[2021-05-27 06:01:02] Best translation 5 : ပါ လီ တို ၏ အ စိုး ရ ၏ အ စိုး ရ ၏ သေ ဆုံး မှု အ ကြောင်း သူ တို့ မ သိ ခဲ့ ပါ ဟု ပြော ကြား သည် ။
[2021-05-27 06:01:02] Best translation 10 : ဗြိ တိန် နိုင် ငံ ခြား ရေး ဝန် ကြီး ဌာ န က မှတ် ပုံ တင် အ ရာ ရှိ တစ် ယောက် အ ဖြစ် မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-27 06:01:02] Best translation 20 : အ မေ ရိ ကန် ပြည် ထောင် စု အ စိုး ရ ဌာ န အ နေ ဖြ င့် ဝါ ရှင် တန် အ ခြေ စိုက် စ ခန်း များ တွင် အ ခြေ ခံ သ ည့် သု တေ သ န ဆိုင် ရာ သု တေ သ န ဆိုင် ရာ သု တေ သ န အ ချက် အ လက် များ နှ င့် အ ချက် အ လက် များ ကို ဖော် ပြ ထား ပါ သည် ။
[2021-05-27 06:01:02] Best translation 40 : ထို့ နောက် သူ မ ၏ အ ကူ အ ညီ ဖြ င့် သူ မ ၏ အ ကူ အ ညီ ဖြ င့် သူ မ ၏ အ ကူ အ ညီ ဖြ င့် အ ကူ အ ညီ ပေး ခဲ့ သည် ။
[2021-05-27 06:01:02] Best translation 80 : မဲ ဆန္ဒ ရှင် များ အ နေ ဖြ င့် မဲ ပေး ခွ င့် ရ ရှိ ရန် ဆန္ဒ မဲ ပေး ပိုင် ခွ င့် ရှိ သူ များ နှ င့် မဲ ဆန္ဒ ရှင် ပြည် သူ များ အား လုံး အ နည်း ဆုံး ၁၀ ရာ ခိုင် နှုန်း သာ လို အပ် ပါ သည် ။
[2021-05-27 06:01:02] Best translation 160 : ဒု တိ ယ သမ္မ တ က အိန္ဒိ ယ နိုင် ငံ ရှိ အိန္ဒိ ယ နိုင် ငံ ခ ရီး သွား လာ ရေး ခ ရီး စဉ် ကို ပိတ် ထား သည် ။
[2021-05-27 06:01:09] Best translation 320 : &quot; ကျွန် တော် တို့ ရဲ့ ရည် မှန်း ချက် က တော့ ကျွန် တော် တို့ ရဲ့ ပုံ စံ နဲ့ ရေ အ ရင်း အ မြစ် တွေ အား လုံး အ တွက် အ ဓိ က တာ ဝန် တစ် ခု ရှိ ပါ တယ် ။
[2021-05-27 06:01:42] Best translation 640 : အ ရေး ပေါ် အ ခြေ အ နေ တွင် အ ရေး ပေါ် အ ခြေ အ နေ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-27 06:01:51] Total translation time: 69.00494s
[2021-05-27 06:01:51] [valid] Ep. 3 : Up. 20000 : bleu : 9.99725 : new best
...
...
...
[2021-05-27 19:32:44] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 19:32:46] Saving model weights and runtime parameters to model.s2s-4/model.iter60000.npz
[2021-05-27 19:32:47] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 19:32:49] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 19:33:02] [valid] Ep. 8 : Up. 60000 : cross-entropy : 149.275 : new best
[2021-05-27 19:33:10] [valid] Ep. 8 : Up. 60000 : perplexity : 12.713 : new best
[2021-05-27 19:33:10] Translating validation set...
[2021-05-27 19:33:22] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း နေ သော် လည်း ရန် သူ နှ င့် ဘာ သာ ရေး ကို ထိ ခိုက် စေ မ ည့် အ မွေ အ နှစ် တစ် ခု ကျန် ခဲ့ သည် ။
[2021-05-27 19:33:22] Best translation 1 : ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ပိုင်း ဝါ သ နာ ရှင် တန် ဖိုး ရှိ အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု မှ ပစ် ခတ် ခံ ရ သ ည့် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ဒါ ဇင် နှ င့် စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် သည် လည်း သေ ဆုံး ခဲ့ ကြောင်း ထင် ရှား သည် ။
[2021-05-27 19:33:24] Best translation 2 : ဒုံး ကျည် တစ် ခု က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-27 19:33:24] Best translation 3 : သူ တို့ မှာ အ စား အ စာ ပြု ပြင် ပြောင်း လဲ ရေး လုပ် နိုင် တဲ့ စွမ်း ရည် ရှိ ပါ တယ် &quot; ဟု အ နောက် သ တင်း ထောက် တစ် ဦး က ပြော သည် ။
[2021-05-27 19:33:26] Best translation 4 : ကုမ္ပ ဏီ ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ရာ ရှိ ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-27 19:33:26] Best translation 5 : ပါ ကစ္စ တန် နိုင် ငံ အ စိုး ရ က သူ တို့ သေ ဆုံး မှု အ ကြောင်း မ သိ ကြောင်း ပါ ကစ္စ တန် ၏ အ စိုး ရ က ပြော ကြား ခဲ့ သည် ။
[2021-05-27 19:33:26] Best translation 10 : လော့စ် အိန် ဂျယ် လိစ် သည် ၁ နာ ရီ ခွဲ တွင် ရောက် လာ သော ပန်း တိုင် တစ် ခု တည်း သာ မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-27 19:33:26] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န က ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ပြု ထား သ ည့် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အမ် အန် အို အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ ချက် အ လက် များ ပါ ဝင် တယ် ။
[2021-05-27 19:33:26] Best translation 40 : သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တယ် ။
[2021-05-27 19:33:26] Best translation 80 : မဲ ပေး သူ ကိုယ် စား လှယ် လောင်း ၅၀ ရာ ခိုင် နှုန်း သည် ဆန္ဒ မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-27 19:33:26] Best translation 160 : ဒု တိ ယ ရ ထား သည် အိန္ဒိ ယ ပ စိ ဖိတ် ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သ ည့် အ ဝေး ပြေး လမ်း ကို ပိတ် ခဲ့ သည် ။
[2021-05-27 19:33:31] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ န မူ နာ ပုံ စံ တွေ က အ ထဲ မှာ ဓာတ် ဆီ အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-27 19:33:59] Best translation 640 : ကမ်း ရိုး တန်း အ တွင်း မှ ည ၇ : ၀၀ နာ ရီ မိ နစ် ၄၀ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-27 19:34:07] Total translation time: 56.41504s
[2021-05-27 19:34:07] [valid] Ep. 8 : Up. 60000 : bleu : 15.6182 : new best
[2021-05-27 19:44:11] Ep. 8 : Up. 60500 : Sen. 122,218 : Cost 1.32405508 * 414,202 after 49,936,738 : Time 687.26s : 602.69 words/s
[2021-05-27 19:54:07] Ep. 8 : Up. 61000 : Sen. 137,725 : Cost 1.32625842 * 411,433 after 50,348,171 : Time 595.94s : 690.39 words/s
[2021-05-27 20:04:13] Ep. 8 : Up. 61500 : Sen. 152,963 : Cost 1.32124400 * 413,391 after 50,761,562 : Time 605.98s : 682.19 words/s
[2021-05-27 20:14:09] Ep. 8 : Up. 62000 : Sen. 168,532 : Cost 1.32831109 * 413,298 after 51,174,860 : Time 596.02s : 693.43 words/s
[2021-05-27 20:24:08] Ep. 8 : Up. 62500 : Sen. 183,907 : Cost 1.32032120 * 411,989 after 51,586,849 : Time 598.72s : 688.12 words/s
[2021-05-27 20:34:14] Ep. 8 : Up. 63000 : Sen. 199,234 : Cost 1.32446969 * 412,814 after 51,999,663 : Time 605.85s : 681.38 words/s
[2021-05-27 20:44:16] Ep. 8 : Up. 63500 : Sen. 214,568 : Cost 1.33641219 * 409,802 after 52,409,465 : Time 602.42s : 680.26 words/s
[2021-05-27 20:54:18] Ep. 8 : Up. 64000 : Sen. 229,950 : Cost 1.32993186 * 415,206 after 52,824,671 : Time 602.13s : 689.57 words/s
[2021-05-27 21:04:20] Ep. 8 : Up. 64500 : Sen. 245,622 : Cost 1.32732379 * 414,085 after 53,238,756 : Time 601.73s : 688.16 words/s
[2021-05-27 21:06:45] Seen 249224 samples
[2021-05-27 21:06:45] Starting data epoch 9 in logical epoch 9
[2021-05-27 21:06:45] [data] Shuffling data
[2021-05-27 21:06:45] [data] Done reading 256,102 sentences
[2021-05-27 21:06:45] [data] Done shuffling 256,102 sentences to temp files
[2021-05-27 21:14:25] Ep. 9 : Up. 65000 : Sen. 11,652 : Cost 1.24708581 * 413,048 after 53,651,804 : Time 605.25s : 682.44 words/s
[2021-05-27 21:14:25] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 21:14:28] Saving model weights and runtime parameters to model.s2s-4/model.iter65000.npz
[2021-05-27 21:14:28] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 21:14:30] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 21:14:43] [valid] Ep. 9 : Up. 65000 : cross-entropy : 148.847 : new best
[2021-05-27 21:14:51] [valid] Ep. 9 : Up. 65000 : perplexity : 12.6207 : new best
[2021-05-27 21:14:51] Translating validation set...
[2021-05-27 21:15:04] Best translation 0 : &quot; ကျွန် မ တို့ ဟာ သူ့ ရဲ့ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း နေ ပေ မဲ့ ရန် သူ နဲ့ ဘာ သာ ရေး ကို ဆ န့် ကျင် မှာ ဖြစ် ပါ တယ် ။
[2021-05-27 21:15:04] Best translation 1 : ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ဘက် ဝါ ဇီ ရီ စ တန် မြောက် ဘက် တွင် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု မှ ပစ် ခတ် ခံ ရ သ ည့် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ဒါ ဇင် နှ င့် စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် သည် လည်း သေ ဆုံး ကြောင်း သိ ရှိ ရ ပါ သည် ။
[2021-05-27 21:15:04] Best translation 2 : ဒုံး ကျည် ကြော င့် လေ ယာဉ် မောင်း သူ က ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော တယ် ။
[2021-05-27 21:15:04] Best translation 3 : သူ တို့ မှာ လုပ် နိုင် စွမ်း ရှိ ပြီး အ စား ထိုး တဲ့ အ ရာ ရှိ တစ် ဦး က ပြော တယ် ။
[2021-05-27 21:15:08] Best translation 4 : အန် အယ်လ် အေ ၏ တ တိ ယ အ မြ င့် ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-27 21:15:08] Best translation 5 : ပါ ကစ္စ တန် နိုင် ငံ အ စိုး ရ က သူ တို့ သေ ဆုံး မှု အ ကြောင်း မ သိ ဘူး လို့ ပါ ကစ္စ တန် အ စိုး ရ က ပြော တယ် ။
[2021-05-27 21:15:08] Best translation 10 : လော့စ် အိန် ဂျယ် လိစ် က ၁ ဝက် လောက် စော စော ရောက် လာ တဲ့ ဂိုး တစ် ခု တည်း သာ မှတ် တမ်း တင် ခဲ့ တယ် ။
[2021-05-27 21:15:08] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ခံ သော အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န က ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ စိုက် သ ည့် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အန် အို အေ ဦး ဆောင် သ ည့် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သည် ။
[2021-05-27 21:15:08] Best translation 40 : သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တယ် ။
[2021-05-27 21:15:08] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-27 21:15:08] Best translation 160 : ဒု တိ ယ ရ ထား သည် အိန္ဒိ ယ ပ စိ ဖိတ် ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သ ည့် အ ဝေး ပြေး လမ်း ကို ပိတ် ခဲ့ သည် ။
[2021-05-27 21:15:13] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ န မူ နာ ပုံ စံ ကို အ ထဲ မှာ ဖော် ပြ ထား ပါ တယ် ။ ကျွန် တော် တို့ ရဲ့ စံ န မူ နာ ပြ မှု ဟာ အ ပူ ဓာတ် ငွေ့ နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-27 21:15:39] Best translation 640 : ကမ်း ရိုး တန်း အ တွင်း မှ ည ၇ နာ ရီ မိ နစ် ၃၀ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-27 21:15:47] Total translation time: 55.94467s
[2021-05-27 21:15:47] [valid] Ep. 9 : Up. 65000 : bleu : 15.4972 : stalled 1 times (last best: 15.6182)
...
...
...
[2021-05-27 22:56:27] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-27 22:56:29] Saving model weights and runtime parameters to model.s2s-4/model.iter70000.npz
[2021-05-27 22:56:30] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-27 22:56:32] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-27 22:56:44] [valid] Ep. 9 : Up. 70000 : cross-entropy : 148.762 : new best
[2021-05-27 22:56:53] [valid] Ep. 9 : Up. 70000 : perplexity : 12.6023 : new best
[2021-05-27 22:56:53] Translating validation set...
[2021-05-27 22:57:06] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ကျွန် တော် တို့ ဝမ်း နည်း နေ ပေ မဲ့ ရန် သူ နဲ့ ဘာ သာ ရေး ကို ဆ န့် ကျင် လိ မ့် မယ် ။
[2021-05-27 22:57:06] Best translation 1 : အ ခု အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု က ပါ ကစ္စ တန် နိုင် ငံ ရဲ့ မြောက် ဘက် ဝါ ဇီ ရီ စ တန် မှာ အ မေ ရိ ကန် လေ ယာဉ် နဲ့ တိုက် ခိုက် ခံ ရ တဲ့ အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ဒါ ဇင် နဲ့ တိုက် ခိုက် ခံ ရ တယ် လို့ ယူ ဆ ကြ ပါ တယ် ။
[2021-05-27 22:57:07] Best translation 2 : ဒုံး ကျည် ကြော င့် လေ ယာဉ် မောင်း သူ က ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော တယ် ။
[2021-05-27 22:57:07] Best translation 3 : သူ တို့ မှာ လုပ် နိုင် စွမ်း ရှိ ပြီး အ စား ထိုး တဲ့ အ ရာ ရှိ တစ် ဦး က ပြော တယ် ။
[2021-05-27 22:57:09] Best translation 4 : ဘီ အေ ၏ တ တိ ယ အ မြ င့် ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-27 22:57:09] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ တို့ သေ ဆုံး မှု အ ကြောင်း မ သိ ကြောင်း ပါ ကစ္စ တန် အ စိုး ရ က ပြော သည် ။
[2021-05-27 22:57:09] Best translation 10 : လော့စ် အိန် ဂျယ် လိစ် က ၁ နာ ရီ ခွဲ လောက် စော စော ရောက် လာ တဲ့ ဂိုး တစ် ခု တည်း ကို မှတ် တမ်း တင် ခဲ့ တယ် ။
[2021-05-27 22:57:09] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ခံ ထား သ ည့် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အမ် အန် အို အေ အ ဖွဲ့ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ ချက် အ လက် ဆိုင် ရာ သု တေ သ န လုပ် ငန်း များ ဆောင် ရွက် လျက် ရှိ သည် ။
[2021-05-27 22:57:09] Best translation 40 : အဲ ဒီ နောက် သူ မ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို ပစ် သတ် ခဲ့ တယ် ။
[2021-05-27 22:57:09] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-27 22:57:09] Best translation 160 : ဒု တိ ယ အ နေ ဖြ င့် မြန် မာ အိန္ဒိ ယ ပ စိ ဖိတ် ခ ရီး သည် တင် မီး ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သ ည့် ဆစ် ဒ နီ ခ ရီး သည် များ ကို အ သုံး ပြု ခဲ့ သည် ။
[2021-05-27 22:57:14] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ ပြ တွေ ထဲ က အ တွင်း ရေး မှူး တစ် ယောက် ရှိ ပါ တယ် ။ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ က အ ပူ ဓာတ် ငွေ့ နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-27 22:57:42] Best translation 640 : ကမ်း ရိုး တန်း အ တွင်း မှ ည ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-27 22:57:49] Total translation time: 55.84178s
[2021-05-27 22:57:49] [valid] Ep. 9 : Up. 70000 : bleu : 15.6628 : new best
...
...
...
[2021-05-28 02:20:14] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 02:20:16] Saving model weights and runtime parameters to model.s2s-4/model.iter80000.npz
[2021-05-28 02:20:16] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 02:20:18] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 02:20:31] [valid] Ep. 10 : Up. 80000 : cross-entropy : 148.908 : stalled 1 times (last best: 148.65)
[2021-05-28 02:20:40] [valid] Ep. 10 : Up. 80000 : perplexity : 12.6338 : stalled 1 times (last best: 12.5784)
[2021-05-28 02:20:40] Translating validation set...
[2021-05-28 02:20:52] Best translation 0 : &quot; ကျွန် တော် တို့ ဟာ သူ့ ရဲ့ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း နေ ပေ မဲ့ ရန် သူ နဲ့ ဘာ သာ ရေး ကို ဆ န့် ကျင် စေ မ ယ့် အ မွေ အ နှစ် တွေ ကျန် ခဲ့ ပါ တယ် ။
[2021-05-28 02:20:52] Best translation 1 : ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ဘက် ဝါ ဇီ ရီ စ တန် မြောက် ဘက် တွင် အ မေ ရိ ကန် လေ ယာဉ် မောင်း သူ တစ် ဒါ ဇင် ခ န့် က အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ဒါ ဇင် ခ န့် ပစ် ခတ် ခံ ရ ပြီး စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် သည် လည်း သေ ဆုံး ကြောင်း သိ ရှိ ရ ပါ သည် ။
[2021-05-28 02:20:53] Best translation 2 : လေ ယာဉ် မောင်း သူ တွေ ကို လေ ယာဉ် မောင်း သူ တစ် ဦး က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 02:20:53] Best translation 3 : သူ တို့ မှာ ကျ နော် တို့ မှာ လုပ် နိုင် စွမ်း ရှိ တဲ့ အ ရည် အ ချင်း ရှိ ပြီး အ စား ထိုး တဲ့ အ ရာ ရှိ တစ် ဦး က ပြော တယ် ။
[2021-05-28 02:20:55] Best translation 4 : ဘီ အေ ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို ကြ သည် ။
[2021-05-28 02:20:55] Best translation 5 : ပါ ကစ္စ တန် ၏ အ စိုး ရ က သူ တို့ သေ ဆုံး မှု အ ကြောင်း မ သိ ကြောင်း ပါ ကစ္စ တန် အ စိုး ရ က ပြော သည် ။
[2021-05-28 02:20:55] Best translation 10 : လော့စ် အိန် ဂျယ် လိစ် က ၁ နာ ရီ ခွဲ လောက် စော စော ရောက် လာ တဲ့ ဂိုး တစ် ခု တည်း ကို မှတ် တမ်း တင် ခဲ့ တယ် ။
[2021-05-28 02:20:55] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ခံ ထား သ ည့် အ မေ ရိ ကန် ကုန် သွယ် ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အန် အို အေ အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ ခြေ ပြု သု တေ သ န ဆိုင် ရာ သု တေ သ န လုပ် ငန်း များ ကို ဆောင် ရွက် သည် ။
[2021-05-28 02:20:55] Best translation 40 : သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို ပစ် သတ် ခဲ့ တဲ့ သေ နတ် သ မား က သူ့ ကို ဖမ်း ဆီး ခဲ့ တယ် ။
[2021-05-28 02:20:55] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 02:20:55] Best translation 160 : ဒု တိ ယ ရ ထား က အိန္ဒိ ယ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု သော လမ်း ကို ပိတ် ထား ခဲ့ သည် ။
[2021-05-28 02:21:00] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ ပြ ပုံ စံ က တော့ ကျွန် တော် တို့ ရဲ့ ပုံ စံ ကို ရည် ညွှန်း ပါ တယ် ။ ကျွန် တော် တို့ ပုံ စံ က အ ပူ ရှိန် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 02:21:29] Best translation 640 : နံ နက် ၇ နာ ရီ မိ နစ် ၃၀ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 02:21:35] Total translation time: 55.41231s
[2021-05-28 02:21:35] [valid] Ep. 10 : Up. 80000 : bleu : 16.1954 : new best
...
...
...
[2021-05-28 04:05:04] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 04:05:06] Saving model weights and runtime parameters to model.s2s-4/model.iter85000.npz
[2021-05-28 04:05:07] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 04:05:09] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 04:05:22] [valid] Ep. 11 : Up. 85000 : cross-entropy : 149.261 : stalled 2 times (last best: 148.65)
[2021-05-28 04:05:31] [valid] Ep. 11 : Up. 85000 : perplexity : 12.71 : stalled 2 times (last best: 12.5784)
[2021-05-28 04:05:31] Translating validation set...
[2021-05-28 04:05:44] Best translation 0 : &quot; ကျွန် တော် တို့ ဟာ သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း နေ ပေ မဲ့ ရန် သူ နဲ့ ဘာ သာ ရေး ကို ဆ န့် ကျင် စေ မ ယ့် အ မွေ အ နှစ် တွေ ကျန် ခဲ့ ပါ တယ် ။
[2021-05-28 04:05:44] Best translation 1 : ပါ ကစ္စ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် စ တန် လီ ယာ တွင် အ မေ ရိ ကန် လေ ယာဉ် မောင်း သူ တစ် ဒါ ဇင် ခ န့် သည် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု ဖြစ် ပြီး စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် သည် လည်း သေ ဆုံး ခဲ့ သည် ဟု ယူ ဆ ကြ သည် ။
[2021-05-28 04:05:44] Best translation 2 : ဒုံး ကျည် တွေ ကို လေ ယာဉ် မောင်း သူ တစ် ဦး က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 04:05:44] Best translation 3 : သူ တို့ က ဒီ လူ ငယ် တွေ ကို အ စား ထိုး ပြီး အ စား ထိုး နိုင် စွမ်း ရှိ တယ် &quot; ဟု အ နောက် တိုင်း ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော သည် ။
[2021-05-28 04:05:47] Best translation 4 : အယ် ကေး ဒါး ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-28 04:05:47] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ တို့ သေ ဆုံး မှု အ ကြောင်း ကို မ သိ ကြောင်း ပါ ကစ္စ တန် အ စိုး ရ က ပြော သည် ။
[2021-05-28 04:05:47] Best translation 10 : ၁ နာ ရီ ခွဲ တွင် ရောက် လာ သော ဂိုး တိုင် တစ် ခု တည်း သာ မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-28 04:05:47] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ခံ ထား သ ည့် အ မေ ရိ ကန် ကုန် သွယ် ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အမ် အန် အို အေ အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ ချက် အ လက် အ ချက် အ လက် များ ပါ ဝင် တယ် ။
[2021-05-28 04:05:47] Best translation 40 : သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို ပစ် သတ် ခဲ့ တဲ့ သေ နတ် သ မား က သူ့ ကို ဖမ်း ဆီး ခဲ့ တယ် ။
[2021-05-28 04:05:47] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် ၅၀ % အောက် နည်း သ ဖြ င့် ကိုယ် စား လှယ် လောင်း အား လုံး မှ အ နည်း ဆုံး ၃၃ ရာ ခိုင် နှုန်း လို အပ် ပါ သည် ။
[2021-05-28 04:05:47] Best translation 160 : ဒု တိ ယ ရ ထား က အိန္ဒိ ယ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား နဲ့ မြန် မာ နိုင် ငံ ရဲ့ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ကို အ သုံး ပြု ခဲ့ တယ် ။
[2021-05-28 04:05:52] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ ပြ ပုံ စံ က အ ပူ ဒဏ် ၊ အ ပူ ဒဏ် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 04:06:21] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 04:06:28] Total translation time: 56.94054s
[2021-05-28 04:06:28] [valid] Ep. 11 : Up. 85000 : bleu : 16.3537 : new best
...
...
...
[2021-05-28 05:27:36] Ep. 12 : Up. 89000 : Sen. 4,668 : Cost 1.09794557 * 409,789 after 73,465,914 : Time 603.53s : 678.98 words/s
[2021-05-28 05:37:34] Ep. 12 : Up. 89500 : Sen. 20,135 : Cost 1.01816452 * 411,383 after 73,877,297 : Time 598.46s : 687.40 words/s
[2021-05-28 05:47:34] Ep. 12 : Up. 90000 : Sen. 35,469 : Cost 1.03543830 * 415,887 after 74,293,184 : Time 599.70s : 693.49 words/s
[2021-05-28 05:47:34] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 05:47:36] Saving model weights and runtime parameters to model.s2s-4/model.iter90000.npz
[2021-05-28 05:47:37] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 05:47:39] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 05:47:51] [valid] Ep. 12 : Up. 90000 : cross-entropy : 149.619 : stalled 3 times (last best: 148.65)
[2021-05-28 05:48:00] [valid] Ep. 12 : Up. 90000 : perplexity : 12.7877 : stalled 3 times (last best: 12.5784)
[2021-05-28 05:48:00] Translating validation set...
[2021-05-28 05:48:12] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း သော် လည်း ရန် သူ နိုင် ငံ တော် နှ င့် ဘာ သာ ရေး ကို ထိ ခိုက် စေ မ ည့် အ မွေ အ နှစ် တစ် ခု ထွက် ခဲ့ သည် ။
[2021-05-28 05:48:12] Best translation 1 : အ ခု ဆို ရင် ပါ ကစ္စ တန် ရဲ့ မြောက် ဘက် ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ဘက် ဝါ ဇီ ရီ စ တန် မှာ ရှိ တဲ့ အ မေ ရိ ကန် ပြည် ထောင် စု က တိုက် ခိုက် ခံ ရ တဲ့ အ မေ ရိ ကန် ဒုံး ကျည် တစ် ခု က တိုက် ခိုက် ခံ ရ တယ် လို့ ယူ ဆ ကြ ပါ တယ် ။
[2021-05-28 05:48:13] Best translation 2 : ဒုံး ကျည် တွေ ကို လေ ယာဉ် မောင်း သူ တွေ က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 05:48:13] Best translation 3 : သူ တို့ က ဒီ လူ ငယ် တွေ ကို အ စား ထိုး လုပ် ကိုင် နိုင် စွမ်း ရှိ တယ် &quot; လို့ အ နောက် တိုင်း ထောက် လှမ်း ရေး တ ရား ဝင် ပြော တယ် ။
[2021-05-28 05:48:15] Best translation 4 : အယ် ကေး ဒါး ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို ကြ သည် ။
[2021-05-28 05:48:15] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ တို့ သေ ဆုံး ကြောင်း သူ တို့ မ သိ ကြောင်း ပြော ကြား ခဲ့ သည် ။
[2021-05-28 05:48:15] Best translation 10 : လော့စ် အိန် ဂျ လိစ် က ၁ နာ ရီ ခွဲ လောက် စော စော ရောက် လာ တဲ့ ဂိုး ကို မှတ် တမ်း တင် ခဲ့ တယ် ။
[2021-05-28 05:48:15] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ ခံ ထား သ ည့် အ မေ ရိ ကန် ကုန် သွယ် ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အမ် အန် အို အေ အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ ခြေ ပြု သု တေ သ န လုပ် ငန်း များ ဆောင် ရွက် လျက် ရှိ တယ် ။
[2021-05-28 05:48:15] Best translation 40 : သူ့ ကို သေ နတ် နဲ့ ပစ် လိုက် တဲ့ သေ နတ် သ မား က သူ့ ကို ပစ် ခတ် ခဲ့ တဲ့ သေ နတ် သ မား က သူ့ ကို ဖမ်း ဆီး ခဲ့ တယ် ။
[2021-05-28 05:48:15] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် ၅၀ % အောက် နည်း သ ဖြ င့် ကိုယ် စား လှယ် လောင်း အား လုံး မှ အ နည်း ဆုံး ၃၃ ရာ ခိုင် နှုန်း လို အပ် ပါ သည် ။
[2021-05-28 05:48:15] Best translation 160 : ဒု တိ ယ ရ ထား က အိန္ဒိ ယ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ကို အ သုံး ပြု ခဲ့ တယ် ။
[2021-05-28 05:48:20] Best translation 320 : ကျွန် မ တို့ ရဲ့ စံ ပြ ပုံ စံ က အ ပူ ဒဏ် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 05:48:47] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 05:48:54] Total translation time: 54.56744s
[2021-05-28 05:48:54] [valid] Ep. 12 : Up. 90000 : bleu : 16.6412 : new best
...
...
...
[2021-05-28 07:30:09] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် လိုက် သော သေ နတ် သ မား က သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး ပမ်း ခဲ့ သော သေ နတ် သ မား က ဖမ်း ဆီး ခဲ့ သည် ။
[2021-05-28 07:30:09] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် သည် ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ၍ ကိုယ် စား လှယ် လောင်း အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ ရာ ခိုင် နှုန်း လို အပ် ပါ သည် ။
[2021-05-28 07:30:09] Best translation 160 : ဒု တိ ယ ရ ထား လမ်း ကို မြန် မာ အိန္ဒိ ယ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သော လမ်း ကို ပိတ် ထား ပါ သည် ။
[2021-05-28 07:30:14] Best translation 320 : အန် ဆီ ဒီ အက်ဖ် အ တွင်း ရေး မှူး ဖြစ် တဲ့ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ က ဓာတ် ပုံ သ တင်း အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 07:30:41] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 07:30:49] Total translation time: 54.85734s
[2021-05-28 07:30:49] [valid] Ep. 12 : Up. 95000 : bleu : 16.5226 : stalled 1 times (last best: 16.6412)
...
...
...
[2021-05-28 09:12:44] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် ဖြ င့် သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး ပမ်း ခဲ့ သော သေ နတ် သ မား က သူ့ ကို ဖမ်း ဆီး ခဲ့ သည် ။
[2021-05-28 09:12:44] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 09:12:44] Best translation 160 : ဒု တိ ယ ရ ထား လမ်း ကို မြန် မာ အိန္ဒိ ယ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သော လမ်း ကို ပိတ် ထား ပါ သည် ။
[2021-05-28 09:12:49] Best translation 320 : အန် ဆီ ဒီ အက်ဖ် အ တွင်း ရေး မှူး ဖြစ် တဲ့ ကျွန် တော် တို့ ပုံ စံ က ဓာတ် ပုံ သ တင်း အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 09:13:16] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 09:13:22] Total translation time: 53.19579s
[2021-05-28 09:13:22] [valid] Ep. 13 : Up. 100000 : bleu : 16.6823 : new best
...
...
...
[2021-05-28 10:55:00] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် ဖြ င့် သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး စား ခဲ့ သော သေ နတ် သ မား က သူ့ ကို ဖမ်း ဆီး ခဲ့ သည် ။
[2021-05-28 10:55:00] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 10:55:00] Best translation 160 : ဒု တိ ယ ရ ထား လမ်း ကို မြန် မာ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သည် ။
[2021-05-28 10:55:05] Best translation 320 : အန် ဆီ ဒီ အက်ဖ် အ တွင်း ရေး မှူး ဖြစ် တဲ့ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ က ဓာတ် ပုံ သ တင်း အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 10:55:33] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 10:55:40] Total translation time: 54.71518s
[2021-05-28 10:55:40] [valid] Ep. 14 : Up. 105000 : bleu : 16.5745 : stalled 1 times (last best: 16.6823)
...
...
...
[2021-05-28 12:38:00] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် ဖြ င့် သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး စား ခဲ့ သော သေ နတ် သ မား က သူ့ ကို ဖမ်း ကိုင် လိုက် သည် ။
[2021-05-28 12:38:00] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 12:38:00] Best translation 160 : ဒု တိ ယ ရ ထား လမ်း ကို မြန် မာ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သည် ။
[2021-05-28 12:38:05] Best translation 320 : အန် ဆီ ဒီ အက်ဖ် ဆို တဲ့ ပုံ စံ ကို ရည် ညွှန်း ဖော် ပြ တာ က တော့ ကျွန် တော် တို့ ဆီ မှာ သ တင်း အ ရင်း အ မြစ် ရဲ့ အ ပူ ရှိန် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 12:38:33] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 12:38:39] Total translation time: 53.42463s
[2021-05-28 12:38:39] [valid] Ep. 14 : Up. 110000 : bleu : 16.5678 : stalled 2 times (last best: 16.6823)
...
...
...
[2021-05-28 14:19:17] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 14:19:19] Saving model weights and runtime parameters to model.s2s-4/model.iter115000.npz
[2021-05-28 14:19:20] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 14:19:22] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 14:19:35] [valid] Ep. 15 : Up. 115000 : cross-entropy : 153.146 : stalled 8 times (last best: 148.65)
[2021-05-28 14:19:43] [valid] Ep. 15 : Up. 115000 : perplexity : 13.5795 : stalled 8 times (last best: 12.5784)
[2021-05-28 14:19:43] Translating validation set...
[2021-05-28 14:19:56] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း သော် လည်း ရန် သူ နှ င့် ဘာ သာ ရေး ကို ထိ ခိုက် စေ မ ည့် အ မွေ တစ် ခု ကျန် ခဲ့ သည် ။
[2021-05-28 14:19:56] Best translation 1 : ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ဘက် ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် စ တန် လီ ကျွန်း တွင် တိုက် ခိုက် ခံ ရ သ ည့် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု တွင် တိုက် ခိုက် ခံ ရ ပြီး ယ ခု အ ခါ စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် က လည်း သေ ဆုံး ကြောင်း သိ ရှိ ရ ပါ သည် ။
[2021-05-28 14:19:56] Best translation 2 : ဒုံး ကျည် တွေ ကို လေ ယာဉ် မောင်း သူ တွေ က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 14:19:56] Best translation 3 : ဒီ လူ ငယ် တွေ အ စား ပြန် ထုတ် လုပ် နိုင် တဲ့ စွမ်း ရည် ရှိ တယ် &quot; လို့ အ နောက် ပိုင်း ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 14:19:58] Best translation 4 : အယ် ကိုင် ဒါ ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-28 14:19:58] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ ၏ သေ ဆုံး မှု အ ကြောင်း ကို မ သိ ရှိ ကြောင်း ပါ ကစ္စ တန် အ စိုး ရ က ပြော သည် ။
[2021-05-28 14:19:58] Best translation 10 : ၁ နာ ရီ ခွဲ တွင် လော့စ် အိန် ဂျ လိစ် က မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-28 14:19:58] Best translation 20 : ဝါ ရှင် တန် ဒီ စီ တွင် အ ခြေ စိုက် သော အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အန် အေ အို အေ က သ ဘင် များ နှ င့် လေ ထု အ ပေါ် မူ လ သ တင်း အ ချက် အ လက် များ ရ ရှိ ထား သည် ။
[2021-05-28 14:19:58] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် သ မား က သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး စား ခဲ့ သော သေ နတ် သ မား က ဖမ်း ကိုင် လိုက် သည် ။
[2021-05-28 14:19:58] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 14:19:58] Best translation 160 : ဒု တိ ယ အ ကြိမ် ရ ထား လမ်း ကို မြန် မာ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ဖြ င့် အ သုံး ပြု ခဲ့ သော လမ်း ကို ပိတ် ထား ပါ သည် ။
[2021-05-28 14:20:03] Best translation 320 : အန် ဆီ ယံ အ တွင်း ဝင် ရောက် လာ တဲ့ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ ဟာ ဩ စ တြေး လျ အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 14:20:30] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 14:20:37] Total translation time: 53.23133s
[2021-05-28 14:20:37] [valid] Ep. 15 : Up. 115000 : bleu : 16.5294 : stalled 3 times (last best: 16.6823)
...
...
...
[2021-05-28 16:00:52] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 16:00:54] Saving model weights and runtime parameters to model.s2s-4/model.iter120000.npz
[2021-05-28 16:00:55] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 16:00:57] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 16:01:09] [valid] Ep. 15 : Up. 120000 : cross-entropy : 154.03 : stalled 9 times (last best: 148.65)
[2021-05-28 16:01:18] [valid] Ep. 15 : Up. 120000 : perplexity : 13.7855 : stalled 9 times (last best: 12.5784)
[2021-05-28 16:01:18] Translating validation set...
[2021-05-28 16:01:30] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း သော် လည်း ရန် သူ နှ င့် ဘာ သာ ရေး ကို ထိ ခိုက် စေ မ ည့် အ မွေ တစ် ခု ပင် ဖြစ် သည် ။
[2021-05-28 16:01:30] Best translation 1 : ယ ခု အ ခါ ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ဘက် ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် စ တန် လီ ကျွန်း တွင် တိုက် ခိုက် ခံ ရ သ ည့် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် တစ် ခု တွင် တိုက် ခိုက် ခံ ရ ပြီး စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် သည် လည်း သေ ဆုံး ကြောင်း အ စီ ရင် ခံ ခဲ့ သည် ။
[2021-05-28 16:01:30] Best translation 2 : ဒုံး ကျည် တွေ ကို လေ ယာဉ် မောင်း သူ တွေ က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 16:01:30] Best translation 3 : ဒီ လူ တွေ အ စား ပြန် ထုတ် လုပ် နိုင် တဲ့ စွမ်း ရည် ရှိ တယ် &quot; လို့ အ နောက် ဘက် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 16:01:34] Best translation 4 : အယ် ကိုင် ဒါ ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို သည် ။
[2021-05-28 16:01:34] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ သေ ဆုံး မှု နှ င့် ပတ် သက် ၍ မ သိ ကြောင်း ပြော သည် ။
[2021-05-28 16:01:34] Best translation 10 : ၁ နာ ရီ ခွဲ တွင် လော့စ် အိန် ဂျ လိစ် က မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-28 16:01:34] Best translation 20 : ဝါ ရှင် တန် ၊ ဒီ စီ တွင် အ ခြေ စိုက် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အန် အို အေ အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ တွင်း သု တေ သ န ပြု ဆောင် ရွက် လျက် ရှိ တယ် ။
[2021-05-28 16:01:34] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် ဖြ င့် သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး ပမ်း ခဲ့ သော သေ နတ် သ မား က သူ့ ကို ဖမ်း ကိုင် လိုက် သည် ။
[2021-05-28 16:01:34] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် မှာ ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ပြီး မဲ ပေး ခွ င့် ရှိ သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 16:01:34] Best translation 160 : ဒု တိ ယ အ ကြိမ် မြောက် မက် ဆစ် ဒ နီ က အိန္ဒိ ယ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား ပေါ် မှာ အ သုံး ပြု တဲ့ လမ်း ကို ပိတ် ထား ပါ တယ် ။
[2021-05-28 16:01:38] Best translation 320 : အန် ဆီ ယံ အ တွင်း ဝင် ရောက် လာ တဲ့ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ ဟာ ဩ စ တြေး လျ အ ရင်း အ မြစ် နဲ့ ရေ အ ရည် အ သွေး တွေ အား လုံး ပါ ဝင် ပါ တယ် ။
[2021-05-28 16:02:05] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 16:02:12] Total translation time: 54.35954s
[2021-05-28 16:02:12] [valid] Ep. 15 : Up. 120000 : bleu : 16.4408 : stalled 4 times (last best: 16.6823)
...
...
...
[2021-05-28 17:44:40] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 17:44:42] Saving model weights and runtime parameters to model.s2s-4/model.iter125000.npz
[2021-05-28 17:44:43] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 17:44:45] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz
[2021-05-28 17:44:57] [valid] Ep. 16 : Up. 125000 : cross-entropy : 154.988 : stalled 10 times (last best: 148.65)
[2021-05-28 17:45:06] [valid] Ep. 16 : Up. 125000 : perplexity : 14.0124 : stalled 10 times (last best: 12.5784)
[2021-05-28 17:45:06] Translating validation set...
[2021-05-28 17:45:17] Best translation 0 : &quot; သူ ဆုံး ရှုံး မှု အ တွက် ဝမ်း နည်း နေ သော် လည်း ရန် သူ နှ င့် ဘာ သာ ရေး ကို ထိ ခိုက် စေ မ ည့် အ မွေ တစ် ခု ကျန် ခဲ့ သည် ။
[2021-05-28 17:45:17] Best translation 1 : ယ ခု အ ခါ ပါ ကစ္စ တန် နိုင် ငံ ၏ မြောက် ဘက် ဝါ ဇီ ရီ တန် နိုင် ငံ မြောက် ပိုင်း ဝါ ဇီ ရီ တန် စ တန် လီ ကျွန်း ပေါ် တွင် တိုက် ခိုက် ခံ ရ သ ည့် အ မေ ရိ ကန် ပြည် ထောင် စု ဒုံး ကျည် က တိုက် ခိုက် ခံ ရ ပြီး ယ ခု အ ခါ စစ် သွေး ကြွ တစ် ဒါ ဇင် ခ န့် က လည်း သေ ဆုံး ကြောင်း သိ ရှိ ရ ပါ သည် ။
[2021-05-28 17:45:19] Best translation 2 : ဒုံး ကျည် တွေ ကို လေ ယာဉ် မောင်း သူ တွေ က ပစ် ခတ် ခဲ့ တယ် လို့ ပါ ကစ္စ တန် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 17:45:19] Best translation 3 : ဒီ လူ ငယ် တွေ အ စား ပြန် ထုတ် လုပ် နိုင် တဲ့ စွမ်း ရည် ရှိ တယ် &quot; လို့ အ နောက် ဘက် ထောက် လှမ်း ရေး အ ရာ ရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-05-28 17:45:21] Best translation 4 : အယ် ကိုင် ဒါ ၏ တ တိ ယ အ များ ဆုံး အ ဆ င့် မြ င့် အ ဖွဲ့ ဝင် ဖြစ် သည် ဟု ဆို ကြ သည် ။
[2021-05-28 17:45:21] Best translation 5 : ပါ ကစ္စ တန် အ စိုး ရ က သူ သေ ဆုံး မှု နှ င့် ပတ် သက် ၍ မ သိ ကြောင်း ပြော သည် ။
[2021-05-28 17:45:21] Best translation 10 : ၁ နာ ရီ ခွဲ တွင် လော့စ် အိန် ဂျ လိစ် က မှတ် တမ်း တင် ခဲ့ သည် ။
[2021-05-28 17:45:21] Best translation 20 : ဝါ ရှင် တန် ၊ ဒီ စီ တွင် အ ခြေ စိုက် အ မေ ရိ ကန် စီး ပွား ရေး ဦး စီး ဌာ န တစ် ခု ဖြစ် သ ည့် အန် အို အေ အေ က သ ဘာ ဝ ပတ် ဝန်း ကျင် နှ င့် လေ ထု အ တွင်း သု တေ သ န ပြု လုပ် ထား သ ည့် အ ချက် အ လက် များ ဖြစ် တယ် ။
[2021-05-28 17:45:21] Best translation 40 : သူ့ ကို သေ နတ် ဖြ င့် ဖမ်း ကိုင် ထား သ ည့် သေ နတ် သ မား က သူ မ အား အ ကူ အ ညီ ပေး ရန် ကြိုး ပမ်း ခဲ့ သော သေ နတ် သ မား က ဖမ်း ကိုင် လိုက် သည် ။
[2021-05-28 17:45:21] Best translation 80 : မဲ ပေး သူ အ ရေ အ တွက် သည် ၅၀ ရာ ခိုင် နှုန်း ထက် နည်း ၍ မဲ ပေး သူ အား လုံး ထံ မှ အ နည်း ဆုံး ၃၃ % လို အပ် ပါ သည် ။
[2021-05-28 17:45:21] Best translation 160 : ဒု တိ ယ ရ ထား လေ ယာဉ် က အိန္ဒိ ယ နိုင် ငံ ဆစ် ဒ နီ ပ စိ ဖိတ် ခ ရီး သည် တင် ရ ထား နဲ့ အ တူ အ သုံး ပြု တဲ့ လမ်း ကို ပိတ် လိုက် ပြီ ။
[2021-05-28 17:45:26] Best translation 320 : အန် ဆီ ယံ အ တွင်း ဝင် ရောက် လာ တဲ့ ကျွန် တော် တို့ ရဲ့ စံ ပြ ပုံ စံ ဟာ ဩ စ တြေး လျ ရဲ့ အ ပူ ရှိန် ၊ အ ပူ ရှိန် ၊ အ ပူ ရှိန် နဲ့ ရေ အ ရည် တွေ ပါ ဝင် ပါ တယ် ။
[2021-05-28 17:45:53] Best translation 640 : ဇွန် လ ၇ ရက် နေ့ ည နေ ၇ နာ ရီ ခွဲ တွင် အ ရေး ပေါ် အ ခြေ အ နေ ကို လက် ခံ ရ ရှိ ခဲ့ သည် ။
[2021-05-28 17:46:00] Total translation time: 53.94386s
[2021-05-28 17:46:00] [valid] Ep. 16 : Up. 125000 : bleu : 16.5862 : stalled 5 times (last best: 16.6823)
[2021-05-28 17:46:01] Training finished
[2021-05-28 17:46:03] Saving model weights and runtime parameters to model.s2s-4/model.npz.orig.npz
[2021-05-28 17:46:05] Saving model weights and runtime parameters to model.s2s-4/model.npz
[2021-05-28 17:46:07] Saving Adam parameters to model.s2s-4/model.npz.optimizer.npz

real	2554m15.971s
user	4156m44.100s
sys	1m49.007s

real	2554m15.995s
user	4156m44.110s
sys	1m49.021s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ 
```

## Translation

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4$ time marian-decoder -m ./model.npz -v ../data/vocab/vocab.en.yml ../data/vocab/vocab.my.yml --devices 0 1 --output hyp.model.my < ../data/test.en 
...
...
...
[2021-05-28 18:36:16] Best translation 975 : သို့ သော် လည်း ခ ရစ် အ မတ် သည် ပြိုင် ပွဲ ၏ ဒု တိ ယ မြောက် ကြိုး စား အား ထုတ် ခဲ့ ရာ သြ စ တြေး လျ ၏ စ တုတ္ထ မြောက် ကြိုး စား အား ထုတ် မှု နှ င့် အ ပို ဆု ကြေး ငွေ ကို လုံ ခြုံ စိတ် ချ စွာ ရ ယူ နိုင် ခဲ့ သည် ။
[2021-05-28 18:36:16] Best translation 976 : ရှိန်း ဝီ လီ ယမ်စ် က ဝေ လ နယ် မှာ ဝေ လ နယ် အ တွက် အ ပြင်း အ ထန် ကြိုး စား တယ် ၊ ဒါ ပေ မဲ့ မိ နစ် ပိုင်း အ တွင်း ဝေ လ နယ် မှာ လည်း ဝေ လ ငါး ပွဲ အ နိုင် ရ ခဲ့ တယ် ၊ ဒါ ပေ မဲ့ ဩ စ တြေး လျ နိုင် ငံ က လည်း ၁၂ မှတ် နဲ့ အ နိုင် ရ ခဲ့ တယ် ။
[2021-05-28 18:36:16] Best translation 977 : ဝေ လ ပြည် နယ် သည် အ ချက် ၅ ချက် နှ င့် ဒု တိ ယ အ ချက် ၅ ချက် ပါ ဝင် ပြီး ဂျ ပန် နိုင် ငံ တွင် အ ချက် တစ် ချက် နှ င့် က နေ ဒါ နိုင် ငံ ၏ အ ချက် အ ချာ နေ ရာ တွင် က နေ ဒါ နိုင် ငံ ၏ အ ချက် အ ချာ နေ ရာ တွင် ရှိ နေ သည် ။
[2021-05-28 18:36:16] Best translation 978 : ၁၇ မိ နစ် အ တွင်း ပ ထ မ ပိုင်း တွင် သာ အ ကောင်း ဆုံး ကြိုး စား ခဲ့ ပါ သည် ။
[2021-05-28 18:36:17] Best translation 979 : ဂျော် ဂျီ ယာ အ တွက် ပ ထ မ ပိုင်း တစ် ဝက် တွင် ရက် အ နည်း ငယ် အ တွင်း မှ ပင် ပြစ် ဒဏ် ဘော တစ် လုံး ရ ရှိ ခဲ့ သည် ။
[2021-05-28 18:36:17] Best translation 980 : ဂျော် ဂျီ ယာ သည် ၄၅ မိ နစ် အ တွင်း အ ပြင်း အ ထန် ကြိုး စား မှု တစ် ခု ရ ရှိ ချိန် တွင် ဂျော် ဂျီ ယာ သည် ၄၅ မိ နစ် အ တွင်း အံ့ အား သ င့် သွား ခဲ့ သည် ။
[2021-05-28 18:36:17] Best translation 981 : လွတ် ငြိမ်း ချမ်း သာ ခွ င့် ရ ရှိ သ ည့် အ ချိန် မှ စ ၍ အိုင် ယာ လန် နိုင် ငံ နှ င့် အ ခြား သော အ မေ ရိ ကန် ပြည် ထောင် စု လွှတ် တော် အ တွက် အ မှတ် တ ရ နေ ရာ မှ ရ ရှိ သော ပုံ စံ မျိုး ဖြ င့် သာ ရ ရှိ သည် ။
[2021-05-28 18:36:17] Best translation 982 : ဂျော် ဂျီ ယာ သည် က စား ပွဲ ၏ နောက် ပိုင်း အ ဆ င့် များ တွင် အိုင် ယာ လန် အ ပေါ် ဖိ အား ပေး မှု ကို ထိန်း သိမ်း ထား သော် လည်း အိုင် ယာ လန် ကို ဖြတ် ၍ အိုင် ယာ လန် နိုင် ငံ ကို ဖြတ် ကာ အိုင် ယာ လန် နိုင် ငံ ကို ဖြတ် သန်း နိုင် ခဲ့ ခြင်း မ ရှိ ပေ ။
[2021-05-28 18:36:17] Best translation 983 : အိုင် ယာ လန် သည် အာ ဂျင် တီး နား နောက် က ၈ မှတ် ဖြ င့် အ မှတ် ၈ မှတ် ဖြ င့် ဒု တိ ယ ရ ရှိ သည် ။
[2021-05-28 18:36:18] Best translation 984 : သူ တို့ တစ် ယောက် တည်း ပြိုင် ပွဲ မှာ ပြင် သစ် က တစ် ခု တည်း သော အ ချက် တစ် ချက် နဲ့ တ တိ ယ မြောက် အ ချက် တစ် ချက် ရှိ တယ် ။
[2021-05-28 18:36:18] Best translation 985 : ဆပ် ကပ် ဆင် တစ် ယောက် သည် ဇူး ရစ် မြို့ မြို့ တော် ၌ တ နင်္ဂ နွေ ည က သူ မ ၏ အ ယူ အ ဆ ကို ပြန် လည် သိမ်း ယူ နိုင် ခဲ့ ပြီး ဆက် ကပ် လှူ ဒါန်း ခံ ရ ခြင်း မ ပြု မီ ဆွစ် ဇာ လန် နိုင် ငံ မြို့ တော် တွင် သူ မ ၏ အ ယူ အ ဆ ကို ပြန် လည် သိမ်း ယူ နိုင် ခဲ့ သည် ။
[2021-05-28 18:36:18] Best translation 986 : အ မည် မ သိ အ မျိုး သ မီး ဆင် သည် ဆွစ် ဇာ လန် နိုင် ငံ မှ လွတ် မြောက် လာ သည် ။
[2021-05-28 18:36:18] Best translation 987 : အ ရေး ပေါ် အ ခြေ အ နေ မ တင် ခင် လေး မှာ သူ မ လွတ် မြောက် အောင် လုပ် နိုင် ခဲ့ တယ် ။
[2021-05-28 18:36:18] Best translation 988 : ကျိုက္ခ မီ ဒေ သ စံ တော် ချိန် မွန်း လွဲ ၁ နာ ရီ ၄၅ မိ နစ် ခ န့် တွင် အ ဆို ပါ မြို့ တော် လမ်း ပေါ် သို့ လမ်း မ ကြီး ဘေး သို့ ပြန် လျှောက် ၍ လမ်း မ လျှောက် မီ အ ချိန် တို အ တွင်း ထွက် ပေါ် လာ ခဲ့ သည် ။
[2021-05-28 18:36:18] Best translation 989 : ဇူး ရစ် မြို့ မှ ကုန် တိုက် အ များ ဆုံး ဈေး ဝယ် လမ်း အ ဖြစ် လူ သိ များ သည် ဟု ဇူး ရစ် ရဲ က ပြော ခဲ့ သည် ။
[2021-05-28 18:36:19] Best translation 990 : သူ မ သည် မြို့ တော် မှ အ ငြိမ်း စား ရ ထား ဘူ တာ ( ရန် ကုန် ) နှ င့် အ မေ ရိ ကန် ပြည် ထောင် စု မှ လွှတ် တော် ကိုယ် စား လှယ် တ ရာ ကုန် စ တု ရန်း မီ တာ ကုန် ကျ စ ခန်း ဖြစ် သည် ။
[2021-05-28 18:36:19] Best translation 991 : တစ် နာ ရီ နီး ပါး ကြာ ပြီ ဖြစ် သော ကြော င့် ရဲ က မြို့ တော် ပတ် လည် တွင် တည် ငြိမ် စွာ ပြန် လည် သိမ်း ယူ ခဲ့ သည် ။
[2021-05-28 18:36:19] Best translation 992 : ဆပ် ကပ် အ ရာ ရှိ များ နှ င့် ရဲ တပ် ဖွဲ့ ဝင် များ လိုက် ပါ သွား ကြ သည် ၊ သို့ သော် ဆပ် ကပ် ပြော ရေး ဆို ခွ င့် ရှိ သူ တစ် ဦး က ဆက် ပြော ပြော ဆို ရာ တွင် ဆက် ကပ် ပြော ဆို မှု မ ပြု ကြောင်း ပြော ကြား သည် ။
[2021-05-28 18:36:19] Best translation 993 : ရာ သီ ဥ တု တော် တော် မြန် မြန် ရွေ့ လျား နေ သည် ဟု ပြော ကြ သည် ။
[2021-05-28 18:36:20] Best translation 994 : ၂၀၀၀ ခု နှစ် ဒေ သ စံ တော် ချိန် ၂၀၀၀ ခ န့် တွင် ဂိုး သ မား တစ် ယောက် သည် တိ ရစ္ဆာန် ကို ထိန်း ချုပ် နိုင် ခဲ့ ပြီး အ ခြား ဆပ် ကပ် နေ ထိုင် သော တိ ရစ္ဆာန် များ ကို သူ မ ထံ သို့ ပို့ ပေး နိုင် ခဲ့ သည် ။
[2021-05-28 18:36:20] Best translation 995 : အ ဆို ပါ ဖြစ် စဉ် အ တွင်း ပျက် စီး ဆုံး ရှုံး မှု များ သို့ မ ဟုတ် ထိ ခိုက် ဒဏ် ရာ ရ ရှိ မှု အ စီ ရင် ခံ စာ များ မ ရှိ ခဲ့ သော် လည်း ရဲ များ က ရပ် ကြ ည့် နေ သော် လည်း အ နည်း ဆုံး တစ် ကြိမ် ဗွီ ဒီ ယို ဖမ်း ဆီး နိုင် ခဲ့ သည် ။
[2021-05-28 18:36:20] Best translation 996 : ဆိပ် ကမ်း နား က မုန် တိုင်း ကြော င့် လ ပြေင်း မုန် တိုင်း ကြော င့် လွတ် မြောက် သွား ပြီ လို့ ဆပ် ကပ် က ပြော တယ် ။
[2021-05-28 18:36:20] Best translation 997 : ဆပ် ကပ် ပွဲ သို့ ပြန် လာ ပြီး နောက် သူ မ မော ပန်း နေ သည် ဟု ပြော လေ သည် ၊ သို့ သော် ပြန် ရောက် ရ သ ည့် အ တွက် ဝမ်း သာ ပါ သည် ။
[2021-05-28 18:36:20] Best translation 998 : ဒတ် ချ် လူ မျိုး အ မျိုး သား လွှတ် တော် ( ၈၁ ) မှ က ဗျာ ဆ ရာ တော် နှ င့် သူ ၏ ဇ နီး ဒေါ် ဒွဲ ( ၇၈ ) တို့ သည် တောင် ဝေ လ ပြည် နယ် မှ ဆယ် ရက် အ ထိ ကား တိုက် မှု တွင် ပါ ဝင် ပတ် သက် ခဲ့ သည် ။
[2021-05-28 18:36:20] Best translation 999 : မစ္စ တာ ရက် ရော ဂါ သည် ချက် ချင်း သေ ဆုံး သွား ခဲ့ သည် ၊ မစ္စ တာ ရော ဂါ သည် ကျိုး သွား ခဲ့ သည် ။
[2021-05-28 18:36:20] Best translation 1000 : သူ တို့ နှစ် ဦး စ လုံး ပေး ထား တဲ့ က ဗျာ ဖတ် ပွဲ က နေ ပြန် လာ တာ ။
[2021-05-28 18:36:21] Best translation 1001 : အ ရက် ဆိုင် ရာ လွတ် လပ် မှု ဟာ တောင် ဝေ လ ပြည် ထဲ မှာ နေ ထိုင် တဲ့ ဂျူး လူ မျိုး ရေး စာ ရေး ဆ ရာ တစ် ဦး ပါ ။
[2021-05-28 18:36:21] Best translation 1002 : ဂျုံး သည် အ နု ပ ညာ သ မိုင်း နှ င့် စာ ရေး ဆ ရာ တစ် ဦး ဖြစ် သည် ။
[2021-05-28 18:36:21] Best translation 1003 : ကျန်း မာ ရေး ဆ ရာ ဝန် နှ င့် ဆေး ဘက် ဆိုင် ရာ ဆ ရာ ဝန် တစ် ဦး အ ဖြစ် လူ သိ များ ကြ သည် ။
[2021-05-28 18:36:21] Best translation 1004 : တ ကယ် တမ်း ကျ တော့ ရင် ဘတ် ဆေး ခန်း မှာ ပါ ရ ဂူ တစ် ယောက် ပါ ။
[2021-05-28 18:36:21] Best translation 1005 : သို့ သော် လွှတ် တော် အ မတ် သည် စာ ပေ ရေး သား ခြင်း အ တွက် အ ကောင်း ဆုံး ဖြစ် ပြီး စာ ပေ ဆု များ နှ င့် အ မတ် တော် တော် များ များ လက် ခံ ရ ရှိ ခဲ့ ပါ သည် ။
[2021-05-28 18:36:21] Best translation 1006 : ၁၉၈၉ ခု နှစ် တွင် ဝေ လ နယ် တက္က သိုလ် မှ ဂုဏ် ထူး ဆောင် ဘွဲ့ ရ ရှိ သည် ။
[2021-05-28 18:36:21] Best translation 1007 : စုံ တွဲ ဟာ ၁၉၈၀ တုန်း က တည်း က တည်း က တည်း က တည်း က တည်း ဖြတ် ခဲ့ ကြ တယ် ။
[2021-05-28 18:36:21] Best translation 1008 : ဂျုံး သည် သူ မ ခင် ပွန်း ၊ သား တစ် ယောက် ၊ သ မီး နှစ် ယောက် ကျန် ရစ် သည် ။
[2021-05-28 18:36:22] Best translation 1009 : ပါ ရာ ဂွေး အ သင်း ၏ အ ဖွဲ့ ဝင် လေး ဦး အား ဖမ်း ဆီး ရ မိ ပြီး ကယ် လီ ဖိုး နီး ယား ၏ အိမ် ကြီး အိမ် ကောင်း ဖြစ် ပြီး နောက် ကယ် လီ ဖိုး နီး ယား တောင် တန်း ကြီး များ အ နီး တွင် တ ရား စွဲ ဆို ခံ ရ ပြီး နောက် ကယ် လီ ဖိုး နီး ယား နိုင် ငံ ၏ အိမ် ကြီး အိမ် ကြီး တွင် တ ရား စွဲ ဆို ခံ ရ သည် ။
[2021-05-28 18:36:22] Best translation 1010 : ရဲ များ က လည်း ရဲ တပ် ဖွဲ့ ဝင် အ နည်း ဆုံး ၄ ဦး အား ဖမ်း ဆီး ခဲ့ သော် လည်း အ ဖမ်း မ ခံ ရ ပေ ။
[2021-05-28 18:36:22] Best translation 1011 : သ တင်း များ အ ရ မြန် မာ နိုင် ငံ ရဲ တပ် ဖွဲ့ မှ အ ဆို ပါ အ ဖြစ် အ ပျက် တစ် ခု လုံး သည် ည ၁၁ နာ ရီ မိ နစ် ၂၀ ဝန်း ကျင် အ ရှိန် မြ င့် မား ပြီး ည ၁၁ နာ ရီ မိ နစ် ၂၀ ဝန်း ကျင် အ ရှိန် အ ဟုန် ဖြ င့် စ နစ် တ ကျ စီ စဉ် ဆောင် ရွက် လျက် ရှိ ပါ သည် ။
[2021-05-28 18:36:22] Best translation 1012 : သူ တို့ က သူ မ အ ပေါ် မှာ အ လွန် နီး ကပ် စွာ ဆက် ဆံ ပြီး သူ မ နောက် လိုက် လာ တဲ့ လမ်း ကျဉ်း တွေ ကို သူ တို့ လိုက် လုပ် ကြ တယ် လို့ ပြော ကြ တယ် ။
[2021-05-28 18:36:22] Best translation 1013 : ရဲ တပ် ဖွဲ့ က လည်း ကား မောင်း နေ စဉ် ကား ကို မောင်း ထုတ် ရန် ကြိုး စား ခဲ့ သော် လည်း ကား ကို မ သတ် မှတ် နိုင် ခဲ့ ပါ ဟု ရဲ တပ် ဖွဲ့ က ပြော သည် ။
[2021-05-28 18:36:22] Best translation 1014 : သူ တို့ သည် သူ မ ၏ မည် သူ မည် ဝါ ဖြစ် ကြောင်း မှတ် တမ်း တင် ပြီး ထုတ် ပြန် ကြေ ညာ ခဲ့ သည် ။
[2021-05-28 18:36:23] Best translation 1015 : တ ရား ဝင် ထုတ် ပြန် သ ည့် အ စီ ရင် ခံ စာ အ ရ ရဲ တပ် ဖွဲ့ က သူ မ ၏ လိုင် စင် သက် တမ်း တ ရား ဝင် သည် ကို တွေ့ ရှိ ရ သ ည့် အ ပြင် ရဲ တပ် ဖွဲ့ က စစ် ဆေး နေ ဆဲ ဖြစ် သည် ။
[2021-05-28 18:36:23] Best translation 1016 : စ ပီ ယာ သည် အ မျိုး သား များ ကို မ ဆင် မ ခြင် သယ် ယူ သော် လည်း အ မျိုး သား များ အား ဖမ်း ဆီး ခြင်း မ ပြု ခဲ့ ပါ ။
[2021-05-28 18:36:23] Best translation 1017 : တ ကယ် လို့ အဲ ဒီ အုပ် စု ရဲ့ အ စိတ် အ ပိုင်း တစ် ခု ပါ ပဲ ၊ ဒါ ပေ မဲ့ အ လုပ် က ထွက် မ မောင်း ပါ ဘူး ဟု လော့စ် အိန် ဂျ လိစ် ရဲ ဌာ န မှ ပြော ရေး ဆို ခွ င့် ရှိ သူ ဆာ ရာ အာ ရာ က ပြော ပါ သည် ။
[2021-05-28 18:36:23] Total time: 205.76086s wall

real	3m27.867s
user	6m50.738s
sys	0m2.547s
```

## Evaluation

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ../data/test.my < ./hyp.model.my  >> results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4$ cat results.txt 
BLEU = 17.00, 55.2/30.3/18.0/11.2 (BP=0.705, ratio=0.741, hyp_len=43651, ref_len=58895)
```

## System-2: Transformer (en-my, word-syl)

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:/media/ye/SP PHD U3/backup/marian/wat2021/exp-syl4$ cp transformer.sh /home/ye/exp/nmt/plus-alt/
```

## Script

```
#!/bin/bash

#     --mini-batch-fit -w 10000 --maxi-batch 1000 \
#    --mini-batch-fit -w 1000 --maxi-batch 100 \
#     --tied-embeddings-all \ 
#     --tied-embeddings \
#     --valid-metrics cross-entropy perplexity translation bleu \
#     --transformer-dropout 0.1 --label-smoothing 0.1 \
#     --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
#     --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \

mkdir model.transformer;

marian \
    --model model.transformer/model.npz --type transformer \
    --train-sets data/train.en data/train.my \
    --max-length 200 \
    --vocabs data/vocab/vocab.en.yml data/vocab/vocab.my.yml \
    --mini-batch-fit -w 1000 --maxi-batch 100 \
    --early-stopping 10 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics cross-entropy perplexity bleu \
    --valid-sets data/valid.en data/valid.my \
    --valid-translation-output data/valid.en-my.output --quiet-translation \
    --valid-mini-batch 64 \
    --beam-size 6 --normalize 0.6 \
    --log model.transformer/train.log --valid-log model.transformer/valid.log \
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
    --dump-config > model.transformer/config.yml
    
time marian -c model.transformer/config.yml  2>&1 | tee transformer-enmy.log
```

## Training Log

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ time ./transformer.sh 
[2021-05-28 19:13:27] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-28 19:13:27] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 62252 with command line:
[2021-05-28 19:13:27] [marian] marian -c model.transformer/config.yml
[2021-05-28 19:13:27] [config] after: 0e
[2021-05-28 19:13:27] [config] after-batches: 0
[2021-05-28 19:13:27] [config] after-epochs: 0
[2021-05-28 19:13:27] [config] all-caps-every: 0
[2021-05-28 19:13:27] [config] allow-unk: false
[2021-05-28 19:13:27] [config] authors: false
[2021-05-28 19:13:27] [config] beam-size: 6
[2021-05-28 19:13:27] [config] bert-class-symbol: "[CLS]"
[2021-05-28 19:13:27] [config] bert-mask-symbol: "[MASK]"
[2021-05-28 19:13:27] [config] bert-masking-fraction: 0.15
[2021-05-28 19:13:27] [config] bert-sep-symbol: "[SEP]"
[2021-05-28 19:13:27] [config] bert-train-type-embeddings: true
[2021-05-28 19:13:27] [config] bert-type-vocab-size: 2
[2021-05-28 19:13:27] [config] build-info: ""
[2021-05-28 19:13:27] [config] cite: false
[2021-05-28 19:13:27] [config] clip-norm: 5
[2021-05-28 19:13:27] [config] cost-scaling:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] cost-type: ce-sum
[2021-05-28 19:13:27] [config] cpu-threads: 0
[2021-05-28 19:13:27] [config] data-weighting: ""
[2021-05-28 19:13:27] [config] data-weighting-type: sentence
[2021-05-28 19:13:27] [config] dec-cell: gru
[2021-05-28 19:13:27] [config] dec-cell-base-depth: 2
[2021-05-28 19:13:27] [config] dec-cell-high-depth: 1
[2021-05-28 19:13:27] [config] dec-depth: 2
[2021-05-28 19:13:27] [config] devices:
[2021-05-28 19:13:27] [config]   - 0
[2021-05-28 19:13:27] [config]   - 1
[2021-05-28 19:13:27] [config] dim-emb: 512
[2021-05-28 19:13:27] [config] dim-rnn: 1024
[2021-05-28 19:13:27] [config] dim-vocabs:
[2021-05-28 19:13:27] [config]   - 0
[2021-05-28 19:13:27] [config]   - 0
[2021-05-28 19:13:27] [config] disp-first: 0
[2021-05-28 19:13:27] [config] disp-freq: 500
[2021-05-28 19:13:27] [config] disp-label-counts: true
[2021-05-28 19:13:27] [config] dropout-rnn: 0
[2021-05-28 19:13:27] [config] dropout-src: 0
[2021-05-28 19:13:27] [config] dropout-trg: 0
[2021-05-28 19:13:27] [config] dump-config: ""
[2021-05-28 19:13:27] [config] early-stopping: 10
[2021-05-28 19:13:27] [config] embedding-fix-src: false
[2021-05-28 19:13:27] [config] embedding-fix-trg: false
[2021-05-28 19:13:27] [config] embedding-normalization: false
[2021-05-28 19:13:27] [config] embedding-vectors:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] enc-cell: gru
[2021-05-28 19:13:27] [config] enc-cell-depth: 1
[2021-05-28 19:13:27] [config] enc-depth: 2
[2021-05-28 19:13:27] [config] enc-type: bidirectional
[2021-05-28 19:13:27] [config] english-title-case-every: 0
[2021-05-28 19:13:27] [config] exponential-smoothing: 0.0001
[2021-05-28 19:13:27] [config] factor-weight: 1
[2021-05-28 19:13:27] [config] grad-dropping-momentum: 0
[2021-05-28 19:13:27] [config] grad-dropping-rate: 0
[2021-05-28 19:13:27] [config] grad-dropping-warmup: 100
[2021-05-28 19:13:27] [config] gradient-checkpointing: false
[2021-05-28 19:13:27] [config] guided-alignment: none
[2021-05-28 19:13:27] [config] guided-alignment-cost: mse
[2021-05-28 19:13:27] [config] guided-alignment-weight: 0.1
[2021-05-28 19:13:27] [config] ignore-model-config: false
[2021-05-28 19:13:27] [config] input-types:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] interpolate-env-vars: false
[2021-05-28 19:13:27] [config] keep-best: false
[2021-05-28 19:13:27] [config] label-smoothing: 0.1
[2021-05-28 19:13:27] [config] layer-normalization: false
[2021-05-28 19:13:27] [config] learn-rate: 0.0003
[2021-05-28 19:13:27] [config] lemma-dim-emb: 0
[2021-05-28 19:13:27] [config] log: model.transformer/train.log
[2021-05-28 19:13:27] [config] log-level: info
[2021-05-28 19:13:27] [config] log-time-zone: ""
[2021-05-28 19:13:27] [config] logical-epoch:
[2021-05-28 19:13:27] [config]   - 1e
[2021-05-28 19:13:27] [config]   - 0
[2021-05-28 19:13:27] [config] lr-decay: 0
[2021-05-28 19:13:27] [config] lr-decay-freq: 50000
[2021-05-28 19:13:27] [config] lr-decay-inv-sqrt:
[2021-05-28 19:13:27] [config]   - 16000
[2021-05-28 19:13:27] [config] lr-decay-repeat-warmup: false
[2021-05-28 19:13:27] [config] lr-decay-reset-optimizer: false
[2021-05-28 19:13:27] [config] lr-decay-start:
[2021-05-28 19:13:27] [config]   - 10
[2021-05-28 19:13:27] [config]   - 1
[2021-05-28 19:13:27] [config] lr-decay-strategy: epoch+stalled
[2021-05-28 19:13:27] [config] lr-report: true
[2021-05-28 19:13:27] [config] lr-warmup: 0
[2021-05-28 19:13:27] [config] lr-warmup-at-reload: false
[2021-05-28 19:13:27] [config] lr-warmup-cycle: false
[2021-05-28 19:13:27] [config] lr-warmup-start-rate: 0
[2021-05-28 19:13:27] [config] max-length: 200
[2021-05-28 19:13:27] [config] max-length-crop: false
[2021-05-28 19:13:27] [config] max-length-factor: 3
[2021-05-28 19:13:27] [config] maxi-batch: 100
[2021-05-28 19:13:27] [config] maxi-batch-sort: trg
[2021-05-28 19:13:27] [config] mini-batch: 64
[2021-05-28 19:13:27] [config] mini-batch-fit: true
[2021-05-28 19:13:27] [config] mini-batch-fit-step: 10
[2021-05-28 19:13:27] [config] mini-batch-track-lr: false
[2021-05-28 19:13:27] [config] mini-batch-warmup: 0
[2021-05-28 19:13:27] [config] mini-batch-words: 0
[2021-05-28 19:13:27] [config] mini-batch-words-ref: 0
[2021-05-28 19:13:27] [config] model: model.transformer/model.npz
[2021-05-28 19:13:27] [config] multi-loss-type: sum
[2021-05-28 19:13:27] [config] multi-node: false
[2021-05-28 19:13:27] [config] multi-node-overlap: true
[2021-05-28 19:13:27] [config] n-best: false
[2021-05-28 19:13:27] [config] no-nccl: false
[2021-05-28 19:13:27] [config] no-reload: false
[2021-05-28 19:13:27] [config] no-restore-corpus: false
[2021-05-28 19:13:27] [config] normalize: 0.6
[2021-05-28 19:13:27] [config] normalize-gradient: false
[2021-05-28 19:13:27] [config] num-devices: 0
[2021-05-28 19:13:27] [config] optimizer: adam
[2021-05-28 19:13:27] [config] optimizer-delay: 1
[2021-05-28 19:13:27] [config] optimizer-params:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] output-omit-bias: false
[2021-05-28 19:13:27] [config] overwrite: false
[2021-05-28 19:13:27] [config] precision:
[2021-05-28 19:13:27] [config]   - float32
[2021-05-28 19:13:27] [config]   - float32
[2021-05-28 19:13:27] [config]   - float32
[2021-05-28 19:13:27] [config] pretrained-model: ""
[2021-05-28 19:13:27] [config] quantize-biases: false
[2021-05-28 19:13:27] [config] quantize-bits: 0
[2021-05-28 19:13:27] [config] quantize-log-based: false
[2021-05-28 19:13:27] [config] quantize-optimization-steps: 0
[2021-05-28 19:13:27] [config] quiet: false
[2021-05-28 19:13:27] [config] quiet-translation: true
[2021-05-28 19:13:27] [config] relative-paths: false
[2021-05-28 19:13:27] [config] right-left: false
[2021-05-28 19:13:27] [config] save-freq: 5000
[2021-05-28 19:13:27] [config] seed: 1111
[2021-05-28 19:13:27] [config] sentencepiece-alphas:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] sentencepiece-max-lines: 2000000
[2021-05-28 19:13:27] [config] sentencepiece-options: ""
[2021-05-28 19:13:27] [config] shuffle: data
[2021-05-28 19:13:27] [config] shuffle-in-ram: false
[2021-05-28 19:13:27] [config] sigterm: save-and-exit
[2021-05-28 19:13:27] [config] skip: false
[2021-05-28 19:13:27] [config] sqlite: ""
[2021-05-28 19:13:27] [config] sqlite-drop: false
[2021-05-28 19:13:27] [config] sync-sgd: true
[2021-05-28 19:13:27] [config] tempdir: /tmp
[2021-05-28 19:13:27] [config] tied-embeddings: true
[2021-05-28 19:13:27] [config] tied-embeddings-all: false
[2021-05-28 19:13:27] [config] tied-embeddings-src: false
[2021-05-28 19:13:27] [config] train-embedder-rank:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] train-sets:
[2021-05-28 19:13:27] [config]   - data/train.en
[2021-05-28 19:13:27] [config]   - data/train.my
[2021-05-28 19:13:27] [config] transformer-aan-activation: swish
[2021-05-28 19:13:27] [config] transformer-aan-depth: 2
[2021-05-28 19:13:27] [config] transformer-aan-nogate: false
[2021-05-28 19:13:27] [config] transformer-decoder-autoreg: self-attention
[2021-05-28 19:13:27] [config] transformer-depth-scaling: false
[2021-05-28 19:13:27] [config] transformer-dim-aan: 2048
[2021-05-28 19:13:27] [config] transformer-dim-ffn: 2048
[2021-05-28 19:13:27] [config] transformer-dropout: 0.3
[2021-05-28 19:13:27] [config] transformer-dropout-attention: 0
[2021-05-28 19:13:27] [config] transformer-dropout-ffn: 0
[2021-05-28 19:13:27] [config] transformer-ffn-activation: swish
[2021-05-28 19:13:27] [config] transformer-ffn-depth: 2
[2021-05-28 19:13:27] [config] transformer-guided-alignment-layer: last
[2021-05-28 19:13:27] [config] transformer-heads: 8
[2021-05-28 19:13:27] [config] transformer-no-projection: false
[2021-05-28 19:13:27] [config] transformer-pool: false
[2021-05-28 19:13:27] [config] transformer-postprocess: dan
[2021-05-28 19:13:27] [config] transformer-postprocess-emb: d
[2021-05-28 19:13:27] [config] transformer-postprocess-top: ""
[2021-05-28 19:13:27] [config] transformer-preprocess: ""
[2021-05-28 19:13:27] [config] transformer-tied-layers:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] transformer-train-position-embeddings: false
[2021-05-28 19:13:27] [config] tsv: false
[2021-05-28 19:13:27] [config] tsv-fields: 0
[2021-05-28 19:13:27] [config] type: transformer
[2021-05-28 19:13:27] [config] ulr: false
[2021-05-28 19:13:27] [config] ulr-dim-emb: 0
[2021-05-28 19:13:27] [config] ulr-dropout: 0
[2021-05-28 19:13:27] [config] ulr-keys-vectors: ""
[2021-05-28 19:13:27] [config] ulr-query-vectors: ""
[2021-05-28 19:13:27] [config] ulr-softmax-temperature: 1
[2021-05-28 19:13:27] [config] ulr-trainable-transformation: false
[2021-05-28 19:13:27] [config] unlikelihood-loss: false
[2021-05-28 19:13:27] [config] valid-freq: 5000
[2021-05-28 19:13:27] [config] valid-log: model.transformer/valid.log
[2021-05-28 19:13:27] [config] valid-max-length: 1000
[2021-05-28 19:13:27] [config] valid-metrics:
[2021-05-28 19:13:27] [config]   - cross-entropy
[2021-05-28 19:13:27] [config]   - perplexity
[2021-05-28 19:13:27] [config]   - bleu
[2021-05-28 19:13:27] [config] valid-mini-batch: 64
[2021-05-28 19:13:27] [config] valid-reset-stalled: false
[2021-05-28 19:13:27] [config] valid-script-args:
[2021-05-28 19:13:27] [config]   []
[2021-05-28 19:13:27] [config] valid-script-path: ""
[2021-05-28 19:13:27] [config] valid-sets:
[2021-05-28 19:13:27] [config]   - data/valid.en
[2021-05-28 19:13:27] [config]   - data/valid.my
[2021-05-28 19:13:27] [config] valid-translation-output: data/valid.en-my.output
[2021-05-28 19:13:27] [config] vocabs:
[2021-05-28 19:13:27] [config]   - data/vocab/vocab.en.yml
[2021-05-28 19:13:27] [config]   - data/vocab/vocab.my.yml
[2021-05-28 19:13:27] [config] word-penalty: 0
[2021-05-28 19:13:27] [config] word-scores: false
[2021-05-28 19:13:27] [config] workspace: 1000
[2021-05-28 19:13:27] [config] Model is being created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-28 19:13:27] Using synchronous SGD
[2021-05-28 19:13:27] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.en.yml
[2021-05-28 19:13:28] [data] Setting vocabulary size for input 0 to 85,602
[2021-05-28 19:13:28] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.my.yml
[2021-05-28 19:13:28] [data] Setting vocabulary size for input 1 to 12,379
[2021-05-28 19:13:28] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-05-28 19:13:28] [batching] Collecting statistics for batch fitting with step size 10
[2021-05-28 19:13:28] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-05-28 19:13:28] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-05-28 19:13:28] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-28 19:13:28] [comm] NCCLCommunicator constructed successfully
[2021-05-28 19:13:28] [training] Using 2 GPUs
[2021-05-28 19:13:28] [logits] Applying loss function for 1 factor(s)
[2021-05-28 19:13:28] [memory] Reserving 247 MB, device gpu0
[2021-05-28 19:13:28] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-05-28 19:13:28] [memory] Reserving 247 MB, device gpu0
[2021-05-28 19:13:53] [batching] Done. Typical MB size is 4,552 target words
[2021-05-28 19:13:53] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-05-28 19:13:53] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-05-28 19:13:53] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-28 19:13:53] [comm] NCCLCommunicator constructed successfully
[2021-05-28 19:13:53] [training] Using 2 GPUs
[2021-05-28 19:13:53] Training started
[2021-05-28 19:13:53] [data] Shuffling data
[2021-05-28 19:13:53] [data] Done reading 256,102 sentences
[2021-05-28 19:13:54] [data] Done shuffling 256,102 sentences to temp files
[2021-05-28 19:13:54] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-05-28 19:13:54] [memory] Reserving 247 MB, device gpu0
[2021-05-28 19:13:54] [memory] Reserving 247 MB, device gpu1
[2021-05-28 19:13:54] [memory] Reserving 247 MB, device gpu0
[2021-05-28 19:13:54] [memory] Reserving 247 MB, device gpu1
[2021-05-28 19:13:54] [memory] Reserving 123 MB, device gpu0
[2021-05-28 19:13:54] [memory] Reserving 123 MB, device gpu1
[2021-05-28 19:13:55] [memory] Reserving 247 MB, device gpu1
[2021-05-28 19:13:55] [memory] Reserving 247 MB, device gpu0
[2021-05-28 19:17:52] Ep. 1 : Up. 500 : Sen. 63,614 : Cost 5.41353178 * 1,857,078 @ 4,132 after 1,857,078 : Time 239.44s : 7755.77 words/s : L.r. 3.0000e-04
[2021-05-28 19:21:49] Ep. 1 : Up. 1000 : Sen. 126,940 : Cost 4.52651596 * 1,848,796 @ 3,867 after 3,705,874 : Time 236.91s : 7803.91 words/s : L.r. 3.0000e-04
[2021-05-28 19:25:45] Ep. 1 : Up. 1500 : Sen. 188,982 : Cost 4.23427629 * 1,833,285 @ 1,991 after 5,539,159 : Time 235.75s : 7776.39 words/s : L.r. 3.0000e-04
[2021-05-28 19:29:43] Ep. 1 : Up. 2000 : Sen. 252,806 : Cost 4.04271984 * 1,867,578 @ 2,925 after 7,406,737 : Time 237.93s : 7849.40 words/s : L.r. 3.0000e-04
[2021-05-28 19:29:53] Seen 255710 samples
[2021-05-28 19:29:53] Starting data epoch 2 in logical epoch 2
[2021-05-28 19:29:53] [data] Shuffling data
[2021-05-28 19:29:53] [data] Done reading 256,102 sentences
[2021-05-28 19:29:54] [data] Done shuffling 256,102 sentences to temp files
[2021-05-28 19:33:40] Ep. 2 : Up. 2500 : Sen. 60,892 : Cost 3.87755489 * 1,860,169 @ 2,193 after 9,266,906 : Time 236.77s : 7856.53 words/s : L.r. 3.0000e-04
[2021-05-28 19:37:31] Ep. 2 : Up. 3000 : Sen. 123,953 : Cost 3.76920891 * 1,836,427 @ 3,849 after 11,103,333 : Time 231.31s : 7939.41 words/s : L.r. 3.0000e-04
[2021-05-28 19:41:24] Ep. 2 : Up. 3500 : Sen. 187,020 : Cost 3.67700028 * 1,856,136 @ 2,248 after 12,959,469 : Time 232.62s : 7979.20 words/s : L.r. 3.0000e-04
[2021-05-28 19:45:16] Ep. 2 : Up. 4000 : Sen. 250,264 : Cost 3.60469365 * 1,845,756 @ 2,739 after 14,805,225 : Time 232.32s : 7944.82 words/s : L.r. 3.0000e-04
[2021-05-28 19:45:36] Seen 255710 samples
[2021-05-28 19:45:36] Starting data epoch 3 in logical epoch 3
[2021-05-28 19:45:36] [data] Shuffling data
[2021-05-28 19:45:36] [data] Done reading 256,102 sentences
[2021-05-28 19:45:37] [data] Done shuffling 256,102 sentences to temp files
[2021-05-28 19:49:09] Ep. 3 : Up. 4500 : Sen. 58,366 : Cost 3.49847150 * 1,840,699 @ 1,256 after 16,645,924 : Time 233.33s : 7888.94 words/s : L.r. 3.0000e-04
[2021-05-28 19:53:02] Ep. 3 : Up. 5000 : Sen. 121,258 : Cost 3.45338058 * 1,859,386 @ 4,093 after 18,505,310 : Time 232.68s : 7991.28 words/s : L.r. 3.0000e-04
[2021-05-28 19:53:02] Saving model weights and runtime parameters to model.transformer/model.npz.orig.npz
[2021-05-28 19:53:03] Saving model weights and runtime parameters to model.transformer/model.iter5000.npz
[2021-05-28 19:53:03] Saving model weights and runtime parameters to model.transformer/model.npz
[2021-05-28 19:53:04] Saving Adam parameters to model.transformer/model.npz.optimizer.npz
[2021-05-28 19:53:08] [valid] Ep. 3 : Up. 5000 : cross-entropy : 187.333 : new best
[2021-05-28 19:53:09] [valid] Ep. 3 : Up. 5000 : perplexity : 24.3097 : new best
[2021-05-28 19:53:14] [valid] [valid] First sentence's tokens as scored:
[2021-05-28 19:53:14] [valid] DefaultVocab keeps original segments for scoring
[2021-05-28 19:53:14] [valid] [valid]   Hyp: ဝန် ကြီး ဌာ န ဝန် ကြီး သည် ဒေ သ ခံ ပြည် သူ့ ဝန် ကြီး ချုပ် နှ င့် ပြည် သူ့ ဝန် ကြီး ဌာ န ဝန် ကြီး ဌာ န ပြည် သူ့ ဝန် ကြီး ဌာ န များ နှ င့် အ စိုး ရ အ ဖွဲ့ အ စည်း များ နှ င့် ပူး ပေါင်း ဆောင် ရွက် လျက် ရှိ ပါ သည် ။
[2021-05-28 19:53:14] [valid] [valid]   Ref: ပြည် ထဲ ရေး ဝန် ကြီး ဌာ န သည် အ စဉ် အ လာ အား ဖြ င့် ဘဏ္ဍာ ရေး ၊ ၏ အ ရာ များ နှ င့် အ တူ ဝန် ကြီး အ ဖွဲ့ ၊ တွင် အ ရေး ကြီး ဆုံး နေ ရာ များ မှ တစ် ခု ဖြစ် ပြီး အ ထူး သ ဖြ င့် ဥ ပ ဒေ စိုး မိုး ရေး နှ င့် ဒေ သ တွင်း အ စိုး ရ များ နှ င့် ဆက် ဆံ ရေး ၏ ပြည် ထဲ ရေး ဝန် ကြီး ဌာ န သည် ထူး ထူး ခြား ခြား ၊ တာ ဝန် ခံ လည်း ၊ ဖြစ် သည် ။
[2021-05-28 19:53:34] [valid] Ep. 3 : Up. 5000 : bleu : 8.60155 : new best
...
...
...
[2021-05-28 20:20:57] Ep. 5 : Up. 8500 : Sen. 51,898 : Cost 3.15147662 * 1,840,914 @ 4,477 after 31,439,575 : Time 235.00s : 7833.60 words/s : L.r. 3.0000e-04
[2021-05-28 20:24:50] Ep. 5 : Up. 9000 : Sen. 115,000 : Cost 3.13575220 * 1,853,527 @ 2,145 after 33,293,102 : Time 233.42s : 7940.58 words/s : L.r. 3.0000e-04
[2021-05-28 20:28:42] Ep. 5 : Up. 9500 : Sen. 178,672 : Cost 3.12612677 * 1,867,361 @ 4,302 after 35,160,463 : Time 232.42s : 8034.58 words/s : L.r. 3.0000e-04
[2021-05-28 20:32:33] Ep. 5 : Up. 10000 : Sen. 241,846 : Cost 3.10688758 * 1,841,352 @ 4,526 after 37,001,815 : Time 230.68s : 7982.33 words/s : L.r. 3.0000e-04
[2021-05-28 20:32:33] Saving model weights and runtime parameters to model.transformer/model.npz.orig.npz
[2021-05-28 20:32:34] Saving model weights and runtime parameters to model.transformer/model.iter10000.npz
[2021-05-28 20:32:34] Saving model weights and runtime parameters to model.transformer/model.npz
[2021-05-28 20:32:36] Saving Adam parameters to model.transformer/model.npz.optimizer.npz
[2021-05-28 20:32:39] [valid] Ep. 5 : Up. 10000 : cross-entropy : 166.582 : new best
[2021-05-28 20:32:41] [valid] Ep. 5 : Up. 10000 : perplexity : 17.0716 : new best
[2021-05-28 20:33:02] [valid] Ep. 5 : Up. 10000 : bleu : 11.914 : new best
...
...
...
[2021-05-28 23:42:55] Seen 255710 samples
[2021-05-28 23:42:55] Starting data epoch 18 in logical epoch 18
[2021-05-28 23:42:55] [data] Shuffling data
[2021-05-28 23:42:55] [data] Done reading 256,102 sentences
[2021-05-28 23:42:56] [data] Done shuffling 256,102 sentences to temp files
[2021-05-28 23:44:01] Ep. 18 : Up. 34500 : Sen. 17,806 : Cost 2.57193685 * 1,856,280 @ 3,741 after 127,705,333 : Time 231.75s : 8009.90 words/s : L.r. 2.0430e-04
[2021-05-28 23:47:52] Ep. 18 : Up. 35000 : Sen. 81,320 : Cost 2.54289603 * 1,863,697 @ 4,097 after 129,569,030 : Time 231.89s : 8037.14 words/s : L.r. 2.0284e-04
[2021-05-28 23:47:52] Saving model weights and runtime parameters to model.transformer/model.npz.orig.npz
[2021-05-28 23:47:54] Saving model weights and runtime parameters to model.transformer/model.iter35000.npz
[2021-05-28 23:47:54] Saving model weights and runtime parameters to model.transformer/model.npz
[2021-05-28 23:47:55] Saving Adam parameters to model.transformer/model.npz.optimizer.npz
[2021-05-28 23:47:59] [valid] Ep. 18 : Up. 35000 : cross-entropy : 151.903 : stalled 1 times (last best: 151.823)
[2021-05-28 23:48:00] [valid] Ep. 18 : Up. 35000 : perplexity : 13.2949 : stalled 1 times (last best: 13.277)
[2021-05-28 23:48:23] [valid] Ep. 18 : Up. 35000 : bleu : 17.7906 : new best
...
...
...
[2021-05-29 05:19:49] Ep. 39 : Up. 77500 : Sen. 90,243 : Cost 2.27543092 * 1,854,596 @ 4,069 after 286,959,622 : Time 230.56s : 8043.80 words/s : L.r. 1.3631e-04
[2021-05-29 05:23:40] Ep. 39 : Up. 78000 : Sen. 154,566 : Cost 2.28252149 * 1,849,313 @ 4,683 after 288,808,935 : Time 230.54s : 8021.70 words/s : L.r. 1.3587e-04
[2021-05-29 05:27:30] Ep. 39 : Up. 78500 : Sen. 217,486 : Cost 2.29108334 * 1,851,762 @ 3,430 after 290,660,697 : Time 230.50s : 8033.65 words/s : L.r. 1.3544e-04
[2021-05-29 05:29:52] Seen 255710 samples
[2021-05-29 05:29:52] Starting data epoch 40 in logical epoch 40
[2021-05-29 05:29:52] [data] Shuffling data
[2021-05-29 05:29:52] [data] Done reading 256,102 sentences
[2021-05-29 05:29:53] [data] Done shuffling 256,102 sentences to temp files
[2021-05-29 05:31:21] Ep. 40 : Up. 79000 : Sen. 24,149 : Cost 2.28408909 * 1,843,943 @ 4,188 after 292,504,640 : Time 230.96s : 7983.98 words/s : L.r. 1.3501e-04
[2021-05-29 05:35:12] Ep. 40 : Up. 79500 : Sen. 87,542 : Cost 2.27047014 * 1,843,011 @ 3,120 after 294,347,651 : Time 230.23s : 8004.98 words/s : L.r. 1.3459e-04
[2021-05-29 05:39:03] Ep. 40 : Up. 80000 : Sen. 151,252 : Cost 2.27227473 * 1,867,499 @ 1 after 296,215,150 : Time 231.58s : 8064.11 words/s : L.r. 1.3416e-04
[2021-05-29 05:39:03] Saving model weights and runtime parameters to model.transformer/model.npz.orig.npz
[2021-05-29 05:39:04] Saving model weights and runtime parameters to model.transformer/model.iter80000.npz
[2021-05-29 05:39:05] Saving model weights and runtime parameters to model.transformer/model.npz
[2021-05-29 05:39:06] Saving Adam parameters to model.transformer/model.npz.optimizer.npz
[2021-05-29 05:39:10] [valid] Ep. 40 : Up. 80000 : cross-entropy : 160.089 : stalled 10 times (last best: 151.823)
[2021-05-29 05:39:11] [valid] Ep. 40 : Up. 80000 : perplexity : 15.2843 : stalled 10 times (last best: 13.277)
[2021-05-29 05:39:35] [valid] Ep. 40 : Up. 80000 : bleu : 19.1059 : new best
[2021-05-29 05:39:36] Training finished
[2021-05-29 05:39:37] Saving model weights and runtime parameters to model.transformer/model.npz.orig.npz
[2021-05-29 05:39:38] Saving model weights and runtime parameters to model.transformer/model.npz
[2021-05-29 05:39:39] Saving Adam parameters to model.transformer/model.npz.optimizer.npz

real	626m13.252s
user	991m14.680s
sys	0m48.550s

real	626m13.287s
user	991m14.697s
sys	0m48.560s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$
```

## Testing

```
time marian-decoder -m ./model.npz -v ../data/vocab/vocab.en.yml ../data/vocab/vocab.my.yml --devices 0 1 --output hyp.model.my < ../data/test.en
```

## Evaluation

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.transformer$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ../data/test.my < ./hyp.model.my  >> results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.transformer$ cat results.txt 
BLEU = 18.09, 59.4/33.1/19.1/11.5 (BP=0.705, ratio=0.741, hyp_len=43640, ref_len=58895)
```

## Ensembling s2s+Transformer or System 1+2

```
time marian-decoder \
    --models model.s2s-4/model.npz model.transformer/model.npz \
    --weights 0.4 0.6 --max-length 200 \
    --vocabs ./data/vocab/vocab.en.yml ./data/vocab/vocab.my.yml \
   --maxi-batch 64  --workspace 500 \
   --output ./ensembling-results/hyp.s2s-plus-transformer.my1 \
    --devices 0 1 < ./data/test.en
    
perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./data/test.my < ./ensembling-results/hyp.s2s-plus-transformer.my1  > ./ensembling-results/1.s2s-plus-transformer-results.txt
```

## Eval Result, s2s+Transformer, --weights 0.4 0.6

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./data/test.my < ./ensembling-results/hyp.s2s-plus-transformer.my1  > ./ensembling-results/1.s2s-plus-transformer-0.4-0.6.results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ cat ./ensembling-results/1.s2s-plus-transformer-results.txt 
BLEU = 19.31, 62.6/36.4/22.2/14.0 (BP=0.665, ratio=0.710, hyp_len=41844, ref_len=58895)
```

## Eval Result, s2s+Transformer, --weights 0.5 0.5

```
time marian-decoder \
    --models model.s2s-4/model.npz model.transformer/model.npz \
    --weights 0.5 0.5 --max-length 200 \
    --vocabs ./data/vocab/vocab.en.yml ./data/vocab/vocab.my.yml \
   --maxi-batch 64  --workspace 500 \
   --output ./ensembling-results/hyp.s2s-plus-transformer.my2 \
    --devices 0 1 < ./data/test.en
    
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./data/test.my < ./ensembling-results/hyp.s2s-plus-transformer.my2  > ./ensembling-results/1.s2s-plus-transformer-0.5-0.5.results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ cat ./ensembling-results/1.s2s-plus-transformer-0.5-0.5.results.txt 
BLEU = 19.55, 62.9/36.9/22.7/14.4 (BP=0.663, ratio=0.708, hyp_len=41723, ref_len=58895)
```

## Eval Result, s2s+Transformer, --weights 0.6 0.4

```
time marian-decoder \
    --models model.s2s-4/model.npz model.transformer/model.npz \
    --weights 0.6 0.4 --max-length 200 \
    --vocabs ./data/vocab/vocab.en.yml ./data/vocab/vocab.my.yml \
   --maxi-batch 64  --workspace 500 \
   --output ./ensembling-results/hyp.s2s-plus-transformer.my3 \
    --devices 0 1 < ./data/test.en
    
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./data/test.my < ./ensembling-results/hyp.s2s-plus-transformer.my3  > ./ensembling-results/1.s2s-plus-transformer-0.6-0.4.results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ cat ./ensembling-results/1.s2s-plus-transformer-0.6-0.4.results.txt 
BLEU = 19.24, 62.2/36.3/22.4/14.2 (BP=0.661, ratio=0.707, hyp_len=41666, ref_len=58895)
```

==========================================================================

## To Do

System-3: s2s or RNN-based; tree2string   
System-4: Transformer; tree2string  
Ensemble: s2s (t2s) + Transformer (t2s); (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

==========================================================================

## Myanmar-English
## System 5: s2s 

ပထမဆုံး run ခဲ့တဲ့ experiments ကိုပဲ Myanmar-English translation direction အနေနဲ့ experiment လုပ်ခြင်း...  

## Script for s2s or RNN-based Attention (my-en direction)

```
mkdir model.s2s-4.my-en;

marian \
  --type s2s \
  --train-sets data/train.my data/train.en \
  --max-length 100 \
  --valid-sets data/valid.my data/valid.en \
  --vocabs data/vocab/vocab.my.yml data/vocab/vocab.en.yml \
  --model model.s2s-4.my-en/model.npz \
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
  --log model.s2s-4.my-en/train.log --valid-log model.s2s-4.my-en/valid.log \
  --devices 0 1 --sync-sgd --seed 1111  \
  --dump-config > model.s2s-4.my-en/config.yml
  
time marian -c model.s2s-4.my-en/config.yml  2>&1 | tee s2s.myen.syl.log
```

## Training Log

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ time ./s2s.deep4.my-en.sh 
[2021-05-29 09:42:50] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-29 09:42:50] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 79961 with command line:
[2021-05-29 09:42:50] [marian] marian -c model.s2s-4.my-en/config.yml
[2021-05-29 09:42:50] [config] after: 0e
[2021-05-29 09:42:50] [config] after-batches: 0
[2021-05-29 09:42:50] [config] after-epochs: 0
[2021-05-29 09:42:50] [config] all-caps-every: 0
[2021-05-29 09:42:50] [config] allow-unk: false
[2021-05-29 09:42:50] [config] authors: false
[2021-05-29 09:42:50] [config] beam-size: 12
[2021-05-29 09:42:50] [config] bert-class-symbol: "[CLS]"
[2021-05-29 09:42:50] [config] bert-mask-symbol: "[MASK]"
[2021-05-29 09:42:50] [config] bert-masking-fraction: 0.15
[2021-05-29 09:42:50] [config] bert-sep-symbol: "[SEP]"
[2021-05-29 09:42:50] [config] bert-train-type-embeddings: true
[2021-05-29 09:42:50] [config] bert-type-vocab-size: 2
[2021-05-29 09:42:50] [config] build-info: ""
[2021-05-29 09:42:50] [config] cite: false
[2021-05-29 09:42:50] [config] clip-norm: 1
[2021-05-29 09:42:50] [config] cost-scaling:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] cost-type: ce-sum
[2021-05-29 09:42:50] [config] cpu-threads: 0
[2021-05-29 09:42:50] [config] data-weighting: ""
[2021-05-29 09:42:50] [config] data-weighting-type: sentence
[2021-05-29 09:42:50] [config] dec-cell: lstm
[2021-05-29 09:42:50] [config] dec-cell-base-depth: 2
[2021-05-29 09:42:50] [config] dec-cell-high-depth: 2
[2021-05-29 09:42:50] [config] dec-depth: 2
[2021-05-29 09:42:50] [config] devices:
[2021-05-29 09:42:50] [config]   - 0
[2021-05-29 09:42:50] [config]   - 1
[2021-05-29 09:42:50] [config] dim-emb: 512
[2021-05-29 09:42:50] [config] dim-rnn: 1024
[2021-05-29 09:42:50] [config] dim-vocabs:
[2021-05-29 09:42:50] [config]   - 0
[2021-05-29 09:42:50] [config]   - 0
[2021-05-29 09:42:50] [config] disp-first: 0
[2021-05-29 09:42:50] [config] disp-freq: 500
[2021-05-29 09:42:50] [config] disp-label-counts: true
[2021-05-29 09:42:50] [config] dropout-rnn: 0.3
[2021-05-29 09:42:50] [config] dropout-src: 0.3
[2021-05-29 09:42:50] [config] dropout-trg: 0
[2021-05-29 09:42:50] [config] dump-config: ""
[2021-05-29 09:42:50] [config] early-stopping: 10
[2021-05-29 09:42:50] [config] embedding-fix-src: false
[2021-05-29 09:42:50] [config] embedding-fix-trg: false
[2021-05-29 09:42:50] [config] embedding-normalization: false
[2021-05-29 09:42:50] [config] embedding-vectors:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] enc-cell: lstm
[2021-05-29 09:42:50] [config] enc-cell-depth: 2
[2021-05-29 09:42:50] [config] enc-depth: 2
[2021-05-29 09:42:50] [config] enc-type: alternating
[2021-05-29 09:42:50] [config] english-title-case-every: 0
[2021-05-29 09:42:50] [config] exponential-smoothing: 0.0001
[2021-05-29 09:42:50] [config] factor-weight: 1
[2021-05-29 09:42:50] [config] grad-dropping-momentum: 0
[2021-05-29 09:42:50] [config] grad-dropping-rate: 0
[2021-05-29 09:42:50] [config] grad-dropping-warmup: 100
[2021-05-29 09:42:50] [config] gradient-checkpointing: false
[2021-05-29 09:42:50] [config] guided-alignment: none
[2021-05-29 09:42:50] [config] guided-alignment-cost: mse
[2021-05-29 09:42:50] [config] guided-alignment-weight: 0.1
[2021-05-29 09:42:50] [config] ignore-model-config: false
[2021-05-29 09:42:50] [config] input-types:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] interpolate-env-vars: false
[2021-05-29 09:42:50] [config] keep-best: false
[2021-05-29 09:42:50] [config] label-smoothing: 0
[2021-05-29 09:42:50] [config] layer-normalization: true
[2021-05-29 09:42:50] [config] learn-rate: 0.0001
[2021-05-29 09:42:50] [config] lemma-dim-emb: 0
[2021-05-29 09:42:50] [config] log: model.s2s-4.my-en/train.log
[2021-05-29 09:42:50] [config] log-level: info
[2021-05-29 09:42:50] [config] log-time-zone: ""
[2021-05-29 09:42:50] [config] logical-epoch:
[2021-05-29 09:42:50] [config]   - 1e
[2021-05-29 09:42:50] [config]   - 0
[2021-05-29 09:42:50] [config] lr-decay: 0
[2021-05-29 09:42:50] [config] lr-decay-freq: 50000
[2021-05-29 09:42:50] [config] lr-decay-inv-sqrt:
[2021-05-29 09:42:50] [config]   - 0
[2021-05-29 09:42:50] [config] lr-decay-repeat-warmup: false
[2021-05-29 09:42:50] [config] lr-decay-reset-optimizer: false
[2021-05-29 09:42:50] [config] lr-decay-start:
[2021-05-29 09:42:50] [config]   - 10
[2021-05-29 09:42:50] [config]   - 1
[2021-05-29 09:42:50] [config] lr-decay-strategy: epoch+stalled
[2021-05-29 09:42:50] [config] lr-report: false
[2021-05-29 09:42:50] [config] lr-warmup: 0
[2021-05-29 09:42:50] [config] lr-warmup-at-reload: false
[2021-05-29 09:42:50] [config] lr-warmup-cycle: false
[2021-05-29 09:42:50] [config] lr-warmup-start-rate: 0
[2021-05-29 09:42:50] [config] max-length: 100
[2021-05-29 09:42:50] [config] max-length-crop: false
[2021-05-29 09:42:50] [config] max-length-factor: 3
[2021-05-29 09:42:50] [config] maxi-batch: 100
[2021-05-29 09:42:50] [config] maxi-batch-sort: trg
[2021-05-29 09:42:50] [config] mini-batch: 64
[2021-05-29 09:42:50] [config] mini-batch-fit: true
[2021-05-29 09:42:50] [config] mini-batch-fit-step: 10
[2021-05-29 09:42:50] [config] mini-batch-track-lr: false
[2021-05-29 09:42:50] [config] mini-batch-warmup: 0
[2021-05-29 09:42:50] [config] mini-batch-words: 0
[2021-05-29 09:42:50] [config] mini-batch-words-ref: 0
[2021-05-29 09:42:50] [config] model: model.s2s-4.my-en/model.npz
[2021-05-29 09:42:50] [config] multi-loss-type: sum
[2021-05-29 09:42:50] [config] multi-node: false
[2021-05-29 09:42:50] [config] multi-node-overlap: true
[2021-05-29 09:42:50] [config] n-best: false
[2021-05-29 09:42:50] [config] no-nccl: false
[2021-05-29 09:42:50] [config] no-reload: false
[2021-05-29 09:42:50] [config] no-restore-corpus: false
[2021-05-29 09:42:50] [config] normalize: 0
[2021-05-29 09:42:50] [config] normalize-gradient: false
[2021-05-29 09:42:50] [config] num-devices: 0
[2021-05-29 09:42:50] [config] optimizer: adam
[2021-05-29 09:42:50] [config] optimizer-delay: 1
[2021-05-29 09:42:50] [config] optimizer-params:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] output-omit-bias: false
[2021-05-29 09:42:50] [config] overwrite: false
[2021-05-29 09:42:50] [config] precision:
[2021-05-29 09:42:50] [config]   - float32
[2021-05-29 09:42:50] [config]   - float32
[2021-05-29 09:42:50] [config]   - float32
[2021-05-29 09:42:50] [config] pretrained-model: ""
[2021-05-29 09:42:50] [config] quantize-biases: false
[2021-05-29 09:42:50] [config] quantize-bits: 0
[2021-05-29 09:42:50] [config] quantize-log-based: false
[2021-05-29 09:42:50] [config] quantize-optimization-steps: 0
[2021-05-29 09:42:50] [config] quiet: false
[2021-05-29 09:42:50] [config] quiet-translation: false
[2021-05-29 09:42:50] [config] relative-paths: false
[2021-05-29 09:42:50] [config] right-left: false
[2021-05-29 09:42:50] [config] save-freq: 5000
[2021-05-29 09:42:50] [config] seed: 1111
[2021-05-29 09:42:50] [config] sentencepiece-alphas:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] sentencepiece-max-lines: 2000000
[2021-05-29 09:42:50] [config] sentencepiece-options: ""
[2021-05-29 09:42:50] [config] shuffle: data
[2021-05-29 09:42:50] [config] shuffle-in-ram: false
[2021-05-29 09:42:50] [config] sigterm: save-and-exit
[2021-05-29 09:42:50] [config] skip: true
[2021-05-29 09:42:50] [config] sqlite: ""
[2021-05-29 09:42:50] [config] sqlite-drop: false
[2021-05-29 09:42:50] [config] sync-sgd: true
[2021-05-29 09:42:50] [config] tempdir: /tmp
[2021-05-29 09:42:50] [config] tied-embeddings: true
[2021-05-29 09:42:50] [config] tied-embeddings-all: false
[2021-05-29 09:42:50] [config] tied-embeddings-src: false
[2021-05-29 09:42:50] [config] train-embedder-rank:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] train-sets:
[2021-05-29 09:42:50] [config]   - data/train.my
[2021-05-29 09:42:50] [config]   - data/train.en
[2021-05-29 09:42:50] [config] transformer-aan-activation: swish
[2021-05-29 09:42:50] [config] transformer-aan-depth: 2
[2021-05-29 09:42:50] [config] transformer-aan-nogate: false
[2021-05-29 09:42:50] [config] transformer-decoder-autoreg: self-attention
[2021-05-29 09:42:50] [config] transformer-depth-scaling: false
[2021-05-29 09:42:50] [config] transformer-dim-aan: 2048
[2021-05-29 09:42:50] [config] transformer-dim-ffn: 2048
[2021-05-29 09:42:50] [config] transformer-dropout: 0
[2021-05-29 09:42:50] [config] transformer-dropout-attention: 0
[2021-05-29 09:42:50] [config] transformer-dropout-ffn: 0
[2021-05-29 09:42:50] [config] transformer-ffn-activation: swish
[2021-05-29 09:42:50] [config] transformer-ffn-depth: 2
[2021-05-29 09:42:50] [config] transformer-guided-alignment-layer: last
[2021-05-29 09:42:50] [config] transformer-heads: 8
[2021-05-29 09:42:50] [config] transformer-no-projection: false
[2021-05-29 09:42:50] [config] transformer-pool: false
[2021-05-29 09:42:50] [config] transformer-postprocess: dan
[2021-05-29 09:42:50] [config] transformer-postprocess-emb: d
[2021-05-29 09:42:50] [config] transformer-postprocess-top: ""
[2021-05-29 09:42:50] [config] transformer-preprocess: ""
[2021-05-29 09:42:50] [config] transformer-tied-layers:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] transformer-train-position-embeddings: false
[2021-05-29 09:42:50] [config] tsv: false
[2021-05-29 09:42:50] [config] tsv-fields: 0
[2021-05-29 09:42:50] [config] type: s2s
[2021-05-29 09:42:50] [config] ulr: false
[2021-05-29 09:42:50] [config] ulr-dim-emb: 0
[2021-05-29 09:42:50] [config] ulr-dropout: 0
[2021-05-29 09:42:50] [config] ulr-keys-vectors: ""
[2021-05-29 09:42:50] [config] ulr-query-vectors: ""
[2021-05-29 09:42:50] [config] ulr-softmax-temperature: 1
[2021-05-29 09:42:50] [config] ulr-trainable-transformation: false
[2021-05-29 09:42:50] [config] unlikelihood-loss: false
[2021-05-29 09:42:50] [config] valid-freq: 5000
[2021-05-29 09:42:50] [config] valid-log: model.s2s-4.my-en/valid.log
[2021-05-29 09:42:50] [config] valid-max-length: 1000
[2021-05-29 09:42:50] [config] valid-metrics:
[2021-05-29 09:42:50] [config]   - cross-entropy
[2021-05-29 09:42:50] [config]   - perplexity
[2021-05-29 09:42:50] [config]   - bleu
[2021-05-29 09:42:50] [config] valid-mini-batch: 32
[2021-05-29 09:42:50] [config] valid-reset-stalled: false
[2021-05-29 09:42:50] [config] valid-script-args:
[2021-05-29 09:42:50] [config]   []
[2021-05-29 09:42:50] [config] valid-script-path: ""
[2021-05-29 09:42:50] [config] valid-sets:
[2021-05-29 09:42:50] [config]   - data/valid.my
[2021-05-29 09:42:50] [config]   - data/valid.en
[2021-05-29 09:42:50] [config] valid-translation-output: ""
[2021-05-29 09:42:50] [config] vocabs:
[2021-05-29 09:42:50] [config]   - data/vocab/vocab.my.yml
[2021-05-29 09:42:50] [config]   - data/vocab/vocab.en.yml
[2021-05-29 09:42:50] [config] word-penalty: 0
[2021-05-29 09:42:50] [config] word-scores: false
[2021-05-29 09:42:50] [config] workspace: 500
[2021-05-29 09:42:50] [config] Model is being created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-05-29 09:42:50] Using synchronous SGD
[2021-05-29 09:42:50] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.my.yml
[2021-05-29 09:42:51] [data] Setting vocabulary size for input 0 to 12,379
[2021-05-29 09:42:51] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.en.yml
[2021-05-29 09:42:51] [data] Setting vocabulary size for input 1 to 85,602
[2021-05-29 09:42:51] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-05-29 09:42:51] [batching] Collecting statistics for batch fitting with step size 10
[2021-05-29 09:42:51] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-05-29 09:42:51] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-05-29 09:42:51] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-29 09:42:51] [comm] NCCLCommunicator constructed successfully
[2021-05-29 09:42:51] [training] Using 2 GPUs
[2021-05-29 09:42:51] [logits] Applying loss function for 1 factor(s)
[2021-05-29 09:42:51] [memory] Reserving 527 MB, device gpu0
[2021-05-29 09:42:51] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-05-29 09:42:52] [memory] Reserving 527 MB, device gpu0
[2021-05-29 09:43:21] [batching] Done. Typical MB size is 614 target words
[2021-05-29 09:43:21] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-05-29 09:43:21] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-05-29 09:43:21] [comm] Using NCCL 2.8.3 for GPU communication
[2021-05-29 09:43:21] [comm] NCCLCommunicator constructed successfully
[2021-05-29 09:43:21] [training] Using 2 GPUs
[2021-05-29 09:43:21] Training started
[2021-05-29 09:43:21] [data] Shuffling data
[2021-05-29 09:43:21] [data] Done reading 256,102 sentences
[2021-05-29 09:43:22] [data] Done shuffling 256,102 sentences to temp files
[2021-05-29 09:43:22] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-05-29 09:43:22] [memory] Reserving 527 MB, device gpu1
[2021-05-29 09:43:22] [memory] Reserving 527 MB, device gpu0
[2021-05-29 09:43:22] [memory] Reserving 527 MB, device gpu0
[2021-05-29 09:43:22] [memory] Reserving 527 MB, device gpu1
[2021-05-29 09:43:23] [memory] Reserving 263 MB, device gpu0
[2021-05-29 09:43:23] [memory] Reserving 263 MB, device gpu1
[2021-05-29 09:43:24] [memory] Reserving 527 MB, device gpu0
[2021-05-29 09:43:24] [memory] Reserving 527 MB, device gpu1
[2021-05-29 09:53:09] Ep. 1 : Up. 500 : Sen. 8,920 : Cost 7.35808802 * 130,216 after 130,216 : Time 587.80s : 221.53 words/s
[2021-05-29 10:02:48] Ep. 1 : Up. 1000 : Sen. 17,898 : Cost 6.02787971 * 132,464 after 262,680 : Time 579.51s : 228.58 words/s
[2021-05-29 10:12:26] Ep. 1 : Up. 1500 : Sen. 27,123 : Cost 5.67041206 * 131,703 after 394,383 : Time 577.16s : 228.19 words/s
[2021-05-29 10:22:12] Ep. 1 : Up. 2000 : Sen. 35,807 : Cost 5.53516769 * 131,944 after 526,327 : Time 586.46s : 224.98 words/s
[2021-05-29 10:31:44] Ep. 1 : Up. 2500 : Sen. 45,046 : Cost 5.31670427 * 131,291 after 657,618 : Time 572.06s : 229.51 words/s
[2021-05-29 10:41:23] Ep. 1 : Up. 3000 : Sen. 54,210 : Cost 5.12534904 * 132,452 after 790,070 : Time 579.00s : 228.76 words/s
[2021-05-29 10:50:59] Ep. 1 : Up. 3500 : Sen. 63,295 : Cost 5.09366035 * 131,664 after 921,734 : Time 575.97s : 228.59 words/s
[2021-05-29 11:00:41] Ep. 1 : Up. 4000 : Sen. 72,365 : Cost 4.99966526 * 132,036 after 1,053,770 : Time 581.46s : 227.08 words/s
[2021-05-29 11:10:18] Ep. 1 : Up. 4500 : Sen. 81,514 : Cost 4.88403893 * 132,264 after 1,186,034 : Time 577.06s : 229.20 words/s
[2021-05-29 11:20:05] Ep. 1 : Up. 5000 : Sen. 90,460 : Cost 4.85926437 * 132,334 after 1,318,368 : Time 587.49s : 225.25 words/s
[2021-05-29 11:20:05] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-29 11:20:08] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter5000.npz
[2021-05-29 11:20:09] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-29 11:20:11] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x563339fb8000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x563386de0000 @ 
[2021-05-29 11:20:26] Error: CUDA error 2 'out of memory' - /home/ye/tool/marian/src/tensors/gpu/device.cu:32: cudaMalloc(&data_, size)
[2021-05-29 11:20:26] Error: Aborted from virtual void marian::gpu::Device::reserve(size_t) in /home/ye/tool/marian/src/tensors/gpu/device.cu:32

[CALL STACK]
[0x5632f9246880]    marian::gpu::Device::  reserve  (unsigned long)    + 0xf80
[0x5632f8b767df]    marian::TensorAllocator::  allocate  (IntrusivePtr<marian::TensorBase>&,  marian::Shape,  marian::Type) + 0x4ef
[0x5632f8d82b00]    marian::Node::  allocate  ()                       + 0x1e0
[0x5632f8d792ce]    marian::ExpressionGraph::  forward  (std::__cxx11::list<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>,std::allocator<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>>>&,  bool) + 0x8e
[0x5632f8d7acae]    marian::ExpressionGraph::  forwardNext  ()         + 0x24e
[0x5632f8f4be64]                                                       + 0x77de64
[0x5632f8f4c694]                                                       + 0x77e694
[0x5632f8b2015d]    std::__future_base::_State_baseV2::  _M_do_set  (std::function<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> ()>*,  bool*) + 0x2d
[0x7f1b3c4e8c0f]                                                       + 0x11c0f
[0x5632f8f4318a]                                                       + 0x77518a
[0x5632f8b2289a]    std::thread::_State_impl<std::thread::_Invoker<std::tuple<marian::ThreadPool::reserve(unsigned long)::{lambda()#1}>>>::  _M_run  () + 0x13a
[0x7f1b3c3ccd84]                                                       + 0xd6d84
[0x7f1b3c4e0590]                                                       + 0x9590
[0x7f1b3c0bb223]    clone                                              + 0x43


real	97m36.169s
user	161m48.599s
sys	0m5.798s

real	97m36.195s
user	161m48.622s
sys	0m5.801s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$
```

## Check and ReTrain

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.my-en$ ls *.npz
model.iter5000.npz  model.npz  model.npz.optimizer.npz  model.npz.orig.npz
```

မော်ဒယ်တော့ iter5000 အတွက် ဆောက်သွားနိုင်ခဲ့...  

စက်ကို shutdown လုပ် ၁၀မိနစ်ခဲ့ အနားပေး၊ စက်အေးအောင် ထားခဲ့။  
ဆက်တိုက် ဖွင့်ထားတာလည်း တပတ်ကျော်နေပြီမို့ ....  

ပြီးမှ စက်ပြန်ဖွင့်ပြီး retraining လုပ်ခဲ့...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ time ./s2s.deep4.my-en.sh 
...
...
...
[2021-05-29 13:24:55] Ep. 1 : Up. 9000 : Sen. 162,384 : Cost 4.53392601 * 131,260 after 2,370,221 : Time 583.66s : 224.89 words/s
[2021-05-29 13:34:38] Ep. 1 : Up. 9500 : Sen. 171,428 : Cost 4.45483160 * 130,807 after 2,501,028 : Time 583.61s : 224.13 words/s
[2021-05-29 13:44:24] Ep. 1 : Up. 10000 : Sen. 180,478 : Cost 4.41879749 * 132,697 after 2,633,725 : Time 585.87s : 226.50 words/s
[2021-05-29 13:44:24] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-29 13:44:26] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter10000.npz
[2021-05-29 13:44:27] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-29 13:44:30] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x55be9250a000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x55be9250a000 @ 
[2021-05-29 13:44:48] [valid] Ep. 1 : Up. 10000 : cross-entropy : 167.71 : new best
[2021-05-29 13:44:59] [valid] Ep. 1 : Up. 10000 : perplexity : 373.296 : new best
[2021-05-29 13:44:59] Translating validation set...
[2021-05-29 13:45:09] [valid] [valid] First sentence's tokens as scored:
[2021-05-29 13:45:09] [valid] DefaultVocab keeps original segments for scoring
[2021-05-29 13:45:09] [valid] [valid]   Hyp: The State Counsellor Daw Aung San Suu Kyi was held in Nay Pyi Taw yesterday .
[2021-05-29 13:45:09] [valid] [valid]   Ref: The damages report was prepared by the Haitian Government with the support of the Economic Commission for Latin America and the Caribbean , the Interamerican Development Bank , the World Bank , the United Nations and the European Union .
[2021-05-29 13:45:23] Best translation 0 : He said that they were able to be able to be able to be able to be able to be able to do so .
[2021-05-29 13:45:23] Best translation 1 : According to the United States , the vice president of the union of Myanmar &amp; apos ; s republic of the union of Myanmar &amp; apos ; s republic of the union of Myanmar &amp; apos ; s republic of the union of Myanmar .
[2021-05-29 13:45:29] Best translation 2 : &amp; quot ; I said , &amp; quot ; she said .
[2021-05-29 13:45:29] Best translation 3 : &amp; quot ; We said , &amp; quot ; she said .
[2021-05-29 13:45:36] Best translation 4 : The government also said that the government has also said that the government has said .
[2021-05-29 13:45:36] Best translation 5 : He said that he said , &amp; quot ; she said .
[2021-05-29 13:45:36] Best translation 10 : There was a lot of the first time in the world .
[2021-05-29 13:45:36] Best translation 20 : The ministry of the union of Myanmar &amp; apos ; s republic of the union of Myanmar &amp; apos ; s republic of the union of Myanmar &amp; apos ; s republic of the union of Myanmar .
[2021-05-29 13:45:36] Best translation 40 : She gave him a lot of his wife , and he had been able to go .
[2021-05-29 13:45:36] Best translation 80 : According to the first time , the government has been an important role in the country .
[2021-05-29 13:45:36] Best translation 160 : According to the meeting , the State Counsellor Daw Aung San Suu Kyi was held in Nay Pyi Taw yesterday .
[2021-05-29 13:45:55] Best translation 320 : According to the same time , we &amp; apos ; ve got a lot of our country &amp; apos ; s republic of Myanmar &amp; apos ; s peace process .
[2021-05-29 13:46:51] Best translation 640 : In addition , the State Counsellor Daw Aung San Suu Kyi was held in Nay Pyi Taw yesterday .
[2021-05-29 13:47:05] Total translation time: 126.17095s
[2021-05-29 13:47:05] [valid] Ep. 1 : Up. 10000 : bleu : 2.39933 : new best
[2021-05-29 13:56:44] Ep. 1 : Up. 10500 : Sen. 189,451 : Cost 4.36547995 * 132,273 after 2,765,998 : Time 740.19s : 178.70 words/s
[2021-05-29 14:06:26] Ep. 1 : Up. 11000 : Sen. 198,496 : Cost 4.32902908 * 130,988 after 2,896,986 : Time 581.77s : 225.15 words/s
[2021-05-29 14:16:05] Ep. 1 : Up. 11500 : Sen. 207,897 : Cost 4.26324701 * 133,901 after 3,030,887 : Time 579.13s : 231.21 words/s
...
...
...
[2021-05-29 15:24:27] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-29 15:24:30] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter15000.npz
[2021-05-29 15:24:31] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-29 15:24:33] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-29 15:24:47] [valid] Ep. 2 : Up. 15000 : cross-entropy : 162.2 : new best
[2021-05-29 15:24:58] [valid] Ep. 2 : Up. 15000 : perplexity : 307.292 : new best
[2021-05-29 15:24:58] Translating validation set...
[2021-05-29 15:25:48] Best translation 0 : He also said that they were able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to do so .
[2021-05-29 15:25:48] Best translation 1 : The United States was found in the United States of the United States of the United States of the United States of the United States and the United States of the United States and the United States of the United States of the United States and the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States of the United States
[2021-05-29 15:25:59] Best translation 2 : He said that it was not an important role in the United States.
[2021-05-29 15:25:59] Best translation 3 : They &amp; apos ; re going to have a lot of our country , &amp; quot ; he said .
[2021-05-29 15:26:13] Best translation 4 : The vice president said that the government has said that the government has said .
[2021-05-29 15:26:13] Best translation 5 : He said that they didn &amp; apos ; t know what to do .
[2021-05-29 15:26:13] Best translation 10 : There was no one of the first time in the morning .
[2021-05-29 15:26:13] Best translation 20 : The vice president of the republic of the republic of the republic of the republic of the republic of the republic of the republic of the republic of the republic of the union of Myanmar .
[2021-05-29 15:26:13] Best translation 40 : She asked her to go to her father and asked her to go to the house .
[2021-05-29 15:26:13] Best translation 80 : In addition , it is necessary to be able to have the right to be able to be able to work in the country .
[2021-05-29 15:26:13] Best translation 160 : According to the United States , the State Counsellor met with the government &amp; apos ; s office .
[2021-05-29 15:26:55] Best translation 320 : &quot;We have been able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to be able to do so .
[2021-05-29 15:28:37] Best translation 640 : In addition , the State Counsellor was held in Nay Pyi Taw yesterday .
[2021-05-29 15:29:04] Total translation time: 245.92778s
[2021-05-29 15:29:04] [valid] Ep. 2 : Up. 15000 : bleu : 1.55739 : stalled 1 times (last best: 2.39933)
...
...
...
[2021-05-29 22:09:22] Best translation 80 : If more than 50 per cent of the vote will need to vote at least 10 % of the members .
[2021-05-29 22:09:22] Best translation 160 : The second way was closed at the road which was used as long as the road was used to India .
[2021-05-29 22:09:49] Best translation 320 : &quot;We are calling for a major type of water and water resources that we have got to have the main quality of things as well as the main material for our lives as well as the main material for our lives .
[2021-05-29 22:10:41] Best translation 640 : The opening ceremony was received from 7 pm at 7 : 00 p.m.
[2021-05-29 22:10:59] Total translation time: 131.56806s
[2021-05-29 22:10:59] [valid] Ep. 3 : Up. 35000 : bleu : 5.68094 : new best
[2021-05-29 22:20:54] Ep. 3 : Up. 35500 : Sen. 142,362 : Cost 2.93437624 * 131,338 after 9,352,628 : Time 757.89s : 173.29 words/s
[2021-05-29 22:30:40] Ep. 3 : Up. 36000 : Sen. 151,354 : Cost 2.88332534 * 133,595 after 9,486,223 : Time 586.20s : 227.90 words/s
[2021-05-29 22:40:24] Ep. 3 : Up. 36500 : Sen. 160,424 : Cost 2.87833452 * 132,341 after 9,618,564 : Time 583.72s : 226.72 words/s
[2021-05-29 22:49:56] Ep. 3 : Up. 37000 : Sen. 169,625 : Cost 2.85134673 * 130,172 after 9,748,736 : Time 572.18s : 227.50 words/s
[2021-05-29 22:59:41] Ep. 3 : Up. 37500 : Sen. 178,604 : Cost 2.82611704 * 133,249 after 9,881,985 : Time 584.69s : 227.90 words/s
[2021-05-29 23:09:31] Ep. 3 : Up. 38000 : Sen. 187,585 : Cost 2.82651901 * 131,365 after 10,013,350 : Time 590.51s : 222.46 words/s
[2021-05-29 23:19:14] Ep. 3 : Up. 38500 : Sen. 196,551 : Cost 2.82954144 * 129,791 after 10,143,141 : Time 582.95s : 222.64 words/s
[2021-05-29 23:29:04] Ep. 3 : Up. 39000 : Sen. 205,792 : Cost 2.80550742 * 134,010 after 10,277,151 : Time 589.90s : 227.17 words/s
[2021-05-29 23:38:53] Ep. 3 : Up. 39500 : Sen. 214,648 : Cost 2.82334614 * 129,779 after 10,406,930 : Time 589.36s : 220.20 words/s
[2021-05-29 23:48:37] Ep. 3 : Up. 40000 : Sen. 223,755 : Cost 2.81125069 * 133,581 after 10,540,511 : Time 583.88s : 228.78 words/s
[2021-05-29 23:48:37] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-29 23:48:40] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter40000.npz
[2021-05-29 23:48:41] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-29 23:48:43] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-29 23:48:58] [valid] Ep. 3 : Up. 40000 : cross-entropy : 132.332 : new best
[2021-05-29 23:49:09] [valid] Ep. 3 : Up. 40000 : perplexity : 107.026 : new best
[2021-05-29 23:49:09] Translating validation set...
[2021-05-29 23:49:32] Best translation 0 : &quot;I am sorry for his death.
[2021-05-29 23:49:32] Best translation 1 : The incident was reported to have been reported to have been killed by the United States of the United States to control him from the United States to control him by the United States of the United States.
[2021-05-29 23:49:37] Best translation 2 : &quot;It was shot from the plane to be shot from the plane to move from the crash.
[2021-05-29 23:49:37] Best translation 3 : &amp; quot ; We must have the ability to replace these people , &amp; quot ; he said .
[2021-05-29 23:49:43] Best translation 4 : It is said to have the third largest member of the United States to get the third part of the city.
[2021-05-29 23:49:43] Best translation 5 : He said that they didn &amp; apos ; t know about his death .
[2021-05-29 23:49:44] Best translation 10 : Japan got only one of the first part in the first half.
[2021-05-29 23:49:44] Best translation 20 : The research department is carrying the information from the KIO and the world bank of the world bank and collect the facts of the world and the world .
[2021-05-29 23:49:44] Best translation 40 : She tried to look at her hair and tried to help her to help her .
[2021-05-29 23:49:44] Best translation 80 : If more than 50 per cent of the vote will need to vote at least 10 % of those who have the right to vote .
[2021-05-29 23:49:44] Best translation 160 : The second way was closed at the road which was used as a long road map of India .
[2021-05-29 23:50:13] Best translation 320 : &quot;We are calling for all the main things that we have had to have the main type and water resources for those who have been involved in the past few months ago.
[2021-05-29 23:51:06] Best translation 640 : The opening of the coast was received from London at 7 : 00 p.m.
[2021-05-29 23:51:22] Total translation time: 133.29114s
[2021-05-29 23:51:22] [valid] Ep. 3 : Up. 40000 : bleu : 6.55392 : new best
...
...
...
[2021-05-30 01:29:26] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-30 01:29:40] [valid] Ep. 4 : Up. 45000 : cross-entropy : 128.784 : new best
[2021-05-30 01:29:51] [valid] Ep. 4 : Up. 45000 : perplexity : 94.4231 : new best
[2021-05-30 01:29:51] Translating validation set...
[2021-05-30 01:30:14] Best translation 0 : &quot;I am sorry to be sad because he was sad for his death.
[2021-05-30 01:30:14] Best translation 1 : The incident was reported to have been reported to have been killed by the United States to control him by the United States of Pakistan in Iraq as it is expected to control him from the United States.
[2021-05-30 01:30:20] Best translation 2 : &quot;The man was shot from the aircraft not to control from the crash.
[2021-05-30 01:30:20] Best translation 3 : &amp; quot ; We must have the ability to replace these people , &amp; quot ; he said .
[2021-05-30 01:30:25] Best translation 4 : It is said to be the third senior member to get the third part of the city.
[2021-05-30 01:30:25] Best translation 5 : He said that they didn &amp; apos ; t know about his death .
[2021-05-30 01:30:25] Best translation 10 : Japan received only one of the first part in the first half.
[2021-05-30 01:30:25] Best translation 20 : The MNDAA has done the research from the MNDAA and collect the information of the world and the world of the World Cup.
[2021-05-30 01:30:25] Best translation 40 : She tried to look at her hair , and two people tried to help her .
[2021-05-30 01:30:25] Best translation 80 : If more than 50 per cent of the vote will need to vote at least 10 % of the persons who have the right to vote .
[2021-05-30 01:30:25] Best translation 160 : The second ship was closed to the road as long as the road train was used to the Indian government.
[2021-05-30 01:30:51] Best translation 320 : &quot;We are aware of all the main things that we have received from all the main things that are all the main things that we have had to have , and the water resources that we have had .
[2021-05-30 01:31:40] Best translation 640 : The opening of the coast was received from London at 7 : 00 p.m.
[2021-05-30 01:31:57] Total translation time: 125.52227s
[2021-05-30 01:31:57] [valid] Ep. 4 : Up. 45000 : bleu : 6.78302 : new best
...
...
...
[2021-05-30 03:13:09] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-30 03:13:11] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter50000.npz
[2021-05-30 03:13:12] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-30 03:13:14] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-30 03:13:28] [valid] Ep. 4 : Up. 50000 : cross-entropy : 126.13 : new best
[2021-05-30 03:13:40] [valid] Ep. 4 : Up. 50000 : perplexity : 85.9751 : new best
[2021-05-30 03:13:40] Translating validation set...
[2021-05-30 03:14:00] Best translation 0 : &quot;I am sorry for his death.
[2021-05-30 03:14:00] Best translation 1 : The incident was reported to have been reported to have been killed by the United States of Pakistan in Northern Ireland which is not required to control him from the United States of Pakistan in northern Iraq.
[2021-05-30 03:14:05] Best translation 2 : &quot;The suicide bomber came to shot from the plane not to control the crash.
[2021-05-30 03:14:05] Best translation 3 : &amp; quot ; They must have the ability to replace these people , &amp; quot ; he said .
[2021-05-30 03:14:12] Best translation 4 : The second largest official team was told to get the third member of the city.
[2021-05-30 03:14:12] Best translation 5 : Pakistani government said that they did not know about his death.
[2021-05-30 03:14:12] Best translation 10 : South Korea got only one of the first half in the first half.
[2021-05-30 03:14:12] Best translation 20 : The research department has carried out the research from the MNDAA and collect the data collection of the World War and the World Cup.
[2021-05-30 03:14:12] Best translation 40 : She tried to look at her hair , and two men tried to help her .
[2021-05-30 03:14:12] Best translation 80 : If more than 50 % of the voters need to vote at least 50 % of the members of the vote need at least 10 % .
[2021-05-30 03:14:12] Best translation 160 : The second is closed down the road which had been used as the Indian ambassador to Singapore .
[2021-05-30 03:14:37] Best translation 320 : &quot;We are telling us that we have received a variety of heat and water resources for those who have been involved in the past few months.
[2021-05-30 03:15:29] Best translation 640 : The coast of the coast was received from 7 pm at 7 : 00 p.m.
[2021-05-30 03:15:40] Total translation time: 120.62699s
[2021-05-30 03:15:40] [valid] Ep. 4 : Up. 50000 : bleu : 7.15151 : new best
...
...
...
[2021-05-30 06:31:58] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-30 06:32:00] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter60000.npz
[2021-05-30 06:32:01] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-30 06:32:03] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-30 06:32:17] [valid] Ep. 5 : Up. 60000 : cross-entropy : 122.135 : new best
[2021-05-30 06:32:28] [valid] Ep. 5 : Up. 60000 : perplexity : 74.6631 : new best
[2021-05-30 06:32:28] Translating validation set...
[2021-05-30 06:32:50] Best translation 0 : &quot;We have been sorry for his loss but he left a year to wake up the man and religion to write to race and religion
[2021-05-30 06:32:50] Best translation 1 : A number of troops were reported to have been killed by the United States of Pakistan in northern Pakistan with the United States of Pakistan in northern Pakistan and is also reported to have been killed by the United States.
[2021-05-30 06:32:54] Best translation 2 : &quot;The Pakistani journalist was hit by the aircraft not to control from the crash.
[2021-05-30 06:32:54] Best translation 3 : &quot;We must have the ability to replace these people to replace them and they have the ability to replace them and to be able to replace those people said.
[2021-05-30 06:33:01] Best translation 4 : The third largest official member of Sagaing region told reporters to get the third member of the blast.
[2021-05-30 06:33:01] Best translation 5 : Pakistani government said that they didn &amp; apos ; t know about his death.
[2021-05-30 06:33:02] Best translation 10 : Los Angeles is only one of the first half in the first half.
[2021-05-30 06:33:02] Best translation 20 : The data collection is being made from the MNDAA and collect data on the ocean and the world of the World Cup.
[2021-05-30 06:33:02] Best translation 40 : She tried to look at her hair , and two men tried to come to help her .
[2021-05-30 06:33:02] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % of votes .
[2021-05-30 06:33:02] Best translation 160 : The second is closed to the road which was used as the Indian ambassador to the Indian ocean .
[2021-05-30 06:33:22] Best translation 320 : &quot;We are showing how much of all the main things that we have received from all the main things that are the main material for those who are the main material for those who are the main things that are the main material for the teenagers .
[2021-05-30 06:34:11] Best translation 640 : The coast of the coast was received from 7 pm at 7 : 00 p.m.
[2021-05-30 06:34:17] Total translation time: 108.62653s
[2021-05-30 06:34:17] [valid] Ep. 5 : Up. 60000 : bleu : 8.00315 : new best
...
...
...
[2021-05-30 08:12:20] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-30 08:12:34] [valid] Ep. 5 : Up. 65000 : cross-entropy : 120.673 : new best
[2021-05-30 08:12:45] [valid] Ep. 5 : Up. 65000 : perplexity : 70.9055 : new best
[2021-05-30 08:12:45] Translating validation set...
[2021-05-30 08:13:02] Best translation 0 : &quot;I am sorry for his loss but he left one of the heritage that was introduced to race and religion
[2021-05-30 08:13:02] Best translation 1 : Other militants were reported to have been killed in the United States of Pakistan in northern Pakistan in Northern Ireland which is not required to control him.
[2021-05-30 08:13:09] Best translation 2 : &quot;The rocket appeared to be shot from the plane not to control from the crash.
[2021-05-30 08:13:09] Best translation 3 : &quot;We must have the ability to replace these people and they have the ability to replace them and to be able to replace those people said.
[2021-05-30 08:13:14] Best translation 4 : The third senior member of Sagaing region told reporters to get the third member of Mawlamyine .
[2021-05-30 08:13:14] Best translation 5 : Pakistani government said that they didn &amp; apos ; t know about his death.
[2021-05-30 08:13:15] Best translation 10 : Los Angeles won only one goal early in the first half.
[2021-05-30 08:13:15] Best translation 20 : The data based in Washington D.C. has collected data from the MNDAA and collect data on the ocean and the World Cup.
[2021-05-30 08:13:15] Best translation 40 : She tried to look at her hair , and two men tried to come to help her .
[2021-05-30 08:13:15] Best translation 80 : If a candidate is less than 50 % vote , a candidate needs at least 33 % of votes .
[2021-05-30 08:13:15] Best translation 160 : The second is closed to the road which has been used as the Indian invitation to Sydney from Sydney .
[2021-05-30 08:13:36] Best translation 320 : &quot;We are showing how much of all the main things that we have received from all the main things that were all the major things that were all of the main things for the teenagers when it comes into ten months.
[2021-05-30 08:14:18] Best translation 640 : The coast of the coast was accepted by the coast of London at 7 : 00 p.m.
[2021-05-30 08:14:26] Total translation time: 101.47008s
[2021-05-30 08:14:26] [valid] Ep. 5 : Up. 65000 : bleu : 8.34774 : new best
...
...
...
[2021-05-30 09:53:41] Best translation 2 : &quot;The rocket appeared to be shot from the aircraft not to control from the crash.
[2021-05-30 09:53:41] Best translation 3 : &quot;We must have the ability to replace these people and they have the ability to replace these people.
[2021-05-30 09:53:46] Best translation 4 : The third senior member was told to have the third member of Mawlamyine .
[2021-05-30 09:53:46] Best translation 5 : Pakistani government said they didn &amp; apos ; t know about his death.
[2021-05-30 09:53:48] Best translation 10 : Los Angeles won only one goal early in the first half.
[2021-05-30 09:53:48] Best translation 20 : The data based in Washington D.C. has performed research from the MNDAA and collect data on the ocean and the World Cup.
[2021-05-30 09:53:48] Best translation 40 : She tried to look at her hair , and two men tried to come to help her .
[2021-05-30 09:53:48] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % of votes .
[2021-05-30 09:53:48] Best translation 160 : The second is closed to the road that was used as the Indian ambassador to Sydney from Sydney .
[2021-05-30 09:54:05] Best translation 320 : &quot;We are showing us that our model was based on a agriculture source based on the life of all the main things that are the main types of things that are all the main material for the teenagers .
[2021-05-30 09:54:46] Best translation 640 : The coast of the coast was accepted by the coast of London at 7 : 00 p.m.
[2021-05-30 09:54:54] Total translation time: 94.70982s
[2021-05-30 09:54:54] [valid] Ep. 6 : Up. 70000 : bleu : 8.53107 : new best
...
...
...
[2021-05-30 11:34:23] Best translation 10 : Los Angeles won only one goal early in the first half.
[2021-05-30 11:34:23] Best translation 20 : The research center based in Washington D.C. has performed research from the MNDAA and collect data on the ocean and the World Cup.
[2021-05-30 11:34:23] Best translation 40 : She tried to look at her hair , and two men tried to come to help her .
[2021-05-30 11:34:23] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % of votes .
[2021-05-30 11:34:23] Best translation 160 : The second is closed down the road that was used as the Indian Ocean road .
[2021-05-30 11:34:41] Best translation 320 : &quot;We are showing us that our model we have got a temperature based on the life of all the main things that all the main products of the life are all the major things that are all the main products for the teenagers .
[2021-05-30 11:35:23] Best translation 640 : The coast guard was accepted by the coast of London at 7 : 30 p.m.
[2021-05-30 11:35:30] Total translation time: 95.32402s
[2021-05-30 11:35:30] [valid] Ep. 6 : Up. 75000 : bleu : 8.71748 : new best
...
...
...
[2021-05-30 13:15:04] Best translation 40 : She tried to look at her hair , and two men tried to come to help her .
[2021-05-30 13:15:04] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % to vote .
[2021-05-30 13:15:04] Best translation 160 : The second route closed the road to Sydney from Sydney from Sydney .
[2021-05-30 13:15:22] Best translation 320 : &quot;We are showing us that our model we have received one of the major types of things that are the main material for the living beings when it comes into ten months.
[2021-05-30 13:16:05] Best translation 640 : The coast was accepted by the coast of London at 7 : 30 p.m.
[2021-05-30 13:16:13] Total translation time: 98.12663s
[2021-05-30 13:16:13] [valid] Ep. 6 : Up. 80000 : bleu : 8.71605 : stalled 1 times (last best: 8.71748)
...
...
...
[2021-05-30 18:24:46] [valid] Ep. 7 : Up. 95000 : cross-entropy : 114.327 : new best
[2021-05-30 18:24:57] [valid] Ep. 7 : Up. 95000 : perplexity : 56.6708 : new best
[2021-05-30 18:24:57] Translating validation set...
[2021-05-30 18:25:12] Best translation 0 : &quot;We are sad for his loss but he left a heritage site to wake up the race and religion to write race and religion .
[2021-05-30 18:25:12] Best translation 1 : Several militants are also reported to have been killed in the United States of Pakistan in Northern Ireland which is not required to be maintained by the United States of Pakistan in Northern Ireland.
[2021-05-30 18:25:18] Best translation 2 : &quot;The missile appeared to be shot from the aircraft not to be maintained by the plane.
[2021-05-30 18:25:18] Best translation 3 : &quot;They must have the ability to replace these people, said an Western intelligence officer said.
[2021-05-30 18:25:23] Best translation 4 : The third senior member was told to get the third senior member of the 4.
[2021-05-30 18:25:23] Best translation 5 : Pakistani government said they did not know about his death.
[2021-05-30 18:25:24] Best translation 10 : Los Angeles won only one goal early in the first half.
[2021-05-30 18:25:24] Best translation 20 : The data compiled in Washington D.C. has performed the research from the MNDAA and collect data on the ocean and the World Cup.
[2021-05-30 18:25:24] Best translation 40 : The gunman opened her hair , and two men tried to come and help her .
[2021-05-30 18:25:24] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % to vote .
[2021-05-30 18:25:24] Best translation 160 : The second route closed the road to Sydney from Sydney .
[2021-05-30 18:25:40] Best translation 320 : &quot;We have pointed out that we have had a temperature and water resources that are all the main products for living beings when it comes into ten months.
[2021-05-30 18:26:19] Best translation 640 : The coast was accepted by the coast of London at 7 : 30 p.m.
[2021-05-30 18:26:26] Total translation time: 88.82053s
[2021-05-30 18:26:26] [valid] Ep. 7 : Up. 95000 : bleu : 9.08877 : stalled 1 times (last best: 9.2188)
...
...
...
[2021-05-30 20:07:10] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-30 20:07:12] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter100000.npz
[2021-05-30 20:07:13] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-30 20:07:15] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-30 20:07:30] [valid] Ep. 8 : Up. 100000 : cross-entropy : 113.542 : new best
[2021-05-30 20:07:41] [valid] Ep. 8 : Up. 100000 : perplexity : 55.121 : new best
[2021-05-30 20:07:41] Translating validation set...
[2021-05-30 20:07:56] Best translation 0 : &quot;We are sad for his loss but he left a heritage site to wake up racial and religion .
[2021-05-30 20:07:56] Best translation 1 : Several militants are also reported to have been killed in the United States of Pakistan in Northern Ireland.
[2021-05-30 20:08:02] Best translation 2 : &quot;The missile appeared to be shot from the aircraft not to be maintained by the plane.
[2021-05-30 20:08:02] Best translation 3 : &quot;They must have the ability to replace these people, said an Western intelligence officer said.
[2021-05-30 20:08:07] Best translation 4 : The third senior member was told to have the third member for the third member of Sagaing ?
[2021-05-30 20:08:07] Best translation 5 : Pakistani government said they did not know about his death.
[2021-05-30 20:08:07] Best translation 10 : Los Angeles won only one goal early in the first half.
[2021-05-30 20:08:07] Best translation 20 : The researchers performed research in Washington D.C. and has collected data from the ocean and the World War II.
[2021-05-30 20:08:07] Best translation 40 : She tried to look at her hair , and the two men tried to come and help her .
[2021-05-30 20:08:07] Best translation 80 : If a candidate is less than 50 % of the vote , a candidate needs at least 33 % to vote .
[2021-05-30 20:08:07] Best translation 160 : The second route closed the road to Sydney from Sydney .
[2021-05-30 20:08:25] Best translation 320 : &quot;Our model shows that we have had a temperature and water resources for living beings when it comes into ten months.
[2021-05-30 20:09:04] Best translation 640 : The coast of coast received a state of emergency at 7 : 30 p.m.
[2021-05-30 20:09:12] Total translation time: 91.54511s
[2021-05-30 20:09:12] [valid] Ep. 8 : Up. 100000 : bleu : 9.4821 : new best
...
...
...
[2021-05-31 02:45:13] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-31 02:45:15] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter120000.npz
[2021-05-31 02:45:16] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-31 02:45:18] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-31 02:45:33] [valid] Ep. 9 : Up. 120000 : cross-entropy : 112.978 : stalled 1 times (last best: 112.772)
[2021-05-31 02:45:44] [valid] Ep. 9 : Up. 120000 : perplexity : 54.0351 : stalled 1 times (last best: 53.6424)
[2021-05-31 02:45:44] Translating validation set...
[2021-05-31 02:45:59] Best translation 0 : &quot;We are sad for his loss but he left a heritage site to wake up racial and religion .
[2021-05-31 02:45:59] Best translation 1 : Several militants are also reported to have been killed by a United States missile that has been identified as the United States missile that has caused him from the war that is not required to be maintained by the United States of Pakistan.
[2021-05-31 02:46:07] Best translation 2 : &quot;The missile appeared to be shot by the plane not to be maintained by the plane.
[2021-05-31 02:46:07] Best translation 3 : &quot;They must have the capacity to replace these people, said a western intelligence officer said.
[2021-05-31 02:46:11] Best translation 4 : Williams was told to have the third senior member to get the third member of the crime.
[2021-05-31 02:46:11] Best translation 5 : The Pakistani government said they did not know about his death.
[2021-05-31 02:46:11] Best translation 10 : Los Angeles won only one goal in the first half.
[2021-05-31 02:46:11] Best translation 20 : The data collection is conducted by UNODC in Washington, D.C. and has collected data from the ocean and the World War II.
[2021-05-31 02:46:11] Best translation 40 : The gunman opened her hair , and the two men tried to come and help her .
[2021-05-31 02:46:11] Best translation 80 : If less than 50 % of the votes appeared to be less than 50 percent the candidates need at least 33 % of eligible voters .
[2021-05-31 02:46:11] Best translation 160 : The second route closed the road that was used as the Indian pacific railway .
[2021-05-31 02:46:29] Best translation 320 : &quot;Our model shows that we have had a temperature and water resources that are all the main material for living beings when it comes into the ten months.
[2021-05-31 02:47:05] Best translation 640 : The coast guard was accepted by the coast of London at 7 : 30 p.m.
[2021-05-31 02:47:12] Total translation time: 88.23890s
[2021-05-31 02:47:12] [valid] Ep. 9 : Up. 120000 : bleu : 9.96411 : new best
...
...
...
[2021-05-31 04:25:40] Best translation 2 : &quot;The missile appeared to be shot by the plane not to be maintained by the plane.
[2021-05-31 04:25:40] Best translation 3 : &quot;They must have the ability to replace these people, said an Western intelligence officer said.
[2021-05-31 04:25:45] Best translation 4 : Williams was told to have the third senior member to get the third member of Sagaing ?
[2021-05-31 04:25:45] Best translation 5 : The Pakistani government said they didn&apos;t know about his death.
[2021-05-31 04:25:45] Best translation 10 : Los Angeles won only one goal in the first half.
[2021-05-31 04:25:45] Best translation 20 : According to Washington, D.C. is a research agency based in Washington D.C. and the data collected from the ocean and the World War II.
[2021-05-31 04:25:45] Best translation 40 : She tried to look at her hair , and the two men tried to come and help her .
[2021-05-31 04:25:45] Best translation 80 : If less than 50 % of the votes appeared to be less than 50 percent the candidates need at least 33 % of eligible voters .
[2021-05-31 04:25:45] Best translation 160 : The second route closed the road that was used as the Indian pacific road .
[2021-05-31 04:26:03] Best translation 320 : &quot;Our model shows that we have a temperature and water resources that are all the main products for living beings when it comes into ten months.
[2021-05-31 04:26:42] Best translation 640 : The Coast Guard received a state of emergency alert at 7 : 30 p.m.
[2021-05-31 04:26:49] Total translation time: 91.31767s
[2021-05-31 04:26:49] [valid] Ep. 10 : Up. 125000 : bleu : 9.83847 : stalled 1 times (last best: 9.96411)
...
...
...
[2021-05-31 06:06:03] Best translation 160 : The second track closed the road that was used as the Indian pacific road .
[2021-05-31 06:06:22] Best translation 320 : &quot;Our model is pointing that we have got a temperature and water resources that are all the main products for living beings when it comes into ten months.
[2021-05-31 06:07:04] Best translation 640 : The Coast Guard received a state of emergency alert at 7 : 30 p.m.
[2021-05-31 06:07:11] Total translation time: 96.48475s
[2021-05-31 06:07:11] [valid] Ep. 10 : Up. 130000 : bleu : 9.79908 : stalled 2 times (last best: 9.96411)
...
...
...
[2021-05-31 16:11:05] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-31 16:11:07] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter160000.npz
[2021-05-31 16:11:08] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-31 16:11:10] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-31 16:11:25] [valid] Ep. 12 : Up. 160000 : cross-entropy : 114.861 : stalled 9 times (last best: 112.772)
[2021-05-31 16:11:36] [valid] Ep. 12 : Up. 160000 : perplexity : 57.7486 : stalled 9 times (last best: 53.6424)
[2021-05-31 16:11:36] Translating validation set...
[2021-05-31 16:11:52] Best translation 0 : &quot;We are sorry for his loss but he left a heritage site to wake up racial and religious forces.
[2021-05-31 16:11:52] Best translation 1 : Another militants are also reported to have been killed by a U.S. missile that has been identified as the U.S. missile that is now identified as the U.S. missile that has been identified as the U.S. missile that has already been identified by the United States of Pakistan.
[2021-05-31 16:11:57] Best translation 2 : &quot;The missile appeared to be fired from the plane that no need to be maintained by the plane.
[2021-05-31 16:11:57] Best translation 3 : &quot;They must have the ability to replace these people, said an Western intelligence official said.
[2021-05-31 16:12:01] Best translation 4 : Williams was told to have got the third senior member to get the third highest organ of the crime.
[2021-05-31 16:12:01] Best translation 5 : The Pakistani government said they didn&apos;t know about his death.
[2021-05-31 16:12:01] Best translation 10 : Los Angeles won only one goal on the first half.
[2021-05-31 16:12:01] Best translation 20 : A U.S. trade center based at Washington, D.C. has performed the research from the ocean to the ocean and the world atmosphere in Washington D.C.
[2021-05-31 16:12:01] Best translation 40 : She tried to look at her hair , and the two men tried to come and help her .
[2021-05-31 16:12:01] Best translation 80 : If less than 50 % of the votes appeared , a candidate needs at least 33 percent of the vote .
[2021-05-31 16:12:01] Best translation 160 : The second course was closed to Sydney on the road as the Indian pacific road .
[2021-05-31 16:12:16] Best translation 320 : &quot;Our model shows that we have a temperature and water for living beings when it comes up within ten months.
[2021-05-31 16:12:54] Best translation 640 : The Coast Guard received a state of emergency alert at 7 : 30 p.m.
[2021-05-31 16:13:02] Total translation time: 85.69296s
[2021-05-31 16:13:02] [valid] Ep. 12 : Up. 160000 : bleu : 9.71942 : stalled 8 times (last best: 9.96411)
...
...
...
[2021-05-31 17:24:23] Ep. 12 : Up. 163500 : Sen. 209,584 : Cost 1.35365987 * 132,111 after 43,071,636 : Time 605.86s : 218.06 words/s
[2021-05-31 17:34:07] Ep. 12 : Up. 164000 : Sen. 218,570 : Cost 1.36348295 * 131,597 after 43,203,233 : Time 584.71s : 225.06 words/s
[2021-05-31 17:43:48] Ep. 12 : Up. 164500 : Sen. 227,511 : Cost 1.36625218 * 130,968 after 43,334,201 : Time 580.36s : 225.67 words/s
[2021-05-31 17:53:27] Ep. 12 : Up. 165000 : Sen. 236,588 : Cost 1.35593450 * 132,186 after 43,466,387 : Time 578.96s : 228.32 words/s
[2021-05-31 17:53:27] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-31 17:53:29] Saving model weights and runtime parameters to model.s2s-4.my-en/model.iter165000.npz
[2021-05-31 17:53:30] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-31 17:53:32] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz
[2021-05-31 17:53:47] [valid] Ep. 12 : Up. 165000 : cross-entropy : 115.196 : stalled 10 times (last best: 112.772)
[2021-05-31 17:53:58] [valid] Ep. 12 : Up. 165000 : perplexity : 58.4361 : stalled 10 times (last best: 53.6424)
[2021-05-31 17:53:58] Translating validation set...
[2021-05-31 17:54:14] Best translation 0 : &quot;We are sorry for his loss but he left a heritage site to wake up racial and religious conversion .
[2021-05-31 17:54:14] Best translation 1 : Another militants are also reported to have been killed by a U.S. missile that has been identified as the U.S. missile that has been identified as the U.S. missile that has already been identified as the U.S. missile that has been identified by the U.S.
[2021-05-31 17:54:19] Best translation 2 : &quot;The missile appeared to be fired from the airplane which is not required to be maintained by the plane.
[2021-05-31 17:54:19] Best translation 3 : &quot;They must have the ability to replace these people, said an Western intelligence official said.
[2021-05-31 17:54:25] Best translation 4 : Williams was told to have got the third senior member to get the third highest organ of the crime.
[2021-05-31 17:54:25] Best translation 5 : The Pakistani government said they didn&apos;t know about his death.
[2021-05-31 17:54:25] Best translation 10 : Los Angeles won only one goal on the first half.
[2021-05-31 17:54:25] Best translation 20 : The data compiled in Washington DC pick up research into the ocean and the world&apos;s atmosphere as well as research at the Washington, D.C.
[2021-05-31 17:54:25] Best translation 40 : She tried to look at her hair , and the two men tried to come and help her .
[2021-05-31 17:54:25] Best translation 80 : If less than 50 % of the votes appeared , a candidate needs at least 33 percent of the vote .
[2021-05-31 17:54:25] Best translation 160 : The second path has been closed to Sydney on the road to the Sydney route from Sydney .
[2021-05-31 17:54:40] Best translation 320 : &quot;Our model shows that we have got a temperature and water for living beings when it comes up within ten months.
[2021-05-31 17:55:19] Best translation 640 : The Coast Guard received a state of emergency alert at 7 : 30 p.m.
[2021-05-31 17:55:26] Total translation time: 88.12130s
[2021-05-31 17:55:26] [valid] Ep. 12 : Up. 165000 : bleu : 9.89767 : stalled 9 times (last best: 9.96411)
[2021-05-31 17:55:27] Training finished
[2021-05-31 17:55:29] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz.orig.npz
[2021-05-31 17:55:31] Saving model weights and runtime parameters to model.s2s-4.my-en/model.npz
[2021-05-31 17:55:34] Saving Adam parameters to model.s2s-4.my-en/model.npz.optimizer.npz

real	3229m25.960s
user	5353m47.530s
sys	2m59.490s

real	3229m26.133s
user	5353m47.586s
sys	2m59.521s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$
```

## Translation

```
time marian-decoder -m ./model.npz -v ../data/vocab/vocab.my.yml ../data/vocab/vocab.en.yml --devices 0 1 --output hyp.model.en < ../data/test.my

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.my-en$ time marian-decoder -m ./model.npz -v ../data/vocab/vocab.my.yml ../data/vocab/vocab.en.yml --devices 0 1 --output hyp.model.en < ../data/test.my
...
...
...
[2021-06-01 01:31:54] Best translation 988 : Around a short time prior to walking back to the city streets around the Metropolitan area, he saw cancer at a short time.
[2021-06-01 01:31:54] Best translation 989 : The police said that NASA has visited the biggest sale of the city, known as the largest size of the city.
[2021-06-01 01:31:55] Best translation 990 : He also went through this nightclub in which both the main train railway station and the United States Department of commerce had in both the main railway station and the rugby union headquarters in both the United States.
[2021-06-01 01:31:55] Best translation 991 : Around an hour of the town had been searched for nearly an hour before he was finally to be able to restore her in the hut of thanked Australia.
[2021-06-01 01:31:55] Best translation 992 : soap officers and police were searched for Sasha but she said that she didn &amp; apos ; t answer their call
[2021-06-01 01:31:55] Best translation 993 : Police said she had difficulty to preserve her in the police but also said she had been changed quickly .
[2021-06-01 01:31:56] Best translation 994 : At about 2,000 local time, an animal could have been able to control the animal by an animal control and she presented her into a truck that would take her into the museum at the site, where he has been taking her into the museum where he has been taking her into the museum at around 2,000 local time.
[2021-06-01 01:31:56] Best translation 995 : There was no reports of any loss or injuries during the accident , but police managed to arrest the videos of the events by the police .
[2021-06-01 01:31:57] Best translation 996 : The circus was said to be released after the storm was shocked by the storm near the city.
[2021-06-01 01:31:57] Best translation 997 : After returning to the circus he was pleased to have said that although I told her it was tired
[2021-06-01 01:31:57] Best translation 998 : They took part in a car crash during a car crash during a car accident in south Wales , south of south and 78 of his wife .
[2021-06-01 01:31:57] Best translation 999 : Mrs. Wilson was dead and Mr. dictionary felt a broken pain .
[2021-06-01 01:31:57] Best translation 1000 : Their wives returned from a poem that they offered to both .
[2021-06-01 01:31:58] Best translation 1001 : London.
[2021-06-01 01:31:58] Best translation 1002 : Her wife , her wife , is a professional and writer .
[2021-06-01 01:31:58] Best translation 1003 : He is known as a poet and a medical doctor .
[2021-06-01 01:31:58] Best translation 1004 : The dictionary was a specialist at a clinic for over thirty years.&quot;
[2021-06-01 01:31:58] Best translation 1005 : But it was best recognized for his writing and received many literary awards and members of several literary awards .
[2021-06-01 01:31:58] Best translation 1006 : In 1989 he got a specialist graduate from the University of Wales .
[2021-06-01 01:31:59] Best translation 1007 : Their wives had worked together for two books in the 1980s .
[2021-06-01 01:31:59] Best translation 1008 : The dictionary left her husband , a son , a son and two daughters .
[2021-06-01 01:31:59] Best translation 1009 : With the back of the return to her home in California after the return to her home in California, California has been arrested and fined on Wednesday to be arrested and fined on Wednesday.
[2021-06-01 01:31:59] Best translation 1010 : At least four others were banned or arrested by police.
[2021-06-01 01:31:59] Best translation 1011 : According to reports, a group of reporters following a high speed group was followed by a group of reporters at around 8 a.m.
[2021-06-01 01:32:00] Best translation 1012 : They also said they were very close behind her and converted to the dangerous road in order to follow her later .
[2021-06-01 01:32:00] Best translation 1013 : The police also confirmed that she had been driving at least one of the cars driving her car from at least one cars to avoid being able to avoid being able to identify it or not to identify it.
[2021-06-01 01:32:00] Best translation 1014 : They reported to express her personal point and was released
[2021-06-01 01:32:01] Best translation 1015 : They reported that the police had been checking out that police were checking out her driving licence and was surprised due to the right licenses .
[2021-06-01 01:32:01] Best translation 1016 : Wikipedia did not want a compensation for any damage made by reporters and did not want people arrested
[2021-06-01 01:32:01] Best translation 1017 : &quot;A part of the organization is part of the organization but the spokesperson said.
[2021-06-01 01:32:01] Total time: 283.27131s wall

real	4m45.351s
user	9m26.360s
sys	0m2.134s
```

## Evaluation

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.my-en$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ../data/test.en < ./hyp.model.en  >> results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.my-en$ cat ./results.txt 
BLEU = 10.21, 43.6/18.0/8.6/4.2 (BP=0.786, ratio=0.806, hyp_len=22514, ref_len=27929)
```
    
## System 6: Transformer Script (Myanmar-English)

```
mkdir model.transformer.my-en;

marian \
    --model model.transformer.my-en/model.npz --type transformer \
    --train-sets data/train.my data/train.en \
    --max-length 200 \
    --vocabs data/vocab/vocab.my.yml data/vocab/vocab.en.yml \
    --mini-batch-fit -w 1000 --maxi-batch 100 \
    --early-stopping 10 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics cross-entropy perplexity bleu \
    --valid-sets data/valid.my data/valid.en \
    --valid-translation-output data/valid.my-en.output --quiet-translation \
    --valid-mini-batch 64 \
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
```

## Training Log

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./transformer.my-en.sh 
[2021-06-01 01:44:26] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-01 01:44:26] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 102462 with command line:
[2021-06-01 01:44:26] [marian] marian -c model.transformer.my-en/config.yml
[2021-06-01 01:44:26] [config] after: 0e
[2021-06-01 01:44:26] [config] after-batches: 0
[2021-06-01 01:44:26] [config] after-epochs: 0
[2021-06-01 01:44:26] [config] all-caps-every: 0
[2021-06-01 01:44:26] [config] allow-unk: false
[2021-06-01 01:44:26] [config] authors: false
[2021-06-01 01:44:26] [config] beam-size: 6
[2021-06-01 01:44:26] [config] bert-class-symbol: "[CLS]"
[2021-06-01 01:44:26] [config] bert-mask-symbol: "[MASK]"
[2021-06-01 01:44:26] [config] bert-masking-fraction: 0.15
[2021-06-01 01:44:26] [config] bert-sep-symbol: "[SEP]"
[2021-06-01 01:44:26] [config] bert-train-type-embeddings: true
[2021-06-01 01:44:26] [config] bert-type-vocab-size: 2
[2021-06-01 01:44:26] [config] build-info: ""
[2021-06-01 01:44:26] [config] cite: false
[2021-06-01 01:44:26] [config] clip-norm: 5
[2021-06-01 01:44:26] [config] cost-scaling:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] cost-type: ce-sum
[2021-06-01 01:44:26] [config] cpu-threads: 0
[2021-06-01 01:44:26] [config] data-weighting: ""
[2021-06-01 01:44:26] [config] data-weighting-type: sentence
[2021-06-01 01:44:26] [config] dec-cell: gru
[2021-06-01 01:44:26] [config] dec-cell-base-depth: 2
[2021-06-01 01:44:26] [config] dec-cell-high-depth: 1
[2021-06-01 01:44:26] [config] dec-depth: 2
[2021-06-01 01:44:26] [config] devices:
[2021-06-01 01:44:26] [config]   - 0
[2021-06-01 01:44:26] [config]   - 1
[2021-06-01 01:44:26] [config] dim-emb: 512
[2021-06-01 01:44:26] [config] dim-rnn: 1024
[2021-06-01 01:44:26] [config] dim-vocabs:
[2021-06-01 01:44:26] [config]   - 0
[2021-06-01 01:44:26] [config]   - 0
[2021-06-01 01:44:26] [config] disp-first: 0
[2021-06-01 01:44:26] [config] disp-freq: 500
[2021-06-01 01:44:26] [config] disp-label-counts: true
[2021-06-01 01:44:26] [config] dropout-rnn: 0
[2021-06-01 01:44:26] [config] dropout-src: 0
[2021-06-01 01:44:26] [config] dropout-trg: 0
[2021-06-01 01:44:26] [config] dump-config: ""
[2021-06-01 01:44:26] [config] early-stopping: 10
[2021-06-01 01:44:26] [config] embedding-fix-src: false
[2021-06-01 01:44:26] [config] embedding-fix-trg: false
[2021-06-01 01:44:26] [config] embedding-normalization: false
[2021-06-01 01:44:26] [config] embedding-vectors:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] enc-cell: gru
[2021-06-01 01:44:26] [config] enc-cell-depth: 1
[2021-06-01 01:44:26] [config] enc-depth: 2
[2021-06-01 01:44:26] [config] enc-type: bidirectional
[2021-06-01 01:44:26] [config] english-title-case-every: 0
[2021-06-01 01:44:26] [config] exponential-smoothing: 0.0001
[2021-06-01 01:44:26] [config] factor-weight: 1
[2021-06-01 01:44:26] [config] grad-dropping-momentum: 0
[2021-06-01 01:44:26] [config] grad-dropping-rate: 0
[2021-06-01 01:44:26] [config] grad-dropping-warmup: 100
[2021-06-01 01:44:26] [config] gradient-checkpointing: false
[2021-06-01 01:44:26] [config] guided-alignment: none
[2021-06-01 01:44:26] [config] guided-alignment-cost: mse
[2021-06-01 01:44:26] [config] guided-alignment-weight: 0.1
[2021-06-01 01:44:26] [config] ignore-model-config: false
[2021-06-01 01:44:26] [config] input-types:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] interpolate-env-vars: false
[2021-06-01 01:44:26] [config] keep-best: false
[2021-06-01 01:44:26] [config] label-smoothing: 0.1
[2021-06-01 01:44:26] [config] layer-normalization: false
[2021-06-01 01:44:26] [config] learn-rate: 0.0003
[2021-06-01 01:44:26] [config] lemma-dim-emb: 0
[2021-06-01 01:44:26] [config] log: model.transformer.my-en/train.log
[2021-06-01 01:44:26] [config] log-level: info
[2021-06-01 01:44:26] [config] log-time-zone: ""
[2021-06-01 01:44:26] [config] logical-epoch:
[2021-06-01 01:44:26] [config]   - 1e
[2021-06-01 01:44:26] [config]   - 0
[2021-06-01 01:44:26] [config] lr-decay: 0
[2021-06-01 01:44:26] [config] lr-decay-freq: 50000
[2021-06-01 01:44:26] [config] lr-decay-inv-sqrt:
[2021-06-01 01:44:26] [config]   - 16000
[2021-06-01 01:44:26] [config] lr-decay-repeat-warmup: false
[2021-06-01 01:44:26] [config] lr-decay-reset-optimizer: false
[2021-06-01 01:44:26] [config] lr-decay-start:
[2021-06-01 01:44:26] [config]   - 10
[2021-06-01 01:44:26] [config]   - 1
[2021-06-01 01:44:26] [config] lr-decay-strategy: epoch+stalled
[2021-06-01 01:44:26] [config] lr-report: true
[2021-06-01 01:44:26] [config] lr-warmup: 0
[2021-06-01 01:44:26] [config] lr-warmup-at-reload: false
[2021-06-01 01:44:26] [config] lr-warmup-cycle: false
[2021-06-01 01:44:26] [config] lr-warmup-start-rate: 0
[2021-06-01 01:44:26] [config] max-length: 200
[2021-06-01 01:44:26] [config] max-length-crop: false
[2021-06-01 01:44:26] [config] max-length-factor: 3
[2021-06-01 01:44:26] [config] maxi-batch: 100
[2021-06-01 01:44:26] [config] maxi-batch-sort: trg
[2021-06-01 01:44:26] [config] mini-batch: 64
[2021-06-01 01:44:26] [config] mini-batch-fit: true
[2021-06-01 01:44:26] [config] mini-batch-fit-step: 10
[2021-06-01 01:44:26] [config] mini-batch-track-lr: false
[2021-06-01 01:44:26] [config] mini-batch-warmup: 0
[2021-06-01 01:44:26] [config] mini-batch-words: 0
[2021-06-01 01:44:26] [config] mini-batch-words-ref: 0
[2021-06-01 01:44:26] [config] model: model.transformer.my-en/model.npz
[2021-06-01 01:44:26] [config] multi-loss-type: sum
[2021-06-01 01:44:26] [config] multi-node: false
[2021-06-01 01:44:26] [config] multi-node-overlap: true
[2021-06-01 01:44:26] [config] n-best: false
[2021-06-01 01:44:26] [config] no-nccl: false
[2021-06-01 01:44:26] [config] no-reload: false
[2021-06-01 01:44:26] [config] no-restore-corpus: false
[2021-06-01 01:44:26] [config] normalize: 0.6
[2021-06-01 01:44:26] [config] normalize-gradient: false
[2021-06-01 01:44:26] [config] num-devices: 0
[2021-06-01 01:44:26] [config] optimizer: adam
[2021-06-01 01:44:26] [config] optimizer-delay: 1
[2021-06-01 01:44:26] [config] optimizer-params:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] output-omit-bias: false
[2021-06-01 01:44:26] [config] overwrite: false
[2021-06-01 01:44:26] [config] precision:
[2021-06-01 01:44:26] [config]   - float32
[2021-06-01 01:44:26] [config]   - float32
[2021-06-01 01:44:26] [config]   - float32
[2021-06-01 01:44:26] [config] pretrained-model: ""
[2021-06-01 01:44:26] [config] quantize-biases: false
[2021-06-01 01:44:26] [config] quantize-bits: 0
[2021-06-01 01:44:26] [config] quantize-log-based: false
[2021-06-01 01:44:26] [config] quantize-optimization-steps: 0
[2021-06-01 01:44:26] [config] quiet: false
[2021-06-01 01:44:26] [config] quiet-translation: true
[2021-06-01 01:44:26] [config] relative-paths: false
[2021-06-01 01:44:26] [config] right-left: false
[2021-06-01 01:44:26] [config] save-freq: 5000
[2021-06-01 01:44:26] [config] seed: 1111
[2021-06-01 01:44:26] [config] sentencepiece-alphas:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] sentencepiece-max-lines: 2000000
[2021-06-01 01:44:26] [config] sentencepiece-options: ""
[2021-06-01 01:44:26] [config] shuffle: data
[2021-06-01 01:44:26] [config] shuffle-in-ram: false
[2021-06-01 01:44:26] [config] sigterm: save-and-exit
[2021-06-01 01:44:26] [config] skip: false
[2021-06-01 01:44:26] [config] sqlite: ""
[2021-06-01 01:44:26] [config] sqlite-drop: false
[2021-06-01 01:44:26] [config] sync-sgd: true
[2021-06-01 01:44:26] [config] tempdir: /tmp
[2021-06-01 01:44:26] [config] tied-embeddings: true
[2021-06-01 01:44:26] [config] tied-embeddings-all: false
[2021-06-01 01:44:26] [config] tied-embeddings-src: false
[2021-06-01 01:44:26] [config] train-embedder-rank:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] train-sets:
[2021-06-01 01:44:26] [config]   - data/train.my
[2021-06-01 01:44:26] [config]   - data/train.en
[2021-06-01 01:44:26] [config] transformer-aan-activation: swish
[2021-06-01 01:44:26] [config] transformer-aan-depth: 2
[2021-06-01 01:44:26] [config] transformer-aan-nogate: false
[2021-06-01 01:44:26] [config] transformer-decoder-autoreg: self-attention
[2021-06-01 01:44:26] [config] transformer-depth-scaling: false
[2021-06-01 01:44:26] [config] transformer-dim-aan: 2048
[2021-06-01 01:44:26] [config] transformer-dim-ffn: 2048
[2021-06-01 01:44:26] [config] transformer-dropout: 0.3
[2021-06-01 01:44:26] [config] transformer-dropout-attention: 0
[2021-06-01 01:44:26] [config] transformer-dropout-ffn: 0
[2021-06-01 01:44:26] [config] transformer-ffn-activation: swish
[2021-06-01 01:44:26] [config] transformer-ffn-depth: 2
[2021-06-01 01:44:26] [config] transformer-guided-alignment-layer: last
[2021-06-01 01:44:26] [config] transformer-heads: 8
[2021-06-01 01:44:26] [config] transformer-no-projection: false
[2021-06-01 01:44:26] [config] transformer-pool: false
[2021-06-01 01:44:26] [config] transformer-postprocess: dan
[2021-06-01 01:44:26] [config] transformer-postprocess-emb: d
[2021-06-01 01:44:26] [config] transformer-postprocess-top: ""
[2021-06-01 01:44:26] [config] transformer-preprocess: ""
[2021-06-01 01:44:26] [config] transformer-tied-layers:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] transformer-train-position-embeddings: false
[2021-06-01 01:44:26] [config] tsv: false
[2021-06-01 01:44:26] [config] tsv-fields: 0
[2021-06-01 01:44:26] [config] type: transformer
[2021-06-01 01:44:26] [config] ulr: false
[2021-06-01 01:44:26] [config] ulr-dim-emb: 0
[2021-06-01 01:44:26] [config] ulr-dropout: 0
[2021-06-01 01:44:26] [config] ulr-keys-vectors: ""
[2021-06-01 01:44:26] [config] ulr-query-vectors: ""
[2021-06-01 01:44:26] [config] ulr-softmax-temperature: 1
[2021-06-01 01:44:26] [config] ulr-trainable-transformation: false
[2021-06-01 01:44:26] [config] unlikelihood-loss: false
[2021-06-01 01:44:26] [config] valid-freq: 5000
[2021-06-01 01:44:26] [config] valid-log: model.transformer.my-en/valid.log
[2021-06-01 01:44:26] [config] valid-max-length: 1000
[2021-06-01 01:44:26] [config] valid-metrics:
[2021-06-01 01:44:26] [config]   - cross-entropy
[2021-06-01 01:44:26] [config]   - perplexity
[2021-06-01 01:44:26] [config]   - bleu
[2021-06-01 01:44:26] [config] valid-mini-batch: 64
[2021-06-01 01:44:26] [config] valid-reset-stalled: false
[2021-06-01 01:44:26] [config] valid-script-args:
[2021-06-01 01:44:26] [config]   []
[2021-06-01 01:44:26] [config] valid-script-path: ""
[2021-06-01 01:44:26] [config] valid-sets:
[2021-06-01 01:44:26] [config]   - data/valid.my
[2021-06-01 01:44:26] [config]   - data/valid.en
[2021-06-01 01:44:26] [config] valid-translation-output: data/valid.my-en.output
[2021-06-01 01:44:26] [config] vocabs:
[2021-06-01 01:44:26] [config]   - data/vocab/vocab.my.yml
[2021-06-01 01:44:26] [config]   - data/vocab/vocab.en.yml
[2021-06-01 01:44:26] [config] word-penalty: 0
[2021-06-01 01:44:26] [config] word-scores: false
[2021-06-01 01:44:26] [config] workspace: 1000
[2021-06-01 01:44:26] [config] Model is being created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-01 01:44:26] Using synchronous SGD
[2021-06-01 01:44:26] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.my.yml
[2021-06-01 01:44:26] [data] Setting vocabulary size for input 0 to 12,379
[2021-06-01 01:44:26] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.en.yml
[2021-06-01 01:44:27] [data] Setting vocabulary size for input 1 to 85,602
[2021-06-01 01:44:27] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-06-01 01:44:27] [batching] Collecting statistics for batch fitting with step size 10
[2021-06-01 01:44:27] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-06-01 01:44:27] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-06-01 01:44:27] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-01 01:44:27] [comm] NCCLCommunicator constructed successfully
[2021-06-01 01:44:27] [training] Using 2 GPUs
[2021-06-01 01:44:27] [logits] Applying loss function for 1 factor(s)
[2021-06-01 01:44:27] [memory] Reserving 247 MB, device gpu0
[2021-06-01 01:44:27] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-06-01 01:44:28] [memory] Reserving 247 MB, device gpu0
[2021-06-01 01:44:48] [batching] Done. Typical MB size is 1,943 target words
[2021-06-01 01:44:49] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-06-01 01:44:49] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-06-01 01:44:49] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-01 01:44:49] [comm] NCCLCommunicator constructed successfully
[2021-06-01 01:44:49] [training] Using 2 GPUs
[2021-06-01 01:44:49] Training started
[2021-06-01 01:44:49] [data] Shuffling data
[2021-06-01 01:44:49] [data] Done reading 256,102 sentences
[2021-06-01 01:44:49] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 01:44:49] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-06-01 01:44:49] [memory] Reserving 247 MB, device gpu1
[2021-06-01 01:44:49] [memory] Reserving 247 MB, device gpu0
[2021-06-01 01:44:49] [memory] Reserving 247 MB, device gpu0
[2021-06-01 01:44:50] [memory] Reserving 247 MB, device gpu1
[2021-06-01 01:44:50] [memory] Reserving 123 MB, device gpu0
[2021-06-01 01:44:50] [memory] Reserving 123 MB, device gpu1
[2021-06-01 01:44:50] [memory] Reserving 247 MB, device gpu0
[2021-06-01 01:44:50] [memory] Reserving 247 MB, device gpu1
[2021-06-01 01:47:53] Ep. 1 : Up. 500 : Sen. 22,695 : Cost 7.04077768 * 355,867 @ 678 after 355,867 : Time 184.59s : 1927.93 words/s : L.r. 3.0000e-04
[2021-06-01 01:50:59] Ep. 1 : Up. 1000 : Sen. 45,749 : Cost 6.19613981 * 357,016 @ 705 after 712,883 : Time 185.88s : 1920.65 words/s : L.r. 3.0000e-04
[2021-06-01 01:54:03] Ep. 1 : Up. 1500 : Sen. 68,750 : Cost 5.91675615 * 353,898 @ 658 after 1,066,781 : Time 183.82s : 1925.26 words/s : L.r. 3.0000e-04
[2021-06-01 01:57:06] Ep. 1 : Up. 2000 : Sen. 91,216 : Cost 5.76522160 * 354,385 @ 840 after 1,421,166 : Time 183.14s : 1935.01 words/s : L.r. 3.0000e-04
[2021-06-01 02:00:08] Ep. 1 : Up. 2500 : Sen. 114,206 : Cost 5.59321737 * 355,939 @ 1,060 after 1,777,105 : Time 182.06s : 1955.08 words/s : L.r. 3.0000e-04
[2021-06-01 02:03:10] Ep. 1 : Up. 3000 : Sen. 136,870 : Cost 5.53270197 * 355,098 @ 648 after 2,132,203 : Time 182.42s : 1946.56 words/s : L.r. 3.0000e-04
[2021-06-01 02:06:12] Ep. 1 : Up. 3500 : Sen. 159,842 : Cost 5.40660954 * 357,143 @ 770 after 2,489,346 : Time 181.81s : 1964.33 words/s : L.r. 3.0000e-04
[2021-06-01 02:09:12] Ep. 1 : Up. 4000 : Sen. 182,470 : Cost 5.34304953 * 354,457 @ 560 after 2,843,803 : Time 179.55s : 1974.15 words/s : L.r. 3.0000e-04
[2021-06-01 02:12:12] Ep. 1 : Up. 4500 : Sen. 205,199 : Cost 5.23397112 * 354,690 @ 517 after 3,198,493 : Time 179.70s : 1973.74 words/s : L.r. 3.0000e-04
[2021-06-01 02:15:11] Ep. 1 : Up. 5000 : Sen. 228,090 : Cost 5.15136671 * 355,726 @ 700 after 3,554,219 : Time 179.60s : 1980.62 words/s : L.r. 3.0000e-04
[2021-06-01 02:15:11] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 02:15:12] Saving model weights and runtime parameters to model.transformer.my-en/model.iter5000.npz
[2021-06-01 02:15:13] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 02:15:14] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x556bbe4c0000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x556b862e8000 @ 
tcmalloc: large alloc 1476395008 bytes == 0x556b862e8000 @ 
tcmalloc: large alloc 1610612736 bytes == 0x556c362e8000 @ 
tcmalloc: large alloc 1744830464 bytes == 0x556be62e8000 @ 
tcmalloc: large alloc 2013265920 bytes == 0x556bf62e8000 @ 
tcmalloc: large alloc 2281701376 bytes == 0x556d4a5a2000 @ 
[2021-06-01 02:15:31] Error: CUDA error 2 'out of memory' - /home/ye/tool/marian/src/tensors/gpu/device.cu:32: cudaMalloc(&data_, size)
[2021-06-01 02:15:31] Error: Aborted from virtual void marian::gpu::Device::reserve(size_t) in /home/ye/tool/marian/src/tensors/gpu/device.cu:32

[CALL STACK]
[0x556b5bdfc880]    marian::gpu::Device::  reserve  (unsigned long)    + 0xf80
[0x556b5b72c7df]    marian::TensorAllocator::  allocate  (IntrusivePtr<marian::TensorBase>&,  marian::Shape,  marian::Type) + 0x4ef
[0x556b5b938b00]    marian::Node::  allocate  ()                       + 0x1e0
[0x556b5b92f2ce]    marian::ExpressionGraph::  forward  (std::__cxx11::list<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>,std::allocator<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>>>&,  bool) + 0x8e
[0x556b5b930cae]    marian::ExpressionGraph::  forwardNext  ()         + 0x24e
[0x556b5bb01e64]                                                       + 0x77de64
[0x556b5bb02694]                                                       + 0x77e694
[0x556b5b6d615d]    std::__future_base::_State_baseV2::  _M_do_set  (std::function<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> ()>*,  bool*) + 0x2d
[0x7fbbfa0afc0f]                                                       + 0x11c0f
[0x556b5baf918a]                                                       + 0x77518a
[0x556b5b6d889a]    std::thread::_State_impl<std::thread::_Invoker<std::tuple<marian::ThreadPool::reserve(unsigned long)::{lambda()#1}>>>::  _M_run  () + 0x13a
[0x7fbbf9f93d84]                                                       + 0xd6d84
[0x7fbbfa0a7590]                                                       + 0x9590
[0x7fbbf9c82223]    clone                                              + 0x43


real	31m4.648s
user	46m20.530s
sys	0m10.001s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ 
```

Restart the machine and try again...

```
[2021-06-01 03:50:08] Ep. 2 : Up. 10000 : Sen. 200,296 : Cost 4.71337128 * 353,714 @ 696 after 7,106,187 : Time 179.79s : 1967.36 words/s : L.r. 3.0000e-04
[2021-06-01 03:50:08] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 03:50:09] Saving model weights and runtime parameters to model.transformer.my-en/model.iter10000.npz
[2021-06-01 03:50:09] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 03:50:10] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x56531e6da000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x56531e6da000 @ 
tcmalloc: large alloc 1476395008 bytes == 0x5653ce386000 @ 
tcmalloc: large alloc 1610612736 bytes == 0x56536e6da000 @ 
tcmalloc: large alloc 1744830464 bytes == 0x56531e6da000 @ 
tcmalloc: large alloc 2013265920 bytes == 0x56538e6da000 @ 
tcmalloc: large alloc 2281701376 bytes == 0x565426b86000 @ 
tcmalloc: large alloc 2550136832 bytes == 0x565426b86000 @ 
[2021-06-01 03:50:35] [valid] Ep. 2 : Up. 10000 : cross-entropy : 146.187 : new best
[2021-06-01 03:50:39] [valid] Ep. 2 : Up. 10000 : perplexity : 174.572 : new best
[2021-06-01 03:51:29] [valid] [valid] First sentence's tokens as scored:
[2021-06-01 03:51:29] [valid] DefaultVocab keeps original segments for scoring
[2021-06-01 03:51:29] [valid] [valid]   Hyp: According to the news news news news news news news news news news news news news news news , a woman who said that she was a woman &amp; quot ; she said .
[2021-06-01 03:51:29] [valid] [valid]   Ref: A reporter for the Al Jazeera news agency remarked : &amp; quot ; Officials have been cited as saying that the incident may have been caused by pyrotechnics that caused an explosion leading to a significant loss of life . &amp; quot ;
tcmalloc: large alloc 2818572288 bytes == 0x565426b86000 @ 
[2021-06-01 03:53:37] Error: CUDA error 2 'out of memory' - /home/ye/tool/marian/src/tensors/gpu/device.cu:32: cudaMalloc(&data_, size)
[2021-06-01 03:53:37] Error: Aborted from virtual void marian::gpu::Device::reserve(size_t) in /home/ye/tool/marian/src/tensors/gpu/device.cu:32

[CALL STACK]
[0x5652d33db880]    marian::gpu::Device::  reserve  (unsigned long)    + 0xf80
[0x5652d2d0b7df]    marian::TensorAllocator::  allocate  (IntrusivePtr<marian::TensorBase>&,  marian::Shape,  marian::Type) + 0x4ef
[0x5652d2f17b00]    marian::Node::  allocate  ()                       + 0x1e0
[0x5652d2f0e2ce]    marian::ExpressionGraph::  forward  (std::__cxx11::list<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>,std::allocator<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>>>&,  bool) + 0x8e
[0x5652d2f0fcae]    marian::ExpressionGraph::  forwardNext  ()         + 0x24e
[0x5652d30641a0]    marian::BeamSearch::  search  (std::shared_ptr<marian::ExpressionGraph>,  std::shared_ptr<marian::data::CorpusBatch>) + 0x5310
[0x5652d30f0732]                                                       + 0x78d732
[0x5652d30f1794]                                                       + 0x78e794
[0x5652d2cb515d]    std::__future_base::_State_baseV2::  _M_do_set  (std::function<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> ()>*,  bool*) + 0x2d
[0x7fc66aef4c0f]                                                       + 0x11c0f
[0x5652d30d860a]                                                       + 0x77560a
[0x5652d2cb789a]    std::thread::_State_impl<std::thread::_Invoker<std::tuple<marian::ThreadPool::reserve(unsigned long)::{lambda()#1}>>>::  _M_run  () + 0x13a
[0x7fc66add8d84]                                                       + 0xd6d84
[0x7fc66aeec590]                                                       + 0x9590
[0x7fc66aac7223]    clone                                              + 0x43


real	34m18.015s
user	52m29.121s
sys	0m17.350s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ 
```

## Update the Script and ReTrain

batch sie ကို ပြင်ခဲ့...  

```
    --mini-batch-fit -w 1000 --maxi-batch 64 \
```

Train again ...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./transformer.my-en.sh
...
...
[2021-06-01 05:38:59] [memory] Reserving 247 MB, device gpu1
[2021-06-01 05:38:59] Loading model from model.transformer.my-en/model.npz
[2021-06-01 05:38:59] [memory] Reserving 247 MB, device cpu0
[2021-06-01 05:38:59] [memory] Reserving 123 MB, device gpu0
[2021-06-01 05:38:59] [memory] Reserving 123 MB, device gpu1
[2021-06-01 05:41:57] Ep. 2 : Up. 10500 : Sen. 221,742 : Cost 4.47287273 * 334,629 @ 625 after 7,440,816 : Time 183.08s : 1827.78 words/s : L.r. 3.0000e-04
[2021-06-01 05:44:55] Ep. 2 : Up. 11000 : Sen. 243,188 : Cost 4.63029289 * 334,282 @ 580 after 7,775,098 : Time 178.03s : 1877.68 words/s : L.r. 3.0000e-04
[2021-06-01 05:47:56] Ep. 2 : Up. 11500 : Sen. 264,647 : Cost 4.64701748 * 334,076 @ 449 after 8,109,174 : Time 180.84s : 1847.36 words/s : L.r. 3.0000e-04
[2021-06-01 05:48:29] Seen 268608 samples
[2021-06-01 05:48:29] Starting data epoch 3 in logical epoch 3
[2021-06-01 05:48:29] [data] Shuffling data
[2021-06-01 05:48:29] [data] Done reading 256,102 sentences
[2021-06-01 05:48:29] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 05:50:53] Ep. 3 : Up. 12000 : Sen. 17,719 : Cost 4.49174738 * 330,600 @ 688 after 8,439,774 : Time 177.34s : 1864.20 words/s : L.r. 3.0000e-04
[2021-06-01 05:53:51] Ep. 3 : Up. 12500 : Sen. 39,209 : Cost 4.47160292 * 336,436 @ 954 after 8,776,210 : Time 177.55s : 1894.90 words/s : L.r. 3.0000e-04
[2021-06-01 05:56:48] Ep. 3 : Up. 13000 : Sen. 60,895 : Cost 4.46169138 * 333,978 @ 463 after 9,110,188 : Time 176.91s : 1887.85 words/s : L.r. 3.0000e-04
[2021-06-01 05:59:44] Ep. 3 : Up. 13500 : Sen. 82,168 : Cost 4.47490215 * 332,732 @ 485 after 9,442,920 : Time 176.55s : 1884.62 words/s : L.r. 3.0000e-04
[2021-06-01 06:02:41] Ep. 3 : Up. 14000 : Sen. 103,456 : Cost 4.46470928 * 334,084 @ 554 after 9,777,004 : Time 176.77s : 1889.92 words/s : L.r. 3.0000e-04
[2021-06-01 06:05:37] Ep. 3 : Up. 14500 : Sen. 124,900 : Cost 4.43207026 * 330,466 @ 690 after 10,107,470 : Time 175.80s : 1879.81 words/s : L.r. 3.0000e-04
[2021-06-01 06:08:33] Ep. 3 : Up. 15000 : Sen. 145,669 : Cost 4.47314453 * 329,349 @ 504 after 10,436,819 : Time 175.79s : 1873.49 words/s : L.r. 3.0000e-04
[2021-06-01 06:08:33] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 06:08:34] Saving model weights and runtime parameters to model.transformer.my-en/model.iter15000.npz
[2021-06-01 06:08:34] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 06:08:36] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x555c6fc9a000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x555cafc9a000 @ 
tcmalloc: large alloc 1476395008 bytes == 0x555c6fc9a000 @ 
tcmalloc: large alloc 1610612736 bytes == 0x555c6fc9a000 @ 
tcmalloc: large alloc 1744830464 bytes == 0x555c6fc9a000 @ 
tcmalloc: large alloc 2013265920 bytes == 0x555cbfc9a000 @ 
tcmalloc: large alloc 2281701376 bytes == 0x555dc3914000 @ 
[2021-06-01 06:08:51] Error: CUDA error 2 'out of memory' - /home/ye/tool/marian/src/tensors/gpu/device.cu:32: cudaMalloc(&data_, size)
[2021-06-01 06:08:51] Error: Aborted from virtual void marian::gpu::Device::reserve(size_t) in /home/ye/tool/marian/src/tensors/gpu/device.cu:32

[CALL STACK]
[0x555c3003f880]    marian::gpu::Device::  reserve  (unsigned long)    + 0xf80
[0x555c2f96f7df]    marian::TensorAllocator::  allocate  (IntrusivePtr<marian::TensorBase>&,  marian::Shape,  marian::Type) + 0x4ef
[0x555c2fb7bb00]    marian::Node::  allocate  ()                       + 0x1e0
[0x555c2fb722ce]    marian::ExpressionGraph::  forward  (std::__cxx11::list<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>,std::allocator<IntrusivePtr<marian::Chainable<IntrusivePtr<marian::TensorBase>>>>>&,  bool) + 0x8e
[0x555c2fb73cae]    marian::ExpressionGraph::  forwardNext  ()         + 0x24e
[0x555c2fd44e64]                                                       + 0x77de64
[0x555c2fd45694]                                                       + 0x77e694
[0x555c2f91915d]    std::__future_base::_State_baseV2::  _M_do_set  (std::function<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> ()>*,  bool*) + 0x2d
[0x7f50b58fcc0f]                                                       + 0x11c0f
[0x555c2fd3c18a]                                                       + 0x77518a
[0x555c2f91b89a]    std::thread::_State_impl<std::thread::_Invoker<std::tuple<marian::ThreadPool::reserve(unsigned long)::{lambda()#1}>>>::  _M_run  () + 0x13a
[0x7f50b57e0d84]                                                       + 0xd6d84
[0x7f50b58f4590]                                                       + 0x9590
[0x7f50b54cf223]    clone                                              + 0x43


real	30m18.674s
user	44m49.157s
sys	0m8.263s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$
```

## Change Config and Train Again

```
    --mini-batch-fit -w 1000 --maxi-batch 32 \
        --valid-mini-batch 32 \
```

### The Script

```
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
```

batch size တွေကို 32 ထိ လျှော့ချပလိုက်တယ်။  
ဒီတစ်ခါတော့ အဆင်ပြေမယ်လို့ မျှော်လင့်...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./transformer.my-en.sh 
mkdir: cannot create directory ‘model.transformer.my-en’: File exists
[2021-06-01 07:21:33] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-01 07:21:33] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 12442 with command line:
[2021-06-01 07:21:33] [marian] marian -c model.transformer.my-en/config.yml
[2021-06-01 07:21:33] [config] after: 0e
[2021-06-01 07:21:33] [config] after-batches: 0
[2021-06-01 07:21:33] [config] after-epochs: 0
[2021-06-01 07:21:33] [config] all-caps-every: 0
[2021-06-01 07:21:33] [config] allow-unk: false
[2021-06-01 07:21:33] [config] authors: false
[2021-06-01 07:21:33] [config] beam-size: 6
[2021-06-01 07:21:33] [config] bert-class-symbol: "[CLS]"
[2021-06-01 07:21:33] [config] bert-mask-symbol: "[MASK]"
[2021-06-01 07:21:33] [config] bert-masking-fraction: 0.15
[2021-06-01 07:21:33] [config] bert-sep-symbol: "[SEP]"
[2021-06-01 07:21:33] [config] bert-train-type-embeddings: true
[2021-06-01 07:21:33] [config] bert-type-vocab-size: 2
[2021-06-01 07:21:33] [config] build-info: ""
[2021-06-01 07:21:33] [config] cite: false
[2021-06-01 07:21:33] [config] clip-norm: 5
[2021-06-01 07:21:33] [config] cost-scaling:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] cost-type: ce-sum
[2021-06-01 07:21:33] [config] cpu-threads: 0
[2021-06-01 07:21:33] [config] data-weighting: ""
[2021-06-01 07:21:33] [config] data-weighting-type: sentence
[2021-06-01 07:21:33] [config] dec-cell: gru
[2021-06-01 07:21:33] [config] dec-cell-base-depth: 2
[2021-06-01 07:21:33] [config] dec-cell-high-depth: 1
[2021-06-01 07:21:33] [config] dec-depth: 2
[2021-06-01 07:21:33] [config] devices:
[2021-06-01 07:21:33] [config]   - 0
[2021-06-01 07:21:33] [config]   - 1
[2021-06-01 07:21:33] [config] dim-emb: 512
[2021-06-01 07:21:33] [config] dim-rnn: 1024
[2021-06-01 07:21:33] [config] dim-vocabs:
[2021-06-01 07:21:33] [config]   - 12379
[2021-06-01 07:21:33] [config]   - 85602
[2021-06-01 07:21:33] [config] disp-first: 0
[2021-06-01 07:21:33] [config] disp-freq: 500
[2021-06-01 07:21:33] [config] disp-label-counts: true
[2021-06-01 07:21:33] [config] dropout-rnn: 0
[2021-06-01 07:21:33] [config] dropout-src: 0
[2021-06-01 07:21:33] [config] dropout-trg: 0
[2021-06-01 07:21:33] [config] dump-config: ""
[2021-06-01 07:21:33] [config] early-stopping: 10
[2021-06-01 07:21:33] [config] embedding-fix-src: false
[2021-06-01 07:21:33] [config] embedding-fix-trg: false
[2021-06-01 07:21:33] [config] embedding-normalization: false
[2021-06-01 07:21:33] [config] embedding-vectors:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] enc-cell: gru
[2021-06-01 07:21:33] [config] enc-cell-depth: 1
[2021-06-01 07:21:33] [config] enc-depth: 2
[2021-06-01 07:21:33] [config] enc-type: bidirectional
[2021-06-01 07:21:33] [config] english-title-case-every: 0
[2021-06-01 07:21:33] [config] exponential-smoothing: 0.0001
[2021-06-01 07:21:33] [config] factor-weight: 1
[2021-06-01 07:21:33] [config] grad-dropping-momentum: 0
[2021-06-01 07:21:33] [config] grad-dropping-rate: 0
[2021-06-01 07:21:33] [config] grad-dropping-warmup: 100
[2021-06-01 07:21:33] [config] gradient-checkpointing: false
[2021-06-01 07:21:33] [config] guided-alignment: none
[2021-06-01 07:21:33] [config] guided-alignment-cost: mse
[2021-06-01 07:21:33] [config] guided-alignment-weight: 0.1
[2021-06-01 07:21:33] [config] ignore-model-config: false
[2021-06-01 07:21:33] [config] input-types:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] interpolate-env-vars: false
[2021-06-01 07:21:33] [config] keep-best: false
[2021-06-01 07:21:33] [config] label-smoothing: 0.1
[2021-06-01 07:21:33] [config] layer-normalization: false
[2021-06-01 07:21:33] [config] learn-rate: 0.0003
[2021-06-01 07:21:33] [config] lemma-dim-emb: 0
[2021-06-01 07:21:33] [config] log: model.transformer.my-en/train.log
[2021-06-01 07:21:33] [config] log-level: info
[2021-06-01 07:21:33] [config] log-time-zone: ""
[2021-06-01 07:21:33] [config] logical-epoch:
[2021-06-01 07:21:33] [config]   - 1e
[2021-06-01 07:21:33] [config]   - 0
[2021-06-01 07:21:33] [config] lr-decay: 0
[2021-06-01 07:21:33] [config] lr-decay-freq: 50000
[2021-06-01 07:21:33] [config] lr-decay-inv-sqrt:
[2021-06-01 07:21:33] [config]   - 16000
[2021-06-01 07:21:33] [config] lr-decay-repeat-warmup: false
[2021-06-01 07:21:33] [config] lr-decay-reset-optimizer: false
[2021-06-01 07:21:33] [config] lr-decay-start:
[2021-06-01 07:21:33] [config]   - 10
[2021-06-01 07:21:33] [config]   - 1
[2021-06-01 07:21:33] [config] lr-decay-strategy: epoch+stalled
[2021-06-01 07:21:33] [config] lr-report: true
[2021-06-01 07:21:33] [config] lr-warmup: 0
[2021-06-01 07:21:33] [config] lr-warmup-at-reload: false
[2021-06-01 07:21:33] [config] lr-warmup-cycle: false
[2021-06-01 07:21:33] [config] lr-warmup-start-rate: 0
[2021-06-01 07:21:33] [config] max-length: 200
[2021-06-01 07:21:33] [config] max-length-crop: false
[2021-06-01 07:21:33] [config] max-length-factor: 3
[2021-06-01 07:21:33] [config] maxi-batch: 32
[2021-06-01 07:21:33] [config] maxi-batch-sort: trg
[2021-06-01 07:21:33] [config] mini-batch: 64
[2021-06-01 07:21:33] [config] mini-batch-fit: true
[2021-06-01 07:21:33] [config] mini-batch-fit-step: 10
[2021-06-01 07:21:33] [config] mini-batch-track-lr: false
[2021-06-01 07:21:33] [config] mini-batch-warmup: 0
[2021-06-01 07:21:33] [config] mini-batch-words: 0
[2021-06-01 07:21:33] [config] mini-batch-words-ref: 0
[2021-06-01 07:21:33] [config] model: model.transformer.my-en/model.npz
[2021-06-01 07:21:33] [config] multi-loss-type: sum
[2021-06-01 07:21:33] [config] multi-node: false
[2021-06-01 07:21:33] [config] multi-node-overlap: true
[2021-06-01 07:21:33] [config] n-best: false
[2021-06-01 07:21:33] [config] no-nccl: false
[2021-06-01 07:21:33] [config] no-reload: false
[2021-06-01 07:21:33] [config] no-restore-corpus: false
[2021-06-01 07:21:33] [config] normalize: 0.6
[2021-06-01 07:21:33] [config] normalize-gradient: false
[2021-06-01 07:21:33] [config] num-devices: 0
[2021-06-01 07:21:33] [config] optimizer: adam
[2021-06-01 07:21:33] [config] optimizer-delay: 1
[2021-06-01 07:21:33] [config] optimizer-params:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] output-omit-bias: false
[2021-06-01 07:21:33] [config] overwrite: false
[2021-06-01 07:21:33] [config] precision:
[2021-06-01 07:21:33] [config]   - float32
[2021-06-01 07:21:33] [config]   - float32
[2021-06-01 07:21:33] [config]   - float32
[2021-06-01 07:21:33] [config] pretrained-model: ""
[2021-06-01 07:21:33] [config] quantize-biases: false
[2021-06-01 07:21:33] [config] quantize-bits: 0
[2021-06-01 07:21:33] [config] quantize-log-based: false
[2021-06-01 07:21:33] [config] quantize-optimization-steps: 0
[2021-06-01 07:21:33] [config] quiet: false
[2021-06-01 07:21:33] [config] quiet-translation: true
[2021-06-01 07:21:33] [config] relative-paths: false
[2021-06-01 07:21:33] [config] right-left: false
[2021-06-01 07:21:33] [config] save-freq: 5000
[2021-06-01 07:21:33] [config] seed: 1111
[2021-06-01 07:21:33] [config] sentencepiece-alphas:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] sentencepiece-max-lines: 2000000
[2021-06-01 07:21:33] [config] sentencepiece-options: ""
[2021-06-01 07:21:33] [config] shuffle: data
[2021-06-01 07:21:33] [config] shuffle-in-ram: false
[2021-06-01 07:21:33] [config] sigterm: save-and-exit
[2021-06-01 07:21:33] [config] skip: false
[2021-06-01 07:21:33] [config] sqlite: ""
[2021-06-01 07:21:33] [config] sqlite-drop: false
[2021-06-01 07:21:33] [config] sync-sgd: true
[2021-06-01 07:21:33] [config] tempdir: /tmp
[2021-06-01 07:21:33] [config] tied-embeddings: true
[2021-06-01 07:21:33] [config] tied-embeddings-all: false
[2021-06-01 07:21:33] [config] tied-embeddings-src: false
[2021-06-01 07:21:33] [config] train-embedder-rank:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] train-sets:
[2021-06-01 07:21:33] [config]   - data/train.my
[2021-06-01 07:21:33] [config]   - data/train.en
[2021-06-01 07:21:33] [config] transformer-aan-activation: swish
[2021-06-01 07:21:33] [config] transformer-aan-depth: 2
[2021-06-01 07:21:33] [config] transformer-aan-nogate: false
[2021-06-01 07:21:33] [config] transformer-decoder-autoreg: self-attention
[2021-06-01 07:21:33] [config] transformer-depth-scaling: false
[2021-06-01 07:21:33] [config] transformer-dim-aan: 2048
[2021-06-01 07:21:33] [config] transformer-dim-ffn: 2048
[2021-06-01 07:21:33] [config] transformer-dropout: 0.3
[2021-06-01 07:21:33] [config] transformer-dropout-attention: 0
[2021-06-01 07:21:33] [config] transformer-dropout-ffn: 0
[2021-06-01 07:21:33] [config] transformer-ffn-activation: swish
[2021-06-01 07:21:33] [config] transformer-ffn-depth: 2
[2021-06-01 07:21:33] [config] transformer-guided-alignment-layer: last
[2021-06-01 07:21:33] [config] transformer-heads: 8
[2021-06-01 07:21:33] [config] transformer-no-projection: false
[2021-06-01 07:21:33] [config] transformer-pool: false
[2021-06-01 07:21:33] [config] transformer-postprocess: dan
[2021-06-01 07:21:33] [config] transformer-postprocess-emb: d
[2021-06-01 07:21:33] [config] transformer-postprocess-top: ""
[2021-06-01 07:21:33] [config] transformer-preprocess: ""
[2021-06-01 07:21:33] [config] transformer-tied-layers:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] transformer-train-position-embeddings: false
[2021-06-01 07:21:33] [config] tsv: false
[2021-06-01 07:21:33] [config] tsv-fields: 0
[2021-06-01 07:21:33] [config] type: transformer
[2021-06-01 07:21:33] [config] ulr: false
[2021-06-01 07:21:33] [config] ulr-dim-emb: 0
[2021-06-01 07:21:33] [config] ulr-dropout: 0
[2021-06-01 07:21:33] [config] ulr-keys-vectors: ""
[2021-06-01 07:21:33] [config] ulr-query-vectors: ""
[2021-06-01 07:21:33] [config] ulr-softmax-temperature: 1
[2021-06-01 07:21:33] [config] ulr-trainable-transformation: false
[2021-06-01 07:21:33] [config] unlikelihood-loss: false
[2021-06-01 07:21:33] [config] valid-freq: 5000
[2021-06-01 07:21:33] [config] valid-log: model.transformer.my-en/valid.log
[2021-06-01 07:21:33] [config] valid-max-length: 1000
[2021-06-01 07:21:33] [config] valid-metrics:
[2021-06-01 07:21:33] [config]   - cross-entropy
[2021-06-01 07:21:33] [config]   - perplexity
[2021-06-01 07:21:33] [config]   - bleu
[2021-06-01 07:21:33] [config] valid-mini-batch: 32
[2021-06-01 07:21:33] [config] valid-reset-stalled: false
[2021-06-01 07:21:33] [config] valid-script-args:
[2021-06-01 07:21:33] [config]   []
[2021-06-01 07:21:33] [config] valid-script-path: ""
[2021-06-01 07:21:33] [config] valid-sets:
[2021-06-01 07:21:33] [config]   - data/valid.my
[2021-06-01 07:21:33] [config]   - data/valid.en
[2021-06-01 07:21:33] [config] valid-translation-output: data/valid.my-en.output
[2021-06-01 07:21:33] [config] version: v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-01 07:21:33] [config] vocabs:
[2021-06-01 07:21:33] [config]   - data/vocab/vocab.my.yml
[2021-06-01 07:21:33] [config]   - data/vocab/vocab.en.yml
[2021-06-01 07:21:33] [config] word-penalty: 0
[2021-06-01 07:21:33] [config] word-scores: false
[2021-06-01 07:21:33] [config] workspace: 1000
[2021-06-01 07:21:33] [config] Loaded model has been created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-01 07:21:33] Using synchronous SGD
[2021-06-01 07:21:33] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.my.yml
[2021-06-01 07:21:33] [data] Setting vocabulary size for input 0 to 12,379
[2021-06-01 07:21:33] [data] Loading vocabulary from JSON/Yaml file data/vocab/vocab.en.yml
[2021-06-01 07:21:33] [data] Setting vocabulary size for input 1 to 85,602
[2021-06-01 07:21:33] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-06-01 07:21:33] [batching] Collecting statistics for batch fitting with step size 10
[2021-06-01 07:21:33] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-06-01 07:21:33] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-06-01 07:21:34] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-01 07:21:34] [comm] NCCLCommunicator constructed successfully
[2021-06-01 07:21:34] [training] Using 2 GPUs
[2021-06-01 07:21:34] [logits] Applying loss function for 1 factor(s)
[2021-06-01 07:21:34] [memory] Reserving 247 MB, device gpu0
[2021-06-01 07:21:34] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-06-01 07:21:34] [memory] Reserving 247 MB, device gpu0
[2021-06-01 07:21:55] [batching] Done. Typical MB size is 1,943 target words
[2021-06-01 07:21:55] [memory] Extending reserved space to 1024 MB (device gpu0)
[2021-06-01 07:21:55] [memory] Extending reserved space to 1024 MB (device gpu1)
[2021-06-01 07:21:55] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-01 07:21:55] [comm] NCCLCommunicator constructed successfully
[2021-06-01 07:21:55] [training] Using 2 GPUs
[2021-06-01 07:21:55] Loading model from model.transformer.my-en/model.npz.orig.npz
[2021-06-01 07:21:55] Loading model from model.transformer.my-en/model.npz.orig.npz
[2021-06-01 07:21:55] Loading Adam parameters from model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 07:21:56] [memory] Reserving 247 MB, device gpu0
[2021-06-01 07:21:56] [memory] Reserving 247 MB, device gpu1
[2021-06-01 07:21:56] [training] Model reloaded from model.transformer.my-en/model.npz
[2021-06-01 07:21:56] [data] Restoring the corpus state to epoch 3, batch 15000
[2021-06-01 07:21:56] [data] Shuffling data
[2021-06-01 07:21:56] [data] Done reading 256,102 sentences
[2021-06-01 07:21:57] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 07:21:58] Training started
[2021-06-01 07:21:58] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-06-01 07:21:58] [memory] Reserving 247 MB, device gpu0
[2021-06-01 07:21:58] [memory] Reserving 247 MB, device gpu1
[2021-06-01 07:21:58] [memory] Reserving 247 MB, device gpu0
[2021-06-01 07:21:59] [memory] Reserving 247 MB, device gpu1
[2021-06-01 07:21:59] Loading model from model.transformer.my-en/model.npz
[2021-06-01 07:21:59] [memory] Reserving 247 MB, device cpu0
[2021-06-01 07:21:59] [memory] Reserving 123 MB, device gpu0
[2021-06-01 07:21:59] [memory] Reserving 123 MB, device gpu1
[2021-06-01 07:24:53] Ep. 3 : Up. 15500 : Sen. 165,243 : Cost 4.19193411 * 304,329 @ 617 after 10,741,148 : Time 178.32s : 1706.66 words/s : L.r. 3.0000e-04
[2021-06-01 07:27:48] Ep. 3 : Up. 16000 : Sen. 184,997 : Cost 4.39025354 * 306,189 @ 634 after 11,047,337 : Time 175.31s : 1746.56 words/s : L.r. 3.0000e-04
[2021-06-01 07:30:45] Ep. 3 : Up. 16500 : Sen. 204,599 : Cost 4.37152433 * 306,091 @ 481 after 11,353,428 : Time 177.17s : 1727.68 words/s : L.r. 2.9542e-04
[2021-06-01 07:33:39] Ep. 3 : Up. 17000 : Sen. 224,055 : Cost 4.37795019 * 305,764 @ 499 after 11,659,192 : Time 173.52s : 1762.10 words/s : L.r. 2.9104e-04
[2021-06-01 07:36:33] Ep. 3 : Up. 17500 : Sen. 243,506 : Cost 4.37382412 * 305,462 @ 630 after 11,964,654 : Time 174.07s : 1754.81 words/s : L.r. 2.8685e-04
[2021-06-01 07:39:28] Ep. 3 : Up. 18000 : Sen. 263,205 : Cost 4.35803318 * 304,206 @ 671 after 12,268,860 : Time 174.83s : 1740.00 words/s : L.r. 2.8284e-04
[2021-06-01 07:40:21] Seen 269059 samples
[2021-06-01 07:40:21] Starting data epoch 4 in logical epoch 4
[2021-06-01 07:40:21] [data] Shuffling data
[2021-06-01 07:40:21] [data] Done reading 256,102 sentences
[2021-06-01 07:40:22] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 07:42:24] Ep. 4 : Up. 18500 : Sen. 13,780 : Cost 4.23477793 * 302,142 @ 631 after 12,571,002 : Time 176.13s : 1715.46 words/s : L.r. 2.7899e-04
[2021-06-01 07:45:22] Ep. 4 : Up. 19000 : Sen. 33,129 : Cost 4.19848490 * 302,643 @ 609 after 12,873,645 : Time 177.82s : 1701.98 words/s : L.r. 2.7530e-04
[2021-06-01 07:48:16] Ep. 4 : Up. 19500 : Sen. 52,677 : Cost 4.18420792 * 301,942 @ 570 after 13,175,587 : Time 174.75s : 1727.86 words/s : L.r. 2.7175e-04
[2021-06-01 07:51:10] Ep. 4 : Up. 20000 : Sen. 72,356 : Cost 4.20036602 * 307,103 @ 529 after 13,482,690 : Time 173.74s : 1767.64 words/s : L.r. 2.6833e-04
[2021-06-01 07:51:10] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 07:51:11] Saving model weights and runtime parameters to model.transformer.my-en/model.iter20000.npz
[2021-06-01 07:51:12] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 07:51:13] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
tcmalloc: large alloc 1073741824 bytes == 0x558565d82000 @ 
tcmalloc: large alloc 1207959552 bytes == 0x558565d82000 @ 
[2021-06-01 07:51:20] [valid] Ep. 4 : Up. 20000 : cross-entropy : 135.333 : new best
[2021-06-01 07:51:23] [valid] Ep. 4 : Up. 20000 : perplexity : 118.992 : new best
[2021-06-01 07:51:31] [valid] [valid] First sentence's tokens as scored:
[2021-06-01 07:51:31] [valid] DefaultVocab keeps original segments for scoring
[2021-06-01 07:51:31] [valid] [valid]   Hyp: The report was formed with the United States government , the United States government , the United States and the United States bank of the United States , the United States , the United States and the European bank of the United States .
[2021-06-01 07:51:31] [valid] [valid]   Ref: The damages report was prepared by the Haitian Government with the support of the Economic Commission for Latin America and the Caribbean , the Interamerican Development Bank , the World Bank , the United Nations and the European Union .
[2021-06-01 07:53:45] [valid] Ep. 4 : Up. 20000 : bleu : 3.10917 : new best
[2021-06-01 07:56:41] Ep. 4 : Up. 20500 : Sen. 91,943 : Cost 4.18459845 * 304,200 @ 954 after 13,786,890 : Time 331.09s : 918.78 words/s : L.r. 2.6504e-04
[2021-06-01 07:59:33] Ep. 4 : Up. 21000 : Sen. 111,266 : Cost 4.18443012 * 302,722 @ 636 after 14,089,612 : Time 171.93s : 1760.71 words/s : L.r. 2.6186e-04
[2021-06-01 08:02:26] Ep. 4 : Up. 21500 : Sen. 130,822 : Cost 4.17599821 * 304,273 @ 624 after 14,393,885 : Time 172.59s : 1763.03 words/s : L.r. 2.5880e-04
[2021-06-01 08:05:18] Ep. 4 : Up. 22000 : Sen. 150,247 : Cost 4.15385008 * 302,904 @ 832 after 14,696,789 : Time 171.93s : 1761.82 words/s : L.r. 2.5584e-04
[2021-06-01 08:08:09] Ep. 4 : Up. 22500 : Sen. 169,502 : Cost 4.16509533 * 300,281 @ 598 after 14,997,070 : Time 171.69s : 1748.97 words/s : L.r. 2.5298e-04
[2021-06-01 08:11:03] Ep. 4 : Up. 23000 : Sen. 188,801 : Cost 4.16001797 * 302,739 @ 431 after 15,299,809 : Time 173.09s : 1749.03 words/s : L.r. 2.5022e-04
[2021-06-01 08:13:56] Ep. 4 : Up. 23500 : Sen. 208,282 : Cost 4.14078522 * 305,690 @ 570 after 15,605,499 : Time 173.28s : 1764.09 words/s : L.r. 2.4754e-04
[2021-06-01 08:16:49] Ep. 4 : Up. 24000 : Sen. 227,889 : Cost 4.13753271 * 305,296 @ 506 after 15,910,795 : Time 173.20s : 1762.65 words/s : L.r. 2.4495e-04
[2021-06-01 08:19:41] Ep. 4 : Up. 24500 : Sen. 247,273 : Cost 4.15144777 * 302,969 @ 574 after 16,213,764 : Time 172.25s : 1758.89 words/s : L.r. 2.4244e-04
[2021-06-01 08:20:56] Seen 255710 samples
[2021-06-01 08:20:56] Starting data epoch 5 in logical epoch 5
[2021-06-01 08:20:56] [data] Shuffling data
[2021-06-01 08:20:56] [data] Done reading 256,102 sentences
[2021-06-01 08:20:56] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 08:22:36] Ep. 5 : Up. 25000 : Sen. 11,431 : Cost 4.02139902 * 309,116 @ 568 after 16,522,880 : Time 174.33s : 1773.15 words/s : L.r. 2.4000e-04
[2021-06-01 08:22:36] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 08:22:37] Saving model weights and runtime parameters to model.transformer.my-en/model.iter25000.npz
[2021-06-01 08:22:37] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 08:22:38] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 08:22:43] [valid] Ep. 5 : Up. 25000 : cross-entropy : 130.782 : new best
[2021-06-01 08:22:46] [valid] Ep. 5 : Up. 25000 : perplexity : 101.324 : new best
[2021-06-01 08:24:37] [valid] Ep. 5 : Up. 25000 : bleu : 4.37733 : new best
[2021-06-01 08:27:30] Ep. 5 : Up. 25500 : Sen. 31,161 : Cost 3.95188642 * 305,220 @ 550 after 16,828,100 : Time 294.55s : 1036.21 words/s : L.r. 2.3764e-04
[2021-06-01 08:30:22] Ep. 5 : Up. 26000 : Sen. 50,468 : Cost 3.97174811 * 302,989 @ 575 after 17,131,089 : Time 171.79s : 1763.71 words/s : L.r. 2.3534e-04
[2021-06-01 08:33:15] Ep. 5 : Up. 26500 : Sen. 70,235 : Cost 3.96314669 * 304,580 @ 832 after 17,435,669 : Time 172.67s : 1763.97 words/s : L.r. 2.3311e-04
[2021-06-01 08:36:07] Ep. 5 : Up. 27000 : Sen. 89,637 : Cost 3.96810269 * 304,105 @ 594 after 17,739,774 : Time 172.39s : 1764.10 words/s : L.r. 2.3094e-04
...
...
...
[2021-06-01 09:24:16] [valid] Ep. 6 : Up. 35000 : cross-entropy : 124.917 : new best
[2021-06-01 09:24:19] [valid] Ep. 6 : Up. 35000 : perplexity : 82.3708 : new best
[2021-06-01 09:25:16] [valid] Ep. 6 : Up. 35000 : bleu : 5.62772 : new best
[2021-06-01 09:28:09] Ep. 6 : Up. 35500 : Sen. 164,255 : Cost 3.81961203 * 306,389 @ 704 after 22,886,940 : Time 240.64s : 1273.20 words/s : L.r. 2.0140e-04
[2021-06-01 09:31:02] Ep. 6 : Up. 36000 : Sen. 183,750 : Cost 3.81997252 * 304,439 @ 665 after 23,191,379 : Time 172.45s : 1765.36 words/s : L.r. 2.0000e-04
[2021-06-01 09:33:53] Ep. 6 : Up. 36500 : Sen. 203,167 : Cost 3.80765009 * 300,945 @ 564 after 23,492,324 : Time 171.51s : 1754.69 words/s : L.r. 1.9863e-04
[2021-06-01 09:36:46] Ep. 6 : Up. 37000 : Sen. 222,821 : Cost 3.81117868 * 305,198 @ 560 after 23,797,522 : Time 172.29s : 1771.43 words/s : L.r. 1.9728e-04
[2021-06-01 09:39:39] Ep. 6 : Up. 37500 : Sen. 242,382 : Cost 3.81685638 * 308,299 @ 667 after 24,105,821 : Time 173.06s : 1781.46 words/s : L.r. 1.9596e-04
[2021-06-01 09:41:36] Seen 255710 samples
[2021-06-01 09:41:36] Starting data epoch 7 in logical epoch 7
[2021-06-01 09:41:36] [data] Shuffling data
[2021-06-01 09:41:36] [data] Done reading 256,102 sentences
[2021-06-01 09:41:37] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 09:42:31] Ep. 7 : Up. 38000 : Sen. 6,117 : Cost 3.76492810 * 303,305 @ 621 after 24,409,126 : Time 172.82s : 1755.00 words/s : L.r. 1.9467e-04
[2021-06-01 09:45:24] Ep. 7 : Up. 38500 : Sen. 25,686 : Cost 3.65921068 * 304,810 @ 563 after 24,713,936 : Time 172.69s : 1765.06 words/s : L.r. 1.9340e-04
[2021-06-01 09:48:16] Ep. 7 : Up. 39000 : Sen. 45,458 : Cost 3.64582658 * 304,114 @ 601 after 25,018,050 : Time 172.01s : 1767.98 words/s : L.r. 1.9215e-04
[2021-06-01 09:51:08] Ep. 7 : Up. 39500 : Sen. 65,154 : Cost 3.67241192 * 304,895 @ 595 after 25,322,945 : Time 172.30s : 1769.57 words/s : L.r. 1.9093e-04
[2021-06-01 09:54:01] Ep. 7 : Up. 40000 : Sen. 84,932 : Cost 3.66280437 * 304,640 @ 490 after 25,627,585 : Time 172.30s : 1768.08 words/s : L.r. 1.8974e-04
[2021-06-01 09:54:01] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 09:54:02] Saving model weights and runtime parameters to model.transformer.my-en/model.iter40000.npz
[2021-06-01 09:54:02] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 09:54:04] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 09:54:08] [valid] Ep. 7 : Up. 40000 : cross-entropy : 122.801 : new best
[2021-06-01 09:54:11] [valid] Ep. 7 : Up. 40000 : perplexity : 76.44 : new best
[2021-06-01 09:54:49] [valid] Ep. 7 : Up. 40000 : bleu : 5.93018 : new best
...
...
...
[2021-06-01 10:45:05] Ep. 8 : Up. 48500 : Sen. 159,552 : Cost 3.60172176 * 303,309 @ 722 after 30,781,164 : Time 173.40s : 1749.16 words/s : L.r. 1.7231e-04
[2021-06-01 10:48:03] Ep. 8 : Up. 49000 : Sen. 179,154 : Cost 3.59910941 * 302,166 @ 467 after 31,083,330 : Time 177.45s : 1702.87 words/s : L.r. 1.7143e-04
[2021-06-01 10:51:03] Ep. 8 : Up. 49500 : Sen. 198,510 : Cost 3.59652400 * 303,079 @ 557 after 31,386,409 : Time 180.03s : 1683.53 words/s : L.r. 1.7056e-04
[2021-06-01 10:53:59] Ep. 8 : Up. 50000 : Sen. 218,249 : Cost 3.61629748 * 307,856 @ 636 after 31,694,265 : Time 176.30s : 1746.18 words/s : L.r. 1.6971e-04
[2021-06-01 10:53:59] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 10:54:00] Saving model weights and runtime parameters to model.transformer.my-en/model.iter50000.npz
[2021-06-01 10:54:01] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 10:54:02] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 10:54:07] [valid] Ep. 8 : Up. 50000 : cross-entropy : 119.98 : new best
[2021-06-01 10:54:10] [valid] Ep. 8 : Up. 50000 : perplexity : 69.1906 : new best
[2021-06-01 10:54:53] [valid] Ep. 8 : Up. 50000 : bleu : 6.39523 : new best
...
...
...
[2021-06-01 11:24:02] Ep. 9 : Up. 55000 : Sen. 158,063 : Cost 3.51430845 * 305,284 @ 616 after 34,742,083 : Time 174.57s : 1748.78 words/s : L.r. 1.6181e-04
[2021-06-01 11:24:02] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 11:24:04] Saving model weights and runtime parameters to model.transformer.my-en/model.iter55000.npz
[2021-06-01 11:24:04] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 11:24:05] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 11:24:10] [valid] Ep. 9 : Up. 55000 : cross-entropy : 118.933 : new best
[2021-06-01 11:24:13] [valid] Ep. 9 : Up. 55000 : perplexity : 66.6808 : new best
[2021-06-01 11:24:54] [valid] Ep. 9 : Up. 55000 : bleu : 6.80771 : new best
...
...
...
[2021-06-01 12:57:34] Starting data epoch 12 in logical epoch 12
[2021-06-01 12:57:34] [data] Shuffling data
[2021-06-01 12:57:34] [data] Done reading 256,102 sentences
[2021-06-01 12:57:35] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 12:59:41] Ep. 12 : Up. 71000 : Sen. 13,962 : Cost 3.30259132 * 299,562 @ 770 after 44,452,784 : Time 172.79s : 1733.69 words/s : L.r. 1.4241e-04
[2021-06-01 13:02:34] Ep. 12 : Up. 71500 : Sen. 33,422 : Cost 3.27269435 * 303,292 @ 840 after 44,756,076 : Time 172.26s : 1760.65 words/s : L.r. 1.4191e-04
[2021-06-01 13:05:26] Ep. 12 : Up. 72000 : Sen. 52,868 : Cost 3.28478718 * 304,127 @ 666 after 45,060,203 : Time 172.78s : 1760.19 words/s : L.r. 1.4142e-04
[2021-06-01 13:08:19] Ep. 12 : Up. 72500 : Sen. 72,773 : Cost 3.28850985 * 304,691 @ 640 after 45,364,894 : Time 172.71s : 1764.14 words/s : L.r. 1.4093e-04
[2021-06-01 13:11:12] Ep. 12 : Up. 73000 : Sen. 92,615 : Cost 3.29167962 * 305,890 @ 840 after 45,670,784 : Time 172.64s : 1771.84 words/s : L.r. 1.4045e-04
[2021-06-01 13:14:03] Ep. 12 : Up. 73500 : Sen. 111,603 : Cost 3.33659482 * 299,891 @ 660 after 45,970,675 : Time 171.57s : 1747.88 words/s : L.r. 1.3997e-04
[2021-06-01 13:16:55] Ep. 12 : Up. 74000 : Sen. 131,038 : Cost 3.30743694 * 301,986 @ 501 after 46,272,661 : Time 171.66s : 1759.18 words/s : L.r. 1.3950e-04
[2021-06-01 13:19:47] Ep. 12 : Up. 74500 : Sen. 150,474 : Cost 3.32488298 * 304,074 @ 730 after 46,576,735 : Time 172.16s : 1766.24 words/s : L.r. 1.3903e-04
[2021-06-01 13:22:39] Ep. 12 : Up. 75000 : Sen. 169,557 : Cost 3.33701992 * 299,879 @ 555 after 46,876,614 : Time 171.68s : 1746.72 words/s : L.r. 1.3856e-04
[2021-06-01 13:22:39] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 13:22:40] Saving model weights and runtime parameters to model.transformer.my-en/model.iter75000.npz
[2021-06-01 13:22:40] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 13:22:42] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 13:22:46] [valid] Ep. 12 : Up. 75000 : cross-entropy : 116.077 : new best
[2021-06-01 13:22:49] [valid] Ep. 12 : Up. 75000 : perplexity : 60.2842 : new best
[2021-06-01 13:23:19] [valid] Ep. 12 : Up. 75000 : bleu : 7.27545 : new best
...
...
...
[2021-06-01 15:21:09] Ep. 15 : Up. 95000 : Sen. 180,640 : Cost 3.21399689 * 302,954 @ 586 after 58,999,749 : Time 173.55s : 1745.64 words/s : L.r. 1.2312e-04
[2021-06-01 15:21:09] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 15:21:10] Saving model weights and runtime parameters to model.transformer.my-en/model.iter95000.npz
[2021-06-01 15:21:11] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 15:21:12] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 15:21:17] [valid] Ep. 15 : Up. 95000 : cross-entropy : 114.937 : new best
[2021-06-01 15:21:20] [valid] Ep. 15 : Up. 95000 : perplexity : 57.9041 : new best
[2021-06-01 15:21:50] [valid] Ep. 15 : Up. 95000 : bleu : 7.85909 : new best
...
...
...
[2021-06-01 15:50:47] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 15:50:48] Saving model weights and runtime parameters to model.transformer.my-en/model.iter100000.npz
[2021-06-01 15:50:49] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 15:50:50] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 15:50:55] [valid] Ep. 16 : Up. 100000 : cross-entropy : 114.793 : new best
[2021-06-01 15:50:58] [valid] Ep. 16 : Up. 100000 : perplexity : 57.6106 : new best
[2021-06-01 15:51:29] [valid] Ep. 16 : Up. 100000 : bleu : 7.64786 : stalled 1 times (last best: 7.85909)
...
...
...
[2021-06-01 19:19:27] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 19:19:29] Saving model weights and runtime parameters to model.transformer.my-en/model.iter135000.npz
[2021-06-01 19:19:29] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 19:19:30] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 19:19:35] [valid] Ep. 21 : Up. 135000 : cross-entropy : 114.042 : stalled 1 times (last best: 114.015)
[2021-06-01 19:19:38] [valid] Ep. 21 : Up. 135000 : perplexity : 56.1023 : stalled 1 times (last best: 56.0487)
[2021-06-01 19:20:06] [valid] Ep. 21 : Up. 135000 : bleu : 8.18453 : stalled 1 times (last best: 8.42307)
...
...
...
[2021-06-01 22:03:59] [data] Shuffling data
[2021-06-01 22:03:59] [data] Done reading 256,102 sentences
[2021-06-01 22:04:00] [data] Done shuffling 256,102 sentences to temp files
[2021-06-01 22:06:07] Ep. 26 : Up. 163000 : Sen. 14,346 : Cost 2.90539026 * 302,358 @ 524 after 100,232,302 : Time 173.82s : 1739.54 words/s : L.r. 9.3991e-05
[2021-06-01 22:09:01] Ep. 26 : Up. 163500 : Sen. 34,027 : Cost 2.87863183 * 304,008 @ 468 after 100,536,310 : Time 174.34s : 1743.81 words/s : L.r. 9.3847e-05
[2021-06-01 22:11:54] Ep. 26 : Up. 164000 : Sen. 53,248 : Cost 2.89634967 * 300,733 @ 580 after 100,837,043 : Time 173.10s : 1737.30 words/s : L.r. 9.3704e-05
[2021-06-01 22:14:47] Ep. 26 : Up. 164500 : Sen. 72,514 : Cost 2.91181207 * 300,119 @ 517 after 101,137,162 : Time 172.78s : 1737.02 words/s : L.r. 9.3562e-05
[2021-06-01 22:17:41] Ep. 26 : Up. 165000 : Sen. 91,712 : Cost 2.92933083 * 302,560 @ 597 after 101,439,722 : Time 174.46s : 1734.28 words/s : L.r. 9.3420e-05
[2021-06-01 22:17:41] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-01 22:17:43] Saving model weights and runtime parameters to model.transformer.my-en/model.iter165000.npz
[2021-06-01 22:17:43] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-01 22:17:44] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-01 22:17:49] [valid] Ep. 26 : Up. 165000 : cross-entropy : 113.87 : new best
[2021-06-01 22:17:52] [valid] Ep. 26 : Up. 165000 : perplexity : 55.7641 : new best
[2021-06-01 22:18:22] [valid] Ep. 26 : Up. 165000 : bleu : 8.58722 : new best
...
...
...
[2021-06-02 03:14:40] Starting data epoch 34 in logical epoch 34
[2021-06-02 03:14:40] [data] Shuffling data
[2021-06-02 03:14:40] [data] Done reading 256,102 sentences
[2021-06-02 03:14:41] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 03:16:23] Ep. 34 : Up. 215500 : Sen. 11,534 : Cost 2.81945920 * 302,561 @ 421 after 132,061,965 : Time 212.08s : 1426.63 words/s : L.r. 8.1744e-05
[2021-06-02 03:19:16] Ep. 34 : Up. 216000 : Sen. 30,994 : Cost 2.78641295 * 303,895 @ 555 after 132,365,860 : Time 172.93s : 1757.33 words/s : L.r. 8.1650e-05
[2021-06-02 03:22:09] Ep. 34 : Up. 216500 : Sen. 50,406 : Cost 2.79586387 * 302,709 @ 816 after 132,668,569 : Time 172.52s : 1754.68 words/s : L.r. 8.1555e-05
[2021-06-02 03:25:01] Ep. 34 : Up. 217000 : Sen. 69,728 : Cost 2.78990912 * 302,554 @ 601 after 132,971,123 : Time 172.55s : 1753.42 words/s : L.r. 8.1461e-05
[2021-06-02 03:27:53] Ep. 34 : Up. 217500 : Sen. 88,723 : Cost 2.82741141 * 300,758 @ 550 after 133,271,881 : Time 172.00s : 1748.62 words/s : L.r. 8.1368e-05
[2021-06-02 03:30:46] Ep. 34 : Up. 218000 : Sen. 108,349 : Cost 2.81032443 * 304,153 @ 576 after 133,576,034 : Time 173.03s : 1757.81 words/s : L.r. 8.1274e-05
[2021-06-02 03:33:38] Ep. 34 : Up. 218500 : Sen. 127,605 : Cost 2.83381057 * 301,927 @ 643 after 133,877,961 : Time 172.10s : 1754.38 words/s : L.r. 8.1181e-05
[2021-06-02 03:36:31] Ep. 34 : Up. 219000 : Sen. 147,164 : Cost 2.82746649 * 301,985 @ 632 after 134,179,946 : Time 172.74s : 1748.17 words/s : L.r. 8.1088e-05
[2021-06-02 03:39:25] Ep. 34 : Up. 219500 : Sen. 167,259 : Cost 2.82108831 * 309,792 @ 1,060 after 134,489,738 : Time 174.26s : 1777.78 words/s : L.r. 8.0996e-05
[2021-06-02 03:42:18] Ep. 34 : Up. 220000 : Sen. 186,587 : Cost 2.85335374 * 303,818 @ 880 after 134,793,556 : Time 172.66s : 1759.67 words/s : L.r. 8.0904e-05
[2021-06-02 03:42:18] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 03:42:19] Saving model weights and runtime parameters to model.transformer.my-en/model.iter220000.npz
[2021-06-02 03:42:20] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 03:42:21] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 03:42:26] [valid] Ep. 34 : Up. 220000 : cross-entropy : 113.747 : stalled 5 times (last best: 113.611)
[2021-06-02 03:42:29] [valid] Ep. 34 : Up. 220000 : perplexity : 55.5223 : stalled 5 times (last best: 55.2557)
[2021-06-02 03:42:56] [valid] Ep. 34 : Up. 220000 : bleu : 8.88467 : stalled 1 times (last best: 8.90264)
[2021-06-02 03:45:49] Ep. 34 : Up. 220500 : Sen. 206,525 : Cost 2.84872913 * 304,614 @ 556 after 135,098,170 : Time 211.49s : 1440.32 words/s : L.r. 8.0812e-05
[2021-06-02 03:48:42] Ep. 34 : Up. 221000 : Sen. 226,079 : Cost 2.88050437 * 304,162 @ 586 after 135,402,332 : Time 172.83s : 1759.94 words/s : L.r. 8.0721e-05
[2021-06-02 03:51:34] Ep. 34 : Up. 221500 : Sen. 245,294 : Cost 2.87304616 * 299,472 @ 613 after 135,701,804 : Time 171.76s : 1743.52 words/s : L.r. 8.0630e-05
[2021-06-02 03:53:07] Seen 255710 samples
[2021-06-02 03:53:07] Starting data epoch 35 in logical epoch 35
[2021-06-02 03:53:07] [data] Shuffling data
[2021-06-02 03:53:08] [data] Done reading 256,102 sentences
[2021-06-02 03:53:08] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 03:54:27] Ep. 35 : Up. 222000 : Sen. 9,126 : Cost 2.81930828 * 302,858 @ 504 after 136,004,662 : Time 173.44s : 1746.21 words/s : L.r. 8.0539e-05
[2021-06-02 03:57:21] Ep. 35 : Up. 222500 : Sen. 28,487 : Cost 2.77276826 * 303,029 @ 786 after 136,307,691 : Time 173.40s : 1747.61 words/s : L.r. 8.0448e-05
[2021-06-02 04:00:14] Ep. 35 : Up. 223000 : Sen. 47,845 : Cost 2.78101873 * 305,294 @ 680 after 136,612,985 : Time 173.42s : 1760.40 words/s : L.r. 8.0358e-05
[2021-06-02 04:03:07] Ep. 35 : Up. 223500 : Sen. 67,518 : Cost 2.78505635 * 305,480 @ 1,000 after 136,918,465 : Time 173.02s : 1765.58 words/s : L.r. 8.0268e-05
[2021-06-02 04:06:00] Ep. 35 : Up. 224000 : Sen. 87,040 : Cost 2.79937077 * 304,043 @ 559 after 137,222,508 : Time 172.90s : 1758.53 words/s : L.r. 8.0178e-05
[2021-06-02 04:08:53] Ep. 35 : Up. 224500 : Sen. 106,556 : Cost 2.80352187 * 304,788 @ 572 after 137,527,296 : Time 172.96s : 1762.16 words/s : L.r. 8.0089e-05
[2021-06-02 04:11:46] Ep. 35 : Up. 225000 : Sen. 126,094 : Cost 2.80978227 * 303,645 @ 589 after 137,830,941 : Time 173.16s : 1753.52 words/s : L.r. 8.0000e-05
[2021-06-02 04:11:46] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 04:11:48] Saving model weights and runtime parameters to model.transformer.my-en/model.iter225000.npz
[2021-06-02 04:11:48] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 04:11:49] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 04:11:54] [valid] Ep. 35 : Up. 225000 : cross-entropy : 113.749 : stalled 6 times (last best: 113.611)
[2021-06-02 04:11:57] [valid] Ep. 35 : Up. 225000 : perplexity : 55.5257 : stalled 6 times (last best: 55.2557)
[2021-06-02 04:12:25] [valid] Ep. 35 : Up. 225000 : bleu : 8.83653 : stalled 2 times (last best: 8.90264)
[2021-06-02 04:15:18] Ep. 35 : Up. 225500 : Sen. 145,783 : Cost 2.82404327 * 305,177 @ 708 after 138,136,118 : Time 212.03s : 1439.29 words/s : L.r. 7.9911e-05
[2021-06-02 04:18:11] Ep. 35 : Up. 226000 : Sen. 165,401 : Cost 2.82991433 * 303,976 @ 972 after 138,440,094 : Time 173.11s : 1755.97 words/s : L.r. 7.9823e-05
[2021-06-02 04:21:04] Ep. 35 : Up. 226500 : Sen. 184,590 : Cost 2.84895468 * 301,521 @ 544 after 138,741,615 : Time 172.38s : 1749.18 words/s : L.r. 7.9735e-05
[2021-06-02 04:23:57] Ep. 35 : Up. 227000 : Sen. 203,952 : Cost 2.84683394 * 303,383 @ 563 after 139,044,998 : Time 172.88s : 1754.90 words/s : L.r. 7.9647e-05
[2021-06-02 04:26:49] Ep. 35 : Up. 227500 : Sen. 223,232 : Cost 2.86219454 * 301,364 @ 577 after 139,346,362 : Time 172.43s : 1747.80 words/s : L.r. 7.9559e-05
[2021-06-02 04:29:42] Ep. 35 : Up. 228000 : Sen. 242,963 : Cost 2.84870791 * 303,883 @ 561 after 139,650,245 : Time 172.99s : 1756.70 words/s : L.r. 7.9472e-05
[2021-06-02 04:31:36] Seen 255710 samples
[2021-06-02 04:31:36] Starting data epoch 36 in logical epoch 36
[2021-06-02 04:31:36] [data] Shuffling data
[2021-06-02 04:31:37] [data] Done reading 256,102 sentences
[2021-06-02 04:31:37] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 04:32:35] Ep. 36 : Up. 228500 : Sen. 6,614 : Cost 2.81899309 * 302,311 @ 780 after 139,952,556 : Time 173.26s : 1744.82 words/s : L.r. 7.9385e-05
[2021-06-02 04:35:28] Ep. 36 : Up. 229000 : Sen. 26,074 : Cost 2.75719070 * 304,886 @ 781 after 140,257,442 : Time 172.96s : 1762.77 words/s : L.r. 7.9298e-05
[2021-06-02 04:38:20] Ep. 36 : Up. 229500 : Sen. 45,509 : Cost 2.76460147 * 299,839 @ 728 after 140,557,281 : Time 172.07s : 1742.52 words/s : L.r. 7.9212e-05
[2021-06-02 04:41:13] Ep. 36 : Up. 230000 : Sen. 64,852 : Cost 2.76915979 * 301,145 @ 676 after 140,858,426 : Time 172.46s : 1746.13 words/s : L.r. 7.9126e-05
[2021-06-02 04:41:13] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 04:41:14] Saving model weights and runtime parameters to model.transformer.my-en/model.iter230000.npz
[2021-06-02 04:41:15] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 04:41:16] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 04:41:21] [valid] Ep. 36 : Up. 230000 : cross-entropy : 113.641 : stalled 7 times (last best: 113.611)
[2021-06-02 04:41:24] [valid] Ep. 36 : Up. 230000 : perplexity : 55.3144 : stalled 7 times (last best: 55.2557)
[2021-06-02 04:41:53] [valid] Ep. 36 : Up. 230000 : bleu : 8.76784 : stalled 3 times (last best: 8.90264)
[2021-06-02 04:44:47] Ep. 36 : Up. 230500 : Sen. 84,406 : Cost 2.78501248 * 304,825 @ 508 after 141,163,251 : Time 214.08s : 1423.91 words/s : L.r. 7.9040e-05
[2021-06-02 04:47:40] Ep. 36 : Up. 231000 : Sen. 103,793 : Cost 2.79542875 * 302,458 @ 676 after 141,465,709 : Time 172.90s : 1749.36 words/s : L.r. 7.8954e-05
[2021-06-02 04:50:32] Ep. 36 : Up. 231500 : Sen. 123,138 : Cost 2.80830908 * 302,712 @ 630 after 141,768,421 : Time 172.52s : 1754.67 words/s : L.r. 7.8869e-05
[2021-06-02 04:53:25] Ep. 36 : Up. 232000 : Sen. 142,553 : Cost 2.81295300 * 301,774 @ 608 after 142,070,195 : Time 172.27s : 1751.70 words/s : L.r. 7.8784e-05
[2021-06-02 04:56:17] Ep. 36 : Up. 232500 : Sen. 161,826 : Cost 2.82137799 * 302,535 @ 585 after 142,372,730 : Time 172.22s : 1756.72 words/s : L.r. 7.8699e-05
[2021-06-02 04:59:09] Ep. 36 : Up. 233000 : Sen. 181,233 : Cost 2.82118964 * 302,494 @ 571 after 142,675,224 : Time 172.44s : 1754.23 words/s : L.r. 7.8615e-05
[2021-06-02 05:02:03] Ep. 36 : Up. 233500 : Sen. 200,912 : Cost 2.83106923 * 306,734 @ 599 after 142,981,958 : Time 173.60s : 1766.93 words/s : L.r. 7.8530e-05
[2021-06-02 05:04:56] Ep. 36 : Up. 234000 : Sen. 220,647 : Cost 2.85469341 * 306,112 @ 554 after 143,288,070 : Time 173.39s : 1765.45 words/s : L.r. 7.8446e-05
[2021-06-02 05:07:49] Ep. 36 : Up. 234500 : Sen. 239,867 : Cost 2.85903716 * 300,553 @ 664 after 143,588,623 : Time 172.42s : 1743.12 words/s : L.r. 7.8363e-05
[2021-06-02 05:10:09] Seen 255710 samples
[2021-06-02 05:10:09] Starting data epoch 37 in logical epoch 37
[2021-06-02 05:10:09] [data] Shuffling data
[2021-06-02 05:10:09] [data] Done reading 256,102 sentences
[2021-06-02 05:10:10] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 05:10:42] Ep. 37 : Up. 235000 : Sen. 3,555 : Cost 2.82684922 * 301,825 @ 612 after 143,890,448 : Time 173.41s : 1740.57 words/s : L.r. 7.8279e-05
[2021-06-02 05:10:42] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 05:10:43] Saving model weights and runtime parameters to model.transformer.my-en/model.iter235000.npz
[2021-06-02 05:10:44] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 05:10:45] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 05:10:50] [valid] Ep. 37 : Up. 235000 : cross-entropy : 113.665 : stalled 8 times (last best: 113.611)
[2021-06-02 05:10:53] [valid] Ep. 37 : Up. 235000 : perplexity : 55.3615 : stalled 8 times (last best: 55.2557)
[2021-06-02 05:11:21] [valid] Ep. 37 : Up. 235000 : bleu : 8.76723 : stalled 4 times (last best: 8.90264)
[2021-06-02 05:14:14] Ep. 37 : Up. 235500 : Sen. 22,916 : Cost 2.74814272 * 302,223 @ 645 after 144,192,671 : Time 212.27s : 1423.78 words/s : L.r. 7.8196e-05
[2021-06-02 05:17:07] Ep. 37 : Up. 236000 : Sen. 42,261 : Cost 2.76051188 * 303,400 @ 640 after 144,496,071 : Time 172.64s : 1757.42 words/s : L.r. 7.8113e-05
[2021-06-02 05:20:00] Ep. 37 : Up. 236500 : Sen. 61,533 : Cost 2.75960350 * 302,171 @ 408 after 144,798,242 : Time 172.53s : 1751.42 words/s : L.r. 7.8031e-05
[2021-06-02 05:22:53] Ep. 37 : Up. 237000 : Sen. 81,101 : Cost 2.77114701 * 304,955 @ 553 after 145,103,197 : Time 172.95s : 1763.27 words/s : L.r. 7.7948e-05
[2021-06-02 05:25:46] Ep. 37 : Up. 237500 : Sen. 100,746 : Cost 2.77539873 * 304,991 @ 560 after 145,408,188 : Time 173.40s : 1758.86 words/s : L.r. 7.7866e-05
[2021-06-02 05:28:39] Ep. 37 : Up. 238000 : Sen. 120,078 : Cost 2.80402422 * 301,943 @ 624 after 145,710,131 : Time 172.63s : 1749.05 words/s : L.r. 7.7784e-05
[2021-06-02 05:31:32] Ep. 37 : Up. 238500 : Sen. 139,668 : Cost 2.80030513 * 304,897 @ 504 after 146,015,028 : Time 173.04s : 1762.02 words/s : L.r. 7.7703e-05
[2021-06-02 05:34:25] Ep. 37 : Up. 239000 : Sen. 159,146 : Cost 2.80444956 * 303,849 @ 728 after 146,318,877 : Time 172.99s : 1756.46 words/s : L.r. 7.7622e-05
[2021-06-02 05:37:18] Ep. 37 : Up. 239500 : Sen. 178,677 : Cost 2.81388497 * 303,206 @ 630 after 146,622,083 : Time 173.10s : 1751.61 words/s : L.r. 7.7540e-05
[2021-06-02 05:40:10] Ep. 37 : Up. 240000 : Sen. 198,401 : Cost 2.82398438 * 303,866 @ 636 after 146,925,949 : Time 172.68s : 1759.69 words/s : L.r. 7.7460e-05
[2021-06-02 05:40:10] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 05:40:12] Saving model weights and runtime parameters to model.transformer.my-en/model.iter240000.npz
[2021-06-02 05:40:12] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 05:40:13] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 05:40:18] [valid] Ep. 37 : Up. 240000 : cross-entropy : 113.793 : stalled 9 times (last best: 113.611)
[2021-06-02 05:40:21] [valid] Ep. 37 : Up. 240000 : perplexity : 55.6123 : stalled 9 times (last best: 55.2557)
[2021-06-02 05:40:48] [valid] Ep. 37 : Up. 240000 : bleu : 8.76225 : stalled 5 times (last best: 8.90264)
[2021-06-02 05:43:41] Ep. 37 : Up. 240500 : Sen. 217,744 : Cost 2.84131551 * 303,064 @ 643 after 147,229,013 : Time 210.64s : 1438.79 words/s : L.r. 7.7379e-05
[2021-06-02 05:46:34] Ep. 37 : Up. 241000 : Sen. 237,408 : Cost 2.83979416 * 303,142 @ 519 after 147,532,155 : Time 173.09s : 1751.34 words/s : L.r. 7.7299e-05
[2021-06-02 05:49:18] Seen 255710 samples
[2021-06-02 05:49:18] Starting data epoch 38 in logical epoch 38
[2021-06-02 05:49:18] [data] Shuffling data
[2021-06-02 05:49:18] [data] Done reading 256,102 sentences
[2021-06-02 05:49:19] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 05:49:27] Ep. 38 : Up. 241500 : Sen. 913 : Cost 2.84324837 * 300,533 @ 690 after 147,832,688 : Time 172.94s : 1737.83 words/s : L.r. 7.7219e-05
[2021-06-02 05:52:19] Ep. 38 : Up. 242000 : Sen. 20,144 : Cost 2.74053407 * 303,731 @ 480 after 148,136,419 : Time 172.37s : 1762.05 words/s : L.r. 7.7139e-05
[2021-06-02 05:55:13] Ep. 38 : Up. 242500 : Sen. 39,786 : Cost 2.74986076 * 305,673 @ 780 after 148,442,092 : Time 173.93s : 1757.45 words/s : L.r. 7.7059e-05
[2021-06-02 05:58:06] Ep. 38 : Up. 243000 : Sen. 59,180 : Cost 2.76754427 * 302,221 @ 700 after 148,744,313 : Time 172.45s : 1752.52 words/s : L.r. 7.6980e-05
[2021-06-02 06:00:58] Ep. 38 : Up. 243500 : Sen. 78,738 : Cost 2.76586628 * 300,828 @ 167 after 149,045,141 : Time 172.67s : 1742.18 words/s : L.r. 7.6901e-05
[2021-06-02 06:03:52] Ep. 38 : Up. 244000 : Sen. 98,320 : Cost 2.77798176 * 307,383 @ 623 after 149,352,524 : Time 173.60s : 1770.63 words/s : L.r. 7.6822e-05
[2021-06-02 06:06:45] Ep. 38 : Up. 244500 : Sen. 117,747 : Cost 2.78349161 * 305,250 @ 500 after 149,657,774 : Time 173.16s : 1762.81 words/s : L.r. 7.6744e-05
[2021-06-02 06:09:38] Ep. 38 : Up. 245000 : Sen. 137,381 : Cost 2.78501225 * 303,518 @ 499 after 149,961,292 : Time 173.06s : 1753.82 words/s : L.r. 7.6665e-05
[2021-06-02 06:09:38] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 06:09:40] Saving model weights and runtime parameters to model.transformer.my-en/model.iter245000.npz
[2021-06-02 06:09:40] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 06:09:41] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz
[2021-06-02 06:09:46] [valid] Ep. 38 : Up. 245000 : cross-entropy : 113.879 : stalled 10 times (last best: 113.611)
[2021-06-02 06:09:49] [valid] Ep. 38 : Up. 245000 : perplexity : 55.7804 : stalled 10 times (last best: 55.2557)
[2021-06-02 06:10:16] [valid] Ep. 38 : Up. 245000 : bleu : 9.05653 : new best
[2021-06-02 06:10:17] Training finished
[2021-06-02 06:10:18] Saving model weights and runtime parameters to model.transformer.my-en/model.npz.orig.npz
[2021-06-02 06:10:19] Saving model weights and runtime parameters to model.transformer.my-en/model.npz
[2021-06-02 06:10:20] Saving Adam parameters to model.transformer.my-en/model.npz.optimizer.npz

real	1368m49.052s
user	2022m47.531s
sys	1m44.371s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ 
```

## Testing

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.transformer.my-en$ time marian-decoder -m ./model.npz -v ../data/vocab/vocab.my.yml ../data/vocab/vocab.en.yml --devices 0 1 --output hyp.model.en < ../data/test.my
...
...
[2021-06-02 07:38:05] Best translation 988 : At around 6:00 p.m. local time, NASA saw a water station in Madrid shortly before walking back to roads, areas.
[2021-06-02 07:38:05] Best translation 989 : Police said that Sara wandered along the main street of the city.
[2021-06-02 07:38:06] Best translation 990 : She also went through this incident, a major railway station and two UEFA offices located in the capital of Sydney (the Group, which also has two major offices in the capital of Homs.
[2021-06-02 07:38:06] Best translation 991 : The police finally looked for her around an hour before, around the town before being caught back in custody for almost an hour before,
[2021-06-02 07:38:06] Best translation 992 : The earrings and police looked for Sarah but she did not answer their cry from the band said.
[2021-06-02 07:38:06] Best translation 993 : Police said she had a difficult task to keep her .
[2021-06-02 07:38:06] Best translation 994 : About 2,000 local time, a worker managed to control it from a zoo and placed her on a car taking her into the museum only to the museum .
[2021-06-02 07:38:06] Best translation 995 : There were no reports of any injuries or injuries during the accident but police managed to arrest the suspect at least one time to be arrested by any person who was always watching the videos of the incident.
[2021-06-02 07:38:06] Best translation 996 : The Associated Press said that after the incident occurred near Paris due to cyclone &quot;
[2021-06-02 07:38:06] Best translation 997 : After coming back to the society, she was tired but was pleased to return …&quot;
[2021-06-02 07:38:07] Best translation 998 : The KNA students and his wife , aged 81 and 78 of his wife were involved in a car accident during a drive to their home in Southern Philippines.
[2021-06-02 07:38:07] Best translation 999 : Mrs. Beach died immediately after the game, Mr. Mcardle felt a straight throat .
[2021-06-02 07:38:07] Best translation 1000 : Their couple had returned from a poem where they offered both .
[2021-06-02 07:38:07] Best translation 1001 : London is a kind Jewish author who lives in southern Wales.
[2021-06-02 07:38:07] Best translation 1002 : 300 , his wife is an artist and author .
[2021-06-02 07:38:07] Best translation 1003 : London is known as a poet and medical doctor .
[2021-06-02 07:38:07] Best translation 1004 : Beach actually was a special medical doctor at a clinic to over thirty years.
[2021-06-02 07:38:07] Best translation 1005 : But sacrificed value for his writing and received a lot of literature and member awards .
[2021-06-02 07:38:07] Best translation 1006 : In 1996, he graduated from state universities in 1989.
[2021-06-02 07:38:07] Best translation 1007 : The couple of books together in the 1980s .
[2021-06-02 07:38:07] Best translation 1008 : Her husband , a son and two daughters were taken away .
[2021-06-02 07:38:08] Best translation 1009 : Four members of the journalists were fined and four men on Wednesday for driving in California after being deported back to her home after being struck back on her home.
[2021-06-02 07:38:08] Best translation 1010 : At least four others were closed , but they were not arrested .
[2021-06-02 07:38:08] Best translation 1011 : According to reports, a group of journalists came following a high speed in the police shooting at around 8 : 00 p.m. according to police.
[2021-06-02 07:38:08] Best translation 1012 : They also said that they were very close behind her and used it to change the danger for getting rid of her from behind him.
[2021-06-02 07:38:08] Best translation 1013 : She also attempted to escape her in least one of the vehicles who drove her car out of the car, but she was unable to disclose or dispose of the vehicles or property.
[2021-06-02 07:38:08] Best translation 1014 : They reported that her personal information was reported to be correct, and she was releasing her.
[2021-06-02 07:38:08] Best translation 1015 : Police were investigating the tenure of her driving licence and was surprised by the police.
[2021-06-02 07:38:08] Best translation 1016 : Belgium did not want people arrested for any injuries made by the journalists,
[2021-06-02 07:38:09] Best translation 1017 : Langham said that Langham was part of the group.
[2021-06-02 07:38:09] Total time: 139.64632s wall

real	2m21.085s
user	4m39.447s
sys	0m1.637s
```

## Evaluation on Transformer Model

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.transformer.my-en$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ../data/test.en < ./hyp.model.en  >> results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.transformer.my-en$ cat ./results.txt 
BLEU = 8.83, 45.4/17.6/8.1/3.9 (BP=0.700, ratio=0.737, hyp_len=20595, ref_len=27929)
```

## Model Ensembling Results, System 5+6
### Eval Result, s2s+Transformer, --weights 0.4 0.6 (for Myanmar-English pair)

Ensembling အလုပ်အတွက်  shell script ရေးပြီး run ခဲ့...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./ensemble-2models.sh model.s2s-4.my-en/model.npz model.transformer.my-en/model.npz 0.4 0.6 ./data/vocab/vocab.my.yml ./data/vocab/vocab.en.yml ./ensembling-results/2.hyp.s2s-plus-transformer.en1 ./data/test.my
...
...
...
[2021-06-02 08:26:35] Best translation 1008 : Jean had left her husband , a son and two daughters .
[2021-06-02 08:26:35] Best translation 1009 : Four members of the journalists were arrested and charged on Wednesday for driving in California after being deported back to her home in California.
[2021-06-02 08:26:35] Best translation 1010 : At least four others were closed , but no arrest was arrested .
[2021-06-02 08:26:35] Best translation 1011 : According to reports, a group of journalists came following a high speed at around 8 : 00 p.m.
[2021-06-02 08:26:35] Best translation 1012 : They also said that they were very close behind her and made the use of the dangerous path in order to follow her.
[2021-06-02 08:26:35] Best translation 1013 : The police also said that she had been driven by at least one of the cars that drove her car out of the road, but she was unable to identify the vehicles or property.
[2021-06-02 08:26:35] Best translation 1014 : They reported her personal data to be true and she was released.
[2021-06-02 08:26:35] Best translation 1015 : Police reported that police were examining the tenure of her driving licence and was surprised because the licence was true.
[2021-06-02 08:26:35] Best translation 1016 : Wikipedia did not want people to be arrested for any injuries made by reporters without charge.
[2021-06-02 08:26:35] Best translation 1017 : &quot;This is part of the organization but the spokesman for Los Angeles Police said.
[2021-06-02 08:26:35] Total time: 403.70474s wall

real	6m46.585s
user	13m27.308s
sys	0m2.761s
```

Evaluation:  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./eval.sh ./data/test.en ./ensembling-results/2.hyp.s2s-plus-transformer.en1 ./ensembling-results/2.s2s-plus-transformer-0.4-0.6.myen.results.txt
BLEU = 10.56, 47.3/19.9/9.5/4.8 (BP=0.733, ratio=0.763, hyp_len=21306, ref_len=27929)
```

### Eval Result, s2s+Transformer, --weights 0.5 0.5

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./ensemble-2models.sh model.s2s-4.my-en/model.npz model.transformer.my-en/model.npz 0.5 0.6 ./data/vocab/vocab.my.yml ./data/vocab/vocab.en.yml ./ensembling-results/2.hyp.s2s-plus-transformer.en2 ./data/test.my
...
...
...
[2021-06-02 08:37:52] Best translation 1010 : At least four others were closed , but no arrest was arrested .
[2021-06-02 08:37:52] Best translation 1011 : According to reports, a group of journalists came following a high speed at around 8 : 00 p.m.
[2021-06-02 08:37:52] Best translation 1012 : They also said that they were very close behind her and made the use of the dangerous path in order to follow her.
[2021-06-02 08:37:52] Best translation 1013 : The police also said that she had been driven by at least one of the cars that drove her car out of the road, but she was unable to identify the vehicles or property.
[2021-06-02 08:37:52] Best translation 1014 : They reported her personal data to be true and she was released.
[2021-06-02 08:37:52] Best translation 1015 : Police reported that police were examining the tenure of her driving licence and was surprised because the licence was true.
[2021-06-02 08:37:52] Best translation 1016 : Wikipedia did not want people to be arrested for any injuries made by reporters without charge.
[2021-06-02 08:37:52] Best translation 1017 : &quot;This is part of the organization but the spokesman for Los Angeles Police said, &quot;It&apos;s part of the organization.
[2021-06-02 08:37:52] Total time: 407.18813s wall

real	6m49.738s
user	13m34.351s
sys	0m2.744s

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./eval.sh ./data/test.en ./ensembling-results/2.hyp.s2s-plus-transformer.en2 ./ensembling-results/2.s2s-plus-transformer-0.5-0.5.myen.results.txt
BLEU = 10.81, 47.3/20.0/9.6/4.8 (BP=0.746, ratio=0.773, hyp_len=21590, ref_len=27929)
```

### Eval Result, s2s+Transformer, --weights 0.6 0.4

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./ensemble-2models.sh model.s2s-4.my-en/model.npz model.transformer.my-en/model.npz 0.6 0.4 ./data/vocab/vocab.my.yml ./data/vocab/vocab.en.yml ./ensembling-results/2.hyp.s2s-plus-transformer.en3 ./data/test.my
...
...
...
[2021-06-02 08:50:48] Best translation 1013 : The police also said that she had been driven by at least one of the cars that drove her car out of the car, but she couldn &amp; apos ; t afford to reveal it or to identify the vehicles or property.
[2021-06-02 08:50:48] Best translation 1014 : They reported her personal data to be true and she was released.
[2021-06-02 08:50:48] Best translation 1015 : Police reported that police were examined to know the tenure of her driving licence and was surprised because the licence was true.
[2021-06-02 08:50:48] Best translation 1016 : Shakespeare did not want compensation for any damage made by reporters and did not want people to be arrested
[2021-06-02 08:50:48] Best translation 1017 : &quot;This is part of the organization but the spokesperson for Los Angeles Police said, &quot;It&apos;s part of the organization.
[2021-06-02 08:50:48] Total time: 415.88890s wall

real	6m58.443s
user	13m51.652s
sys	0m2.600s

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./eval.sh ./data/test.en ./ensembling-results/2.hyp.s2s-plus-transformer.en3 ./ensembling-results/2.s2s-plus-transformer-0.6-0.4.myen.results.txt
BLEU = 10.94, 47.0/19.9/9.7/5.0 (BP=0.752, ratio=0.778, hyp_len=21726, ref_len=27929)
```


=============================================================


## Prepared Word Segmented Data for Myanmar

UCSY Corpus က word segmented မလုပ်ထားတာကိုပဲ ပေးတယ်။
အဲဒါကြောင့် မြန်မာစာ ဒေတာဘက် အခြမ်းကို word segmentation ဖြတ်ပြီးတော့ MT experiment လုပ်ဖို့အတွက် in-house myWord ကို သုံးပြီး စာလုံးဖြတ်ဖို့အတွက် ပြင်ဆင်ခဲ့...  

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/tool/word-seg-tool/python-wordsegment/wordsegment/y-test/ref/viterbi/exp-4/wat2021-data/final$ cp valid.my.word /home/ye/exp/nmt/plus-alt/data_word/valid.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/tool/word-seg-tool/python-wordsegment/wordsegment/y-test/ref/viterbi/exp-4/wat2021-data/final$ cp test.my.word /home/ye/exp/nmt/plus-alt/data_word/test.my

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/tool/word-seg-tool/python-wordsegment/wordsegment/y-test/ref/viterbi/exp-4/wat2021-data/final$ cp ./ucsy-alt.train.word /home/ye/exp/nmt/plus-alt/data_word/train.my
```

## Check parallel data

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word$ wc *.en
    1018    27929   151447 test.en
  256102  3770260 19768494 train.en
    1000    27318   147768 valid.en
  258120  3825507 20067709 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word$ wc *.my
    1018    36255   538803 test.my
  256102  4460308 68093383 train.my
    1000    35355   528100 valid.my
  258120  4531918 69160286 total
```

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word$ head -3 *.my
==> test.my <==
ဆစ်ဒနီ ကရန့်ဝစ်ခ် မြင်း ပြိုင်ကွင်း မှ မျိုး သန့် ပြိုင်မြင်း ရှစ် ကောင် ဟာ မြင်း တုတ်ကွေး ရောဂါ ကူးစက် ခံ ခဲ့ ရ တယ် ဆို တာ အတည်ပြု ခဲ့ ပါ တယ် ။
ရန့်ဝစ်ခ် ကို ပိတ် ထား ခဲ့ ပြီး ၂လ အထိ ကြာကြာ ဆက်လက် ထိန်းသိမ်း ထားရန် မျှော်လင့် ပါ တယ် ။
အလွန် ပြင်းထန် သော တုတ်ကွေး ဟာ ရန့်ဝစ်ခ် မှာ အမြဲ ထားသော မြင်း ၇၀၀ ထဲ က အများစု ကို ကူးစက် လိမ့် မည် လို့ ခန့်မှန်း ထား ပါ တယ် ။

==> train.my <==
ကြိမ်ချောင်း ရဲစခန်း တွင် လူသတ်မှု ဖြင့် အမှု ဖွင့် ထား ပြီး ပြီ ။
ရဲ များ က စုံစမ်း လျက် ရှိ သည် ။
တပ်မတော် တပ်ဖွဲ့ သည် ရှမ်းပြည်နယ် မြောက်ပိုင်း တာမိုးညဲ မြို့ ၌ မနေ့ က ရှောင်တခင် စစ်ဆေး မှု တစ်ခု ပြုလုပ် စဉ် အတွင်း ယာဉ် တစ်စီး မှ လက်နက်များ နှင့် တရားမဝင် သစ် များ ကို ဖမ်းဆီးရမိခဲ့ သည် ။

==> valid.my <==
&quot; သူ ၏ ဆုံးပါး ခြင်း အတွက် ကျွန်တော်တို့ ဝမ်းနည်း သော်လည်း ၊ လူမျိုးရေး နှင့် ဘာသာ ရေး ရန်စွယ် ကို နှိုးဆွ ပေး သော အမွေအနှစ် တစ်ခု ကို သူ ချန် ထား ခဲ့ သည် ။ &quot;
ပါကစ္စတန် နိုင်ငံ ၏ ဝတ် ဇီရီစ တန် မြောက်ပိုင်း ရှိ ၊ လူ က ထိန်း ရန်မလို သော စစ် လေယာဉ် မှ ပစ်ခတ် ခြင်း အနေဖြင့် ယခု သတ်မှတ်ထား သော ၊ အမေရိကန် ပြည်ထောင်စု ဒုံးကျည် ဖြင့် ၊ သူ့ ကို ထိခိုက် စေ ခဲ့ သည် ဟု ထင်ကြေးပေး ခဲ့ ပြီးနောက် နောက်ထပ် အလွန် များပြား သော စစ်သွေးကြွ များ လည်း သေဆုံးကြောင်း သတင်းပို့ ခဲ့ သည် ။
&quot; လူ က ထိန်း ရန်မလို သော လေယာဉ် မှ ပစ်ခတ် ရန် ဒုံးကျည် ပေါ်ပေါက် ခဲ့ သည် ၊&quot; ဟု ပါကစ္စတန် သတင်း ထောက်လှမ်းရေး အရာရှိ တစ် ယောက် က ပြော ခဲ့ သည် ။
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word$
```

## Prepare Vocab Files (for word unit)

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word$ cat ./train.my ./valid.my > ./vocab/train-dev.my

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word/vocab$ marian-vocab < ./train-dev.my > ./vocab.my.yml
[2021-06-02 14:27:46] Creating vocabulary...
[2021-06-02 14:27:46] [data] Creating vocabulary stdout from stdin
[2021-06-02 14:27:48] Finished
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/data_word/vocab$ head ./vocab.my.yml 
</s>: 0
<unk>: 1
။: 2
သည်: 3
ကို: 4
များ: 5
တယ်: 6
က: 7
ပါ: 8
ခဲ့: 9
```

## System 
## Script for s2s (word unit)

#!/bin/bash

# Preparation for WAT2021 en-my, my-en share MT task by Ye, LST, NECTEC, Thailand
## for Word Unit
## Reference: https://marian-nmt.github.io/examples/mtm2017/complex/

mkdir model.s2s-4.word;

marian \
  --type s2s \
  --train-sets data_word/train.en data_word/train.my \
  --max-length 100 \
  --valid-sets data_word/valid.en data_word/valid.my \
  --vocabs data_word/vocab/vocab.en.yml data_word/vocab/vocab.my.yml \
  --model model.s2s-4.word/model.npz \
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
  --log model.s2s-4.word/train.log --valid-log model.s2s-4.word/valid.log \
  --devices 0 1 --sync-sgd --seed 1111  \
  --dump-config > model.s2s-4.word/config.yml
  
time marian -c model.s2s-4.word/config.yml  2>&1 | tee s2s.enmy.syl.log

## Training Log

[2021-06-02 14:32:06] [data] Shuffling data
[2021-06-02 14:32:06] [data] Done reading 256,102 sentences
[2021-06-02 14:32:07] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 14:32:07] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-06-02 14:32:07] [memory] Reserving 626 MB, device gpu1
[2021-06-02 14:32:07] [memory] Reserving 626 MB, device gpu0
[2021-06-02 14:32:07] [memory] Reserving 626 MB, device gpu0
[2021-06-02 14:32:07] [memory] Reserving 626 MB, device gpu1
[2021-06-02 14:32:07] [memory] Reserving 313 MB, device gpu0
[2021-06-02 14:32:07] [memory] Reserving 313 MB, device gpu1
[2021-06-02 14:32:08] [memory] Reserving 626 MB, device gpu0
[2021-06-02 14:32:08] [memory] Reserving 626 MB, device gpu1
[2021-06-02 14:32:08] Error: CUDA error 2 'out of memory' - /home/ye/tool/marian/src/tensors/gpu/device.cu:38: cudaMalloc(&data_, size)
[2021-06-02 14:32:08] Error: Aborted from virtual void marian::gpu::Device::reserve(size_t) in /home/ye/tool/marian/src/tensors/gpu/device.cu:38

[CALL STACK]
[0x55f79f2a5eb3]    marian::gpu::Device::  reserve  (unsigned long)    + 0x15b3
[0x55f79ebf62be]    marian::TensorAllocator::  reserveExact  (unsigned long) + 0x11e
[0x55f79ee111e9]    marian::Adam::  updateImpl  (IntrusivePtr<marian::TensorBase>,  IntrusivePtr<marian::TensorBase>,  unsigned long,  unsigned long) + 0x6a9
[0x55f79ef59a55]    marian::OptimizerBase::  update  (IntrusivePtr<marian::TensorBase>,  IntrusivePtr<marian::TensorBase>,  unsigned long) + 0xc5
[0x55f79ef6c488]                                                       + 0x73f488
[0x55f79eff18fa]    marian::ThreadPool::enqueue<std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&>(std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&)::{lambda()#1}::  operator()  () const + 0x5a
[0x55f79eff2544]    std::_Function_handler<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> (),std::__future_base::_Task_setter<std::unique_ptr<std::__future_base::_Result<void>,std::__future_base::_Result_base::_Deleter>,std::__future_base::_Task_state<marian::ThreadPool::enqueue<std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&>(std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&)::{lambda()#1},std::allocator<int>,void ()>::_M_run()::{lambda()#1},void>>::  _M_invoke  (std::_Any_data const&) + 0x34
[0x55f79eb7f15d]    std::__future_base::_State_baseV2::  _M_do_set  (std::function<std::unique_ptr<std::__future_base::_Result_base,std::__future_base::_Result_base::_Deleter> ()>*,  bool*) + 0x2d
[0x7f97867ffc0f]                                                       + 0x11c0f
[0x55f79efd7ee1]    std::_Function_handler<void (),marian::ThreadPool::enqueue<std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&>(std::function<void (unsigned long,unsigned long,unsigned long)> const&,unsigned long&,unsigned long&,unsigned long&)::{lambda()#3}>::  _M_invoke  (std::_Any_data const&) + 0x121
[0x55f79eb8189a]    std::thread::_State_impl<std::thread::_Invoker<std::tuple<marian::ThreadPool::reserve(unsigned long)::{lambda()#1}>>>::  _M_run  () + 0x13a
[0x7f97866e3d84]                                                       + 0xd6d84
[0x7f97867f7590]                                                       + 0x9590
[0x7f97863d2223]    clone                                              + 0x43


real	0m34.528s
user	0m34.291s
sys	0m0.839s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./s2s.deep4.word.sh 


စက်ကို restart လုပ်ပြီး နောက်တစ်ခေါက် ပြန် run ခဲ့...

base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./s2s.deep4.word.sh 
mkdir: cannot create directory ‘model.s2s-4.word’: File exists
[2021-06-02 15:23:20] [marian] Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-02 15:23:20] [marian] Running on administrator-HP-Z2-Tower-G4-Workstation as process 3896 with command line:
[2021-06-02 15:23:20] [marian] marian -c model.s2s-4.word/config.yml
[2021-06-02 15:23:20] [config] after: 0e
[2021-06-02 15:23:20] [config] after-batches: 0
[2021-06-02 15:23:20] [config] after-epochs: 0
[2021-06-02 15:23:20] [config] all-caps-every: 0
[2021-06-02 15:23:20] [config] allow-unk: false
[2021-06-02 15:23:20] [config] authors: false
[2021-06-02 15:23:20] [config] beam-size: 12
[2021-06-02 15:23:20] [config] bert-class-symbol: "[CLS]"
[2021-06-02 15:23:20] [config] bert-mask-symbol: "[MASK]"
[2021-06-02 15:23:20] [config] bert-masking-fraction: 0.15
[2021-06-02 15:23:20] [config] bert-sep-symbol: "[SEP]"
[2021-06-02 15:23:20] [config] bert-train-type-embeddings: true
[2021-06-02 15:23:20] [config] bert-type-vocab-size: 2
[2021-06-02 15:23:20] [config] build-info: ""
[2021-06-02 15:23:20] [config] cite: false
[2021-06-02 15:23:20] [config] clip-norm: 1
[2021-06-02 15:23:20] [config] cost-scaling:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] cost-type: ce-sum
[2021-06-02 15:23:20] [config] cpu-threads: 0
[2021-06-02 15:23:20] [config] data-weighting: ""
[2021-06-02 15:23:20] [config] data-weighting-type: sentence
[2021-06-02 15:23:20] [config] dec-cell: lstm
[2021-06-02 15:23:20] [config] dec-cell-base-depth: 2
[2021-06-02 15:23:20] [config] dec-cell-high-depth: 2
[2021-06-02 15:23:20] [config] dec-depth: 2
[2021-06-02 15:23:20] [config] devices:
[2021-06-02 15:23:20] [config]   - 0
[2021-06-02 15:23:20] [config]   - 1
[2021-06-02 15:23:20] [config] dim-emb: 512
[2021-06-02 15:23:20] [config] dim-rnn: 1024
[2021-06-02 15:23:20] [config] dim-vocabs:
[2021-06-02 15:23:20] [config]   - 0
[2021-06-02 15:23:20] [config]   - 0
[2021-06-02 15:23:20] [config] disp-first: 0
[2021-06-02 15:23:20] [config] disp-freq: 500
[2021-06-02 15:23:20] [config] disp-label-counts: true
[2021-06-02 15:23:20] [config] dropout-rnn: 0.3
[2021-06-02 15:23:20] [config] dropout-src: 0.3
[2021-06-02 15:23:20] [config] dropout-trg: 0
[2021-06-02 15:23:20] [config] dump-config: ""
[2021-06-02 15:23:20] [config] early-stopping: 10
[2021-06-02 15:23:20] [config] embedding-fix-src: false
[2021-06-02 15:23:20] [config] embedding-fix-trg: false
[2021-06-02 15:23:20] [config] embedding-normalization: false
[2021-06-02 15:23:20] [config] embedding-vectors:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] enc-cell: lstm
[2021-06-02 15:23:20] [config] enc-cell-depth: 2
[2021-06-02 15:23:20] [config] enc-depth: 2
[2021-06-02 15:23:20] [config] enc-type: alternating
[2021-06-02 15:23:20] [config] english-title-case-every: 0
[2021-06-02 15:23:20] [config] exponential-smoothing: 0.0001
[2021-06-02 15:23:20] [config] factor-weight: 1
[2021-06-02 15:23:20] [config] grad-dropping-momentum: 0
[2021-06-02 15:23:20] [config] grad-dropping-rate: 0
[2021-06-02 15:23:20] [config] grad-dropping-warmup: 100
[2021-06-02 15:23:20] [config] gradient-checkpointing: false
[2021-06-02 15:23:20] [config] guided-alignment: none
[2021-06-02 15:23:20] [config] guided-alignment-cost: mse
[2021-06-02 15:23:20] [config] guided-alignment-weight: 0.1
[2021-06-02 15:23:20] [config] ignore-model-config: false
[2021-06-02 15:23:20] [config] input-types:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] interpolate-env-vars: false
[2021-06-02 15:23:20] [config] keep-best: false
[2021-06-02 15:23:20] [config] label-smoothing: 0
[2021-06-02 15:23:20] [config] layer-normalization: true
[2021-06-02 15:23:20] [config] learn-rate: 0.0001
[2021-06-02 15:23:20] [config] lemma-dim-emb: 0
[2021-06-02 15:23:20] [config] log: model.s2s-4.word/train.log
[2021-06-02 15:23:20] [config] log-level: info
[2021-06-02 15:23:20] [config] log-time-zone: ""
[2021-06-02 15:23:20] [config] logical-epoch:
[2021-06-02 15:23:20] [config]   - 1e
[2021-06-02 15:23:20] [config]   - 0
[2021-06-02 15:23:20] [config] lr-decay: 0
[2021-06-02 15:23:20] [config] lr-decay-freq: 50000
[2021-06-02 15:23:20] [config] lr-decay-inv-sqrt:
[2021-06-02 15:23:20] [config]   - 0
[2021-06-02 15:23:20] [config] lr-decay-repeat-warmup: false
[2021-06-02 15:23:20] [config] lr-decay-reset-optimizer: false
[2021-06-02 15:23:20] [config] lr-decay-start:
[2021-06-02 15:23:20] [config]   - 10
[2021-06-02 15:23:20] [config]   - 1
[2021-06-02 15:23:20] [config] lr-decay-strategy: epoch+stalled
[2021-06-02 15:23:20] [config] lr-report: false
[2021-06-02 15:23:20] [config] lr-warmup: 0
[2021-06-02 15:23:20] [config] lr-warmup-at-reload: false
[2021-06-02 15:23:20] [config] lr-warmup-cycle: false
[2021-06-02 15:23:20] [config] lr-warmup-start-rate: 0
[2021-06-02 15:23:20] [config] max-length: 100
[2021-06-02 15:23:20] [config] max-length-crop: false
[2021-06-02 15:23:20] [config] max-length-factor: 3
[2021-06-02 15:23:20] [config] maxi-batch: 100
[2021-06-02 15:23:20] [config] maxi-batch-sort: trg
[2021-06-02 15:23:20] [config] mini-batch: 64
[2021-06-02 15:23:20] [config] mini-batch-fit: true
[2021-06-02 15:23:20] [config] mini-batch-fit-step: 10
[2021-06-02 15:23:20] [config] mini-batch-track-lr: false
[2021-06-02 15:23:20] [config] mini-batch-warmup: 0
[2021-06-02 15:23:20] [config] mini-batch-words: 0
[2021-06-02 15:23:20] [config] mini-batch-words-ref: 0
[2021-06-02 15:23:20] [config] model: model.s2s-4.word/model.npz
[2021-06-02 15:23:20] [config] multi-loss-type: sum
[2021-06-02 15:23:20] [config] multi-node: false
[2021-06-02 15:23:20] [config] multi-node-overlap: true
[2021-06-02 15:23:20] [config] n-best: false
[2021-06-02 15:23:20] [config] no-nccl: false
[2021-06-02 15:23:20] [config] no-reload: false
[2021-06-02 15:23:20] [config] no-restore-corpus: false
[2021-06-02 15:23:20] [config] normalize: 0
[2021-06-02 15:23:20] [config] normalize-gradient: false
[2021-06-02 15:23:20] [config] num-devices: 0
[2021-06-02 15:23:20] [config] optimizer: adam
[2021-06-02 15:23:20] [config] optimizer-delay: 1
[2021-06-02 15:23:20] [config] optimizer-params:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] output-omit-bias: false
[2021-06-02 15:23:20] [config] overwrite: false
[2021-06-02 15:23:20] [config] precision:
[2021-06-02 15:23:20] [config]   - float32
[2021-06-02 15:23:20] [config]   - float32
[2021-06-02 15:23:20] [config]   - float32
[2021-06-02 15:23:20] [config] pretrained-model: ""
[2021-06-02 15:23:20] [config] quantize-biases: false
[2021-06-02 15:23:20] [config] quantize-bits: 0
[2021-06-02 15:23:20] [config] quantize-log-based: false
[2021-06-02 15:23:20] [config] quantize-optimization-steps: 0
[2021-06-02 15:23:20] [config] quiet: false
[2021-06-02 15:23:20] [config] quiet-translation: false
[2021-06-02 15:23:20] [config] relative-paths: false
[2021-06-02 15:23:20] [config] right-left: false
[2021-06-02 15:23:20] [config] save-freq: 5000
[2021-06-02 15:23:20] [config] seed: 1111
[2021-06-02 15:23:20] [config] sentencepiece-alphas:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] sentencepiece-max-lines: 2000000
[2021-06-02 15:23:20] [config] sentencepiece-options: ""
[2021-06-02 15:23:20] [config] shuffle: data
[2021-06-02 15:23:20] [config] shuffle-in-ram: false
[2021-06-02 15:23:20] [config] sigterm: save-and-exit
[2021-06-02 15:23:20] [config] skip: true
[2021-06-02 15:23:20] [config] sqlite: ""
[2021-06-02 15:23:20] [config] sqlite-drop: false
[2021-06-02 15:23:20] [config] sync-sgd: true
[2021-06-02 15:23:20] [config] tempdir: /tmp
[2021-06-02 15:23:20] [config] tied-embeddings: true
[2021-06-02 15:23:20] [config] tied-embeddings-all: false
[2021-06-02 15:23:20] [config] tied-embeddings-src: false
[2021-06-02 15:23:20] [config] train-embedder-rank:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] train-sets:
[2021-06-02 15:23:20] [config]   - data_word/train.en
[2021-06-02 15:23:20] [config]   - data_word/train.my
[2021-06-02 15:23:20] [config] transformer-aan-activation: swish
[2021-06-02 15:23:20] [config] transformer-aan-depth: 2
[2021-06-02 15:23:20] [config] transformer-aan-nogate: false
[2021-06-02 15:23:20] [config] transformer-decoder-autoreg: self-attention
[2021-06-02 15:23:20] [config] transformer-depth-scaling: false
[2021-06-02 15:23:20] [config] transformer-dim-aan: 2048
[2021-06-02 15:23:20] [config] transformer-dim-ffn: 2048
[2021-06-02 15:23:20] [config] transformer-dropout: 0
[2021-06-02 15:23:20] [config] transformer-dropout-attention: 0
[2021-06-02 15:23:20] [config] transformer-dropout-ffn: 0
[2021-06-02 15:23:20] [config] transformer-ffn-activation: swish
[2021-06-02 15:23:20] [config] transformer-ffn-depth: 2
[2021-06-02 15:23:20] [config] transformer-guided-alignment-layer: last
[2021-06-02 15:23:20] [config] transformer-heads: 8
[2021-06-02 15:23:20] [config] transformer-no-projection: false
[2021-06-02 15:23:20] [config] transformer-pool: false
[2021-06-02 15:23:20] [config] transformer-postprocess: dan
[2021-06-02 15:23:20] [config] transformer-postprocess-emb: d
[2021-06-02 15:23:20] [config] transformer-postprocess-top: ""
[2021-06-02 15:23:20] [config] transformer-preprocess: ""
[2021-06-02 15:23:20] [config] transformer-tied-layers:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] transformer-train-position-embeddings: false
[2021-06-02 15:23:20] [config] tsv: false
[2021-06-02 15:23:20] [config] tsv-fields: 0
[2021-06-02 15:23:20] [config] type: s2s
[2021-06-02 15:23:20] [config] ulr: false
[2021-06-02 15:23:20] [config] ulr-dim-emb: 0
[2021-06-02 15:23:20] [config] ulr-dropout: 0
[2021-06-02 15:23:20] [config] ulr-keys-vectors: ""
[2021-06-02 15:23:20] [config] ulr-query-vectors: ""
[2021-06-02 15:23:20] [config] ulr-softmax-temperature: 1
[2021-06-02 15:23:20] [config] ulr-trainable-transformation: false
[2021-06-02 15:23:20] [config] unlikelihood-loss: false
[2021-06-02 15:23:20] [config] valid-freq: 5000
[2021-06-02 15:23:20] [config] valid-log: model.s2s-4.word/valid.log
[2021-06-02 15:23:20] [config] valid-max-length: 1000
[2021-06-02 15:23:20] [config] valid-metrics:
[2021-06-02 15:23:20] [config]   - cross-entropy
[2021-06-02 15:23:20] [config]   - perplexity
[2021-06-02 15:23:20] [config]   - bleu
[2021-06-02 15:23:20] [config] valid-mini-batch: 32
[2021-06-02 15:23:20] [config] valid-reset-stalled: false
[2021-06-02 15:23:20] [config] valid-script-args:
[2021-06-02 15:23:20] [config]   []
[2021-06-02 15:23:20] [config] valid-script-path: ""
[2021-06-02 15:23:20] [config] valid-sets:
[2021-06-02 15:23:20] [config]   - data_word/valid.en
[2021-06-02 15:23:20] [config]   - data_word/valid.my
[2021-06-02 15:23:20] [config] valid-translation-output: ""
[2021-06-02 15:23:20] [config] vocabs:
[2021-06-02 15:23:20] [config]   - data_word/vocab/vocab.en.yml
[2021-06-02 15:23:20] [config]   - data_word/vocab/vocab.my.yml
[2021-06-02 15:23:20] [config] word-penalty: 0
[2021-06-02 15:23:20] [config] word-scores: false
[2021-06-02 15:23:20] [config] workspace: 500
[2021-06-02 15:23:20] [config] Model is being created with Marian v1.10.0 6f6d4846 2021-02-06 15:35:16 -0800
[2021-06-02 15:23:20] Using synchronous SGD
[2021-06-02 15:23:20] [data] Loading vocabulary from JSON/Yaml file data_word/vocab/vocab.en.yml
[2021-06-02 15:23:20] [data] Setting vocabulary size for input 0 to 85,602
[2021-06-02 15:23:20] [data] Loading vocabulary from JSON/Yaml file data_word/vocab/vocab.my.yml
[2021-06-02 15:23:21] [data] Setting vocabulary size for input 1 to 63,471
[2021-06-02 15:23:21] [comm] Compiled without MPI support. Running as a single process on administrator-HP-Z2-Tower-G4-Workstation
[2021-06-02 15:23:21] [batching] Collecting statistics for batch fitting with step size 10
[2021-06-02 15:23:21] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-06-02 15:23:21] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-06-02 15:23:21] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-02 15:23:21] [comm] NCCLCommunicator constructed successfully
[2021-06-02 15:23:21] [training] Using 2 GPUs
[2021-06-02 15:23:21] [logits] Applying loss function for 1 factor(s)
[2021-06-02 15:23:21] [memory] Reserving 626 MB, device gpu0
[2021-06-02 15:23:22] [gpu] 16-bit TensorCores enabled for float32 matrix operations
[2021-06-02 15:23:22] [memory] Reserving 626 MB, device gpu0
[2021-06-02 15:23:53] [batching] Done. Typical MB size is 698 target words
[2021-06-02 15:23:53] [memory] Extending reserved space to 512 MB (device gpu0)
[2021-06-02 15:23:53] [memory] Extending reserved space to 512 MB (device gpu1)
[2021-06-02 15:23:53] [comm] Using NCCL 2.8.3 for GPU communication
[2021-06-02 15:23:53] [comm] NCCLCommunicator constructed successfully
[2021-06-02 15:23:53] [training] Using 2 GPUs
[2021-06-02 15:23:53] Training started
[2021-06-02 15:23:53] [data] Shuffling data
[2021-06-02 15:23:53] [data] Done reading 256,102 sentences
[2021-06-02 15:23:54] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 15:23:54] [training] Batches are processed as 1 process(es) x 2 devices/process
[2021-06-02 15:23:54] [memory] Reserving 626 MB, device gpu1
[2021-06-02 15:23:54] [memory] Reserving 626 MB, device gpu0
[2021-06-02 15:23:54] [memory] Reserving 626 MB, device gpu0
[2021-06-02 15:23:54] [memory] Reserving 626 MB, device gpu1
[2021-06-02 15:23:54] [memory] Reserving 313 MB, device gpu0
[2021-06-02 15:23:54] [memory] Reserving 313 MB, device gpu1
[2021-06-02 15:23:55] [memory] Reserving 626 MB, device gpu0
[2021-06-02 15:23:55] [memory] Reserving 626 MB, device gpu1
[2021-06-02 15:33:50] Ep. 1 : Up. 500 : Sen. 13,931 : Cost 7.42477036 * 258,947 after 258,947 : Time 597.22s : 433.59 words/s
[2021-06-02 15:43:39] Ep. 1 : Up. 1000 : Sen. 28,331 : Cost 6.11437225 * 255,570 after 514,517 : Time 589.22s : 433.74 words/s
[2021-06-02 15:53:38] Ep. 1 : Up. 1500 : Sen. 42,588 : Cost 5.59964657 * 255,879 after 770,396 : Time 598.64s : 427.44 words/s
[2021-06-02 16:03:26] Ep. 1 : Up. 2000 : Sen. 56,813 : Cost 5.32196188 * 257,937 after 1,028,333 : Time 588.10s : 438.59 words/s
[2021-06-02 16:13:14] Ep. 1 : Up. 2500 : Sen. 70,744 : Cost 5.17729187 * 254,074 after 1,282,407 : Time 588.26s : 431.91 words/s
[2021-06-02 16:22:59] Ep. 1 : Up. 3000 : Sen. 84,778 : Cost 5.05240250 * 256,204 after 1,538,611 : Time 584.91s : 438.02 words/s
[2021-06-02 16:32:49] Ep. 1 : Up. 3500 : Sen. 98,977 : Cost 4.95569420 * 257,597 after 1,796,208 : Time 590.09s : 436.54 words/s
[2021-06-02 16:42:37] Ep. 1 : Up. 4000 : Sen. 113,078 : Cost 4.87689066 * 257,875 after 2,054,083 : Time 587.17s : 439.18 words/s
[2021-06-02 16:52:20] Ep. 1 : Up. 4500 : Sen. 127,275 : Cost 4.79604292 * 256,839 after 2,310,922 : Time 583.38s : 440.26 words/s
[2021-06-02 17:02:05] Ep. 1 : Up. 5000 : Sen. 141,309 : Cost 4.72411251 * 255,799 after 2,566,721 : Time 585.32s : 437.02 words/s
[2021-06-02 17:02:05] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-02 17:02:08] Saving model weights and runtime parameters to model.s2s-4.word/model.iter5000.npz
[2021-06-02 17:02:09] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-02 17:02:12] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-02 17:02:26] [valid] Ep. 1 : Up. 5000 : cross-entropy : 211.724 : new best
[2021-06-02 17:02:33] [valid] Ep. 1 : Up. 5000 : perplexity : 338.249 : new best
[2021-06-02 17:02:33] Translating validation set...
[2021-06-02 17:02:37] [valid] [valid] First sentence's tokens as scored:
[2021-06-02 17:02:37] [valid] DefaultVocab keeps original segments for scoring
[2021-06-02 17:02:37] [valid] [valid]   Hyp: ဤ ပုဒ်မ ပါ ပြဋ္ဌာန်းချက် များ နှင့် အညီ ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:37] [valid] [valid]   Ref: ပါကစ္စတန် နိုင်ငံ ၏ ဝတ် ဇီရီစ တန် မြောက်ပိုင်း ရှိ ၊ လူ က ထိန်း ရန်မလို သော စစ် လေယာဉ် မှ ပစ်ခတ် ခြင်း အနေဖြင့် ယခု သတ်မှတ်ထား သော ၊ အမေရိကန် ပြည်ထောင်စု ဒုံးကျည် ဖြင့် ၊ သူ့ ကို ထိခိုက် စေ ခဲ့ သည် ဟု ထင်ကြေးပေး ခဲ့ ပြီးနောက် နောက်ထပ် အလွန် များပြား သော စစ်သွေးကြွ များ လည်း သေဆုံးကြောင်း သတင်းပို့ ခဲ့ သည် ။
[2021-06-02 17:02:44] Best translation 0 : သူ မ သည် ကျွန်ုပ် တို့ ၏ ကျန်းမာ ရေး ဆိုင်ရာ ကိစ္စရပ် များ နှင့် ပတ်သက် ၍ သူ တို့ ၏ ကျန်းမာ ရေး ဆိုင်ရာ ကိစ္စရပ် များ ကို ဆွေးနွေး ကြ သည် ။
[2021-06-02 17:02:44] Best translation 1 : ဤ ပုဒ်မ ပါ ပြဋ္ဌာန်းချက် များ နှင့် အညီ ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:44] Best translation 2 : မြန်မာ နိုင်ငံ ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် ဤ ပုဒ်မ ခွဲ (က) ပါ ပြဋ္ဌာန်းချက် များ ကို ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:44] Best translation 3 : သူ တို့ က သူ တို့ ရဲ့ အခွင့်အရေး တွေ နဲ့ ပတ်သက် လို့ သူ တို့ က ပြော တယ် ။
[2021-06-02 17:02:48] Best translation 4 : သူ မ သည် ကျွန်ုပ် တို့ ၏ အခန်း ထဲ သို့ သွား သည် ။
[2021-06-02 17:02:48] Best translation 5 : သူ တို့ က သူ တို့ ကို မ သိ ဘူး ။
[2021-06-02 17:02:48] Best translation 10 : နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် ဤ ပုဒ်မ ခွဲ (က) ပါ ပြဋ္ဌာန်းချက် များ နှင့်အညီ ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:48] Best translation 20 : နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် ဤ ပုဒ်မ ခွဲ (က) ပါ ပြဋ္ဌာန်းချက် များ နှင့်အညီ ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:48] Best translation 40 : သူ မ သည် သူ မ သည် ကျွန်ုပ် တို့ ၏ အခန်း ထဲ သို့ မ ဟုတ် ပါ
[2021-06-02 17:02:48] Best translation 80 : ဤ ပုဒ်မ ပါ ပြဋ္ဌာန်းချက် များ နှင့် အညီ ဆောင်ရွက် ရ မည် ။
[2021-06-02 17:02:48] Best translation 160 : နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် မြန်မာ နိုင်ငံ သို့ တက်ရောက် ခဲ့ သည် ။
[2021-06-02 17:02:51] Best translation 320 : ဒါ ကြောင့် ကျွန်တော် တို့ ပါတီ တွေ နဲ့ ပတ်သက် ပြီး သူ တို့ ရဲ့ အခွင့်အရေး တွေ နဲ့ ပတ်သက် လို့ ရ ပါ တယ် ။
[2021-06-02 17:03:15] Best translation 640 : နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် မြန်မာ နိုင်ငံ ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် မြန်မာ နိုင်ငံ သို့ တက်ရောက် ခဲ့ သည် ။
[2021-06-02 17:03:21] Total translation time: 47.45386s
[2021-06-02 17:03:21] [valid] Ep. 1 : Up. 5000 : bleu : 0.350518 : new best
[2021-06-02 17:13:14] Ep. 1 : Up. 5500 : Sen. 155,223 : Cost 4.67906046 * 257,179 after 2,823,900 : Time 668.64s : 384.63 words/s
[2021-06-02 17:22:52] Ep. 1 : Up. 6000 : Sen. 169,480 : Cost 4.63217402 * 257,901 after 3,081,801 : Time 578.23s : 446.02 words/s
[2021-06-02 17:32:37] Ep. 1 : Up. 6500 : Sen. 183,500 : Cost 4.56614685 * 254,940 after 3,336,741 : Time 584.62s : 436.08 words/s
[2021-06-02 17:42:22] Ep. 1 : Up. 7000 : Sen. 197,648 : Cost 4.51914597 * 258,218 after 3,594,959 : Time 585.48s : 441.04 words/s
[2021-06-02 17:52:10] Ep. 1 : Up. 7500 : Sen. 211,656 : Cost 4.47183704 * 258,753 after 3,853,712 : Time 587.63s : 440.33 words/s
[2021-06-02 18:01:52] Ep. 1 : Up. 8000 : Sen. 225,982 : Cost 4.43351698 * 258,553 after 4,112,265 : Time 582.09s : 444.18 words/s
[2021-06-02 18:11:38] Ep. 1 : Up. 8500 : Sen. 239,808 : Cost 4.40746212 * 254,981 after 4,367,246 : Time 586.33s : 434.88 words/s
[2021-06-02 18:21:19] Ep. 1 : Up. 9000 : Sen. 254,390 : Cost 4.33763647 * 258,951 after 4,626,197 : Time 580.80s : 445.86 words/s
[2021-06-02 18:22:14] Seen 255547 samples
[2021-06-02 18:22:14] Starting data epoch 2 in logical epoch 2
[2021-06-02 18:22:14] [data] Shuffling data
[2021-06-02 18:22:14] [data] Done reading 256,102 sentences
[2021-06-02 18:22:15] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 18:31:09] Ep. 2 : Up. 9500 : Sen. 12,872 : Cost 4.19884396 * 257,915 after 4,884,112 : Time 589.72s : 437.35 words/s
[2021-06-02 18:40:56] Ep. 2 : Up. 10000 : Sen. 26,924 : Cost 4.16887808 * 256,254 after 5,140,366 : Time 587.56s : 436.14 words/s
[2021-06-02 18:40:56] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-02 18:40:59] Saving model weights and runtime parameters to model.s2s-4.word/model.iter10000.npz
[2021-06-02 18:41:00] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-02 18:41:02] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-02 18:41:14] [valid] Ep. 2 : Up. 10000 : cross-entropy : 201.742 : new best
[2021-06-02 18:41:21] [valid] Ep. 2 : Up. 10000 : perplexity : 257.039 : new best
[2021-06-02 18:41:21] Translating validation set...
[2021-06-02 18:41:31] Best translation 0 : &quot; ကျွန်တော် တို့ က သူ တို့ ရဲ့ မိသားစု တွေ နဲ့ ပတ်သက် ပြီး သူ တို့ ရဲ့ အခွင့်အရေး တွေ နဲ့ ပတ်သက် ပြီး သူ တို့ ကို ကူညီ ဖို့ လိုအပ် ပါ တယ် ။
[2021-06-02 18:41:31] Best translation 1 : ၎င်း တို့ ၏ နိုင်ငံ ရေး ဆွေးနွေးပွဲ များ တွင် အမျိုးသမီး များ ၏ ကျန်းမာ ရေး ဆိုင်ရာ ကိစ္စရပ် များ နှင့် ပတ်သက် ၍ ဆွေးနွေး ညှိနှိုင်း မှု များ ပြုလုပ် ခဲ့ သည် ။
[2021-06-02 18:41:33] Best translation 2 : လူ တစ် ယောက် က အမျိုးသမီး တစ် ယောက် ဖြစ် ပါ တယ် ။
[2021-06-02 18:41:33] Best translation 3 : သူ တို့ က အမျိုးသမီး တစ် ယောက် ဖြစ် နေ ကြ တယ် ။
[2021-06-02 18:41:35] Best translation 4 : လူ တစ် ယောက် က လူ တစ် ယောက် ဖြစ် နေ တယ် ။
[2021-06-02 18:41:35] Best translation 5 : ဘာ ကြောင့် လဲ ဆို တော့ သူ တို့ က သူ့ ကို မ သိ ခဲ့ ပါ ဘူး ။
[2021-06-02 18:41:35] Best translation 10 : လွန် ခဲ့ သည့် နှစ် က နှစ် ပေါင်း များစွာ ကြာ ပြီးနောက် နှစ် ပေါင်း များစွာ ကြာ ပြီ ။
[2021-06-02 18:41:35] Best translation 20 : မန္တလေး တိုင်း ဒေသ ကြီး အစိုးရ အဖွဲ့ များ နှင့် တိုင်းရင်းသား လက်နက်ကိုင် အဖွဲ့အစည်း များ အကြား တိုက်ပွဲ များ ဖြစ်ပွား ခဲ့ သည် ။
[2021-06-02 18:41:35] Best translation 40 : သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ နဲ့ ပတ်သက် ပြီး သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ နဲ့ ပတ်သက် ပြီး သူ မ ကို တွေ့ ရ တယ် ။
[2021-06-02 18:41:35] Best translation 80 : မြန်မာ နိုင်ငံ တွင် အမျိုးသမီး များ ၏ ကျန်းမာ ရေး ဆိုင်ရာ ကိစ္စရပ် များ နှင့် ပတ်သက် ၍ မြန်မာ နိုင်ငံ ၏ ငြိမ်းချမ်း ရေး လုပ်ငန်းစဉ် တွင် ပါဝင် ဆောင်ရွက် လျက် ရှိ ပါ သည် ။
[2021-06-02 18:41:35] Best translation 160 : လွန် ခဲ့ သည့် နှစ် အတွင်း က ရန်ကုန် မြို့ သို့ ရောက်ရှိ လာ ခဲ့ သည် ။
[2021-06-02 18:41:39] Best translation 320 : &quot; ကျွန်တော် တို့ က မြန်မာ နိုင်ငံ မှာ ရှိ တဲ့ အမျိုးသမီး တစ် ယောက် ဖြစ် ပါ တယ် ။
[2021-06-02 18:42:03] Best translation 640 : နိုင်ငံတော် ၏ အတိုင်ပင်ခံ ပုဂ္ဂိုလ် ဒေါ်အောင်ဆန်းစုကြည် သည် ယနေ့ နံနက် ၁၀ နာရီ တွင် ကျင်းပ ခဲ့ သည် ။
[2021-06-02 18:42:08] Total translation time: 46.88902s
[2021-06-02 18:42:08] [valid] Ep. 2 : Up. 10000 : bleu : 0.803349 : new best
[2021-06-02 18:51:56] Ep. 2 : Up. 10500 : Sen. 41,134 : Cost 4.14340782 * 261,140 after 5,401,506 : Time 659.83s : 395.77 words/s
[2021-06-02 19:01:36] Ep. 2 : Up. 11000 : Sen. 55,490 : Cost 4.10983086 * 255,399 after 5,656,905 : Time 579.42s : 440.78 words/s
[2021-06-02 19:11:23] Ep. 2 : Up. 11500 : Sen. 69,640 : Cost 4.07952070 * 257,844 after 5,914,749 : Time 587.19s : 439.11 words/s
[2021-06-02 19:21:11] Ep. 2 : Up. 12000 : Sen. 83,616 : Cost 4.06699133 * 258,177 after 6,172,926 : Time 588.39s : 438.79 words/s
[2021-06-02 19:30:57] Ep. 2 : Up. 12500 : Sen. 97,707 : Cost 4.03612328 * 256,377 after 6,429,303 : Time 585.78s : 437.67 words/s
[2021-06-02 19:40:37] Ep. 2 : Up. 13000 : Sen. 112,080 : Cost 3.99399233 * 256,704 after 6,686,007 : Time 579.84s : 442.71 words/s
[2021-06-02 19:50:21] Ep. 2 : Up. 13500 : Sen. 126,265 : Cost 3.96555853 * 257,010 after 6,943,017 : Time 584.48s : 439.72 words/s
[2021-06-02 20:00:15] Ep. 2 : Up. 14000 : Sen. 139,995 : Cost 3.96679544 * 256,257 after 7,199,274 : Time 593.82s : 431.54 words/s
[2021-06-02 20:09:59] Ep. 2 : Up. 14500 : Sen. 154,116 : Cost 3.91159010 * 256,096 after 7,455,370 : Time 583.62s : 438.81 words/s
[2021-06-02 20:19:43] Ep. 2 : Up. 15000 : Sen. 168,144 : Cost 3.91438770 * 256,081 after 7,711,451 : Time 583.80s : 438.64 words/s
[2021-06-02 20:19:43] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-02 20:19:45] Saving model weights and runtime parameters to model.s2s-4.word/model.iter15000.npz
[2021-06-02 20:19:46] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-02 20:19:49] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-02 20:20:01] [valid] Ep. 2 : Up. 15000 : cross-entropy : 196.372 : new best
[2021-06-02 20:20:08] [valid] Ep. 2 : Up. 15000 : perplexity : 221.74 : new best
[2021-06-02 20:20:08] Translating validation set...
[2021-06-02 20:20:19] Best translation 0 : &quot; ကျွန်တော် တို့ က သူ တို့ ရဲ့ နိုင်ငံ ရေး ပါတီ တွေ နဲ့ ပတ်သက် လို့ သူ တို့ က ပြော တယ် ။
[2021-06-02 20:20:19] Best translation 1 : ဥပမာ အားဖြင့် - မြန်မာ စစ်တပ် က တိုက်ခိုက် မှု များ ဖြစ်ပွား ခဲ့ သည် ။
[2021-06-02 20:20:20] Best translation 2 : ဘာ ဖြစ် လို့ လဲ ဆို တော့ သူ က ဒီ ကိစ္စ နဲ့ ပတ်သက် လို့ သူ က ပြော တယ် ။
[2021-06-02 20:20:20] Best translation 3 : &quot; သူ တို့ က ဒီ ကိစ္စ နဲ့ ပတ်သက် လို့ သူ တို့ က ပြော တယ် ။
[2021-06-02 20:20:23] Best translation 4 : လူ တစ် ယောက် က ဒီ ကိစ္စ နဲ့ ပတ်သက် ပြီး အလုပ် လုပ် နေ တယ် ။
[2021-06-02 20:20:23] Best translation 5 : ဘာ ကြောင့် လဲ ဆို တော့ သူ တို့ က ဘာ ကို မှ မ သိ ဘူး ။
[2021-06-02 20:20:23] Best translation 10 : လွန် ခဲ့ သည့် နှစ် နာရီ ခန့် က နံနက် ၁၀ နာရီ တွင် နံနက် ၁၀ နာရီ တွင် ကျင်းပ ခဲ့ သည် ။
[2021-06-02 20:20:23] Best translation 20 : မန္တလေး တိုင်း ဒေသ ကြီး အစိုးရ အဖွဲ့ ဝင် များ နှင့် ပူးပေါင်း ဆောင်ရွက် လျက် ရှိ ပါ သည် ။
[2021-06-02 20:20:23] Best translation 40 : သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ ကို တွေ့ ခဲ့ ရ တယ် ။
[2021-06-02 20:20:23] Best translation 80 : ဥပမာ အားဖြင့် - မြန်မာ နိုင်ငံ ၏ စီးပွား ရေး လုပ်ငန်း များ ကို ဆက်လက် ဆောင်ရွက် လျက် ရှိ ပါ သည် ။
[2021-06-02 20:20:23] Best translation 160 : လွန် ခဲ့ သည့် နှစ် က နံနက် ၁၀ နာရီ တွင် ရန်ကုန် မြို့ သို့ ရောက်ရှိ ကြ သည် ။
[2021-06-02 20:20:28] Best translation 320 : &quot; ကျွန်မ တို့ ရဲ့ ဘဝ က တော့ ပို ကောင်း ပါ တယ် &quot; ဟု သူ က ပြော သည် ။
[2021-06-02 20:20:54] Best translation 640 : ပုဒ်မ ခွဲ (က) တွင် ဖော်ပြ ထား သည့် စာရင်း ရှင်းလင်း ဖျက်သိမ်းရေး အရာရှိ သည် ဤ ပုဒ်မ ပါ ပြဋ္ဌာန်းချက် များ ကို လိုက်နာ ရ မည် ။
[2021-06-02 20:20:59] Total translation time: 50.77478s
[2021-06-02 20:20:59] [valid] Ep. 2 : Up. 15000 : bleu : 1.04991 : new best
[2021-06-02 20:30:48] Ep. 2 : Up. 15500 : Sen. 182,044 : Cost 3.89500093 * 256,406 after 7,967,857 : Time 665.64s : 385.20 words/s
[2021-06-02 20:40:35] Ep. 2 : Up. 16000 : Sen. 196,429 : Cost 3.84406924 * 257,673 after 8,225,530 : Time 586.84s : 439.09 words/s
[2021-06-02 20:50:26] Ep. 2 : Up. 16500 : Sen. 210,285 : Cost 3.85128570 * 256,588 after 8,482,118 : Time 590.66s : 434.41 words/s
[2021-06-02 21:00:01] Ep. 2 : Up. 17000 : Sen. 224,874 : Cost 3.78193521 * 257,200 after 8,739,318 : Time 575.28s : 447.09 words/s
[2021-06-02 21:09:46] Ep. 2 : Up. 17500 : Sen. 238,850 : Cost 3.82080460 * 257,896 after 8,997,214 : Time 585.13s : 440.75 words/s
[2021-06-02 21:19:28] Ep. 2 : Up. 18000 : Sen. 253,361 : Cost 3.74054813 * 257,918 after 9,255,132 : Time 582.33s : 442.91 words/s
[2021-06-02 21:21:12] Seen 255547 samples
[2021-06-02 21:21:12] Starting data epoch 3 in logical epoch 3
[2021-06-02 21:21:12] [data] Shuffling data
[2021-06-02 21:21:12] [data] Done reading 256,102 sentences
[2021-06-02 21:21:13] [data] Done shuffling 256,102 sentences to temp files
[2021-06-02 21:29:11] Ep. 3 : Up. 18500 : Sen. 12,012 : Cost 3.60360312 * 256,574 after 9,511,706 : Time 583.02s : 440.08 words/s
[2021-06-02 21:39:03] Ep. 3 : Up. 19000 : Sen. 26,108 : Cost 3.58197546 * 258,652 after 9,770,358 : Time 591.52s : 437.27 words/s
[2021-06-02 21:48:45] Ep. 3 : Up. 19500 : Sen. 40,385 : Cost 3.52370405 * 256,635 after 10,026,993 : Time 581.81s : 441.10 words/s
[2021-06-02 21:58:31] Ep. 3 : Up. 20000 : Sen. 54,489 : Cost 3.52780843 * 257,620 after 10,284,613 : Time 585.99s : 439.63 words/s
[2021-06-02 21:58:31] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-02 21:58:33] Saving model weights and runtime parameters to model.s2s-4.word/model.iter20000.npz
[2021-06-02 21:58:34] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-02 21:58:37] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-02 21:58:49] [valid] Ep. 3 : Up. 20000 : cross-entropy : 190.75 : new best
[2021-06-02 21:58:56] [valid] Ep. 3 : Up. 20000 : perplexity : 189.973 : new best
[2021-06-02 21:58:56] Translating validation set...
[2021-06-02 21:59:09] Best translation 0 : &quot; ကျွန်တော် တို့ ဟာ သူ တို့ ရဲ့ အောင်မြင် မှု တွေ နဲ့ ပတ်သက် လို့ သူ က ပြော တယ် ။
[2021-06-02 21:59:09] Best translation 1 : သူ သည် လွန်ခဲ့သော နှစ် အတွင်း က လေး နှစ် ဦး သေဆုံး ခဲ့ ရ သည် ။
[2021-06-02 21:59:10] Best translation 2 : လူ တစ် ယောက် က လူ တစ် ယောက် ကို သတ် ခဲ့ တယ် လို့ ပြော တယ် ။
[2021-06-02 21:59:10] Best translation 3 : သူ တို့ က ဒီ ကိစ္စ နဲ့ ပတ်သက် လို့ သူ တို့ က ပြော တယ် ။
[2021-06-02 21:59:14] Best translation 4 : ယူ ပီ ဒဗလျူ စီ ၏ အဖွဲ့ ဝင် တစ် ဦး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-02 21:59:14] Best translation 5 : အစိုးရ က သူ့ ကို မ ပြော ရဲ ဘူး လို့ ပြော တယ် ။
[2021-06-02 21:59:14] Best translation 10 : တစ် နေ့ မှာ လေယာဉ် ပေါ် က တစ် နာရီ လောက် ကြာ မယ် ။
[2021-06-02 21:59:14] Best translation 20 : အက်စ် အမ် အီး အိုင်တီ အိုင် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အက်စ် အေ ၊ အက်စ် အေ ၊
[2021-06-02 21:59:14] Best translation 40 : သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ က သူ မ ရဲ့ မိဘ တွေ က သူ မ ကို အကူအညီ ပေး ခဲ့ တယ် ။
[2021-06-02 21:59:14] Best translation 80 : တစ် ဖက် တွင် ဖော်ပြ ထား သည့် စာရင်း ရှင်းလင်း ဖျက်သိမ်းရေး အရာရှိ တစ် ဦး ဦးစီ သည် ပြစ်ဒဏ် ပမာဏ ထက် မပိုသော ဒဏ်ငွေ ကို ပေးဆောင် ရ မည် ။
[2021-06-02 21:59:14] Best translation 160 : ဒုတိယ သမ္မတ က ရထား ပေါ် မှာ ရှိ တဲ့ ရထား က ရထား နဲ့ သွား မယ့် လေယာဉ် တွေ က ရထား နဲ့ သွား ခဲ့ တယ် ။
[2021-06-02 21:59:18] Best translation 320 : &quot; ကျွန်ုပ် တို့ သည် ဘဝ တစ်လျှောက်လုံး အတွက် အလွန် အရေးကြီး ပါ သည်
[2021-06-02 21:59:46] Best translation 640 : ပုဒ်မ ခွဲ (က) တွင် ဖော်ပြ ထား သည့် စာရင်း ရှင်းလင်း ဖျက်သိမ်းရေး အရာရှိ သည် ဤ ပုဒ်မ ပါ ပြဋ္ဌာန်းချက် များ ကို လိုက်နာ ဆောင်ရွက် ရ မည် ။
[2021-06-02 21:59:52] Total translation time: 55.48323s
[2021-06-02 21:59:52] [valid] Ep. 3 : Up. 20000 : bleu : 1.06379 : new best
[2021-06-02 22:09:39] Ep. 3 : Up. 20500 : Sen. 68,857 : Cost 3.50938702 * 258,933 after 10,543,546 : Time 668.22s : 387.50 words/s
[2021-06-02 22:19:25] Ep. 3 : Up. 21000 : Sen. 82,680 : Cost 3.49788642 * 257,181 after 10,800,727 : Time 585.80s : 439.02 words/s
[2021-06-02 22:29:09] Ep. 3 : Up. 21500 : Sen. 96,881 : Cost 3.45099044 * 257,070 after 11,057,797 : Time 584.31s : 439.95 words/s
[2021-06-02 22:38:56] Ep. 3 : Up. 22000 : Sen. 111,158 : Cost 3.40398073 * 258,332 after 11,316,129 : Time 586.38s : 440.55 words/s
[2021-06-02 22:48:42] Ep. 3 : Up. 22500 : Sen. 125,279 : Cost 3.41356683 * 259,450 after 11,575,579 : Time 586.66s : 442.25 words/s
[2021-06-02 22:58:27] Ep. 3 : Up. 23000 : Sen. 139,317 : Cost 3.41165066 * 255,865 after 11,831,444 : Time 584.91s : 437.44 words/s
[2021-06-02 23:08:15] Ep. 3 : Up. 23500 : Sen. 153,308 : Cost 3.40244102 * 257,356 after 12,088,800 : Time 588.38s : 437.39 words/s
[2021-06-02 23:17:58] Ep. 3 : Up. 24000 : Sen. 167,555 : Cost 3.35459781 * 256,187 after 12,344,987 : Time 582.96s : 439.46 words/s
[2021-06-02 23:27:47] Ep. 3 : Up. 24500 : Sen. 181,436 : Cost 3.34812284 * 256,787 after 12,601,774 : Time 588.41s : 436.41 words/s
[2021-06-02 23:37:32] Ep. 3 : Up. 25000 : Sen. 195,445 : Cost 3.31147528 * 255,430 after 12,857,204 : Time 585.66s : 436.14 words/s
[2021-06-02 23:37:32] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-02 23:37:35] Saving model weights and runtime parameters to model.s2s-4.word/model.iter25000.npz
[2021-06-02 23:37:36] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-02 23:37:39] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-02 23:37:51] [valid] Ep. 3 : Up. 25000 : cross-entropy : 182.365 : new best
[2021-06-02 23:37:58] [valid] Ep. 3 : Up. 25000 : perplexity : 150.842 : new best
[2021-06-02 23:37:58] Translating validation set...
[2021-06-02 23:38:10] Best translation 0 : &quot; သူ ဟာ သူ့ ရဲ့ အောင်မြင် မှု ကို ကျွန်တော် တို့ နားလည် ပါ တယ် ။
[2021-06-02 23:38:10] Best translation 1 : သူ က အမေရိကန် ပြည်ထောင်စု ကြံ့ခိုင်ရေး နှင့် ဖွံ့ဖြိုးရေး ဘဏ် (အေဒီဘီ) တို့ က ၎င်း တို့ ၏ တိုက်ခိုက် မှု များ ကြောင့် သေဆုံး ခဲ့ ရ သည် ဟု ဆို သည် ။
[2021-06-02 23:38:12] Best translation 2 : &quot; တစ် ဦး ချင်း စီ ကို ဖမ်းဆီး ခံ ရ သူ တစ် ဦး ဖြစ် သည် ဟု ပြော သည် ။
[2021-06-02 23:38:12] Best translation 3 : သူ တို့ က ဒီ ကိစ္စ နဲ့ ပတ်သက် ပြီး အတွေ့အကြုံ ရှိ တဲ့ သူ တစ် ဦး ဖြစ် တယ် &quot; ဟု ပြော သည် ။
[2021-06-02 23:38:14] Best translation 4 : တစ် ဦး ချင်း စီ ၏ အဖွဲ့ ဝင် တစ်ဦး ဖြစ် သည် ဟု ပြော သည် ။
[2021-06-02 23:38:14] Best translation 5 : အစိုးရ က သူ့ ကို မ သိ ဘူး လို့ ပြော တယ် ။
[2021-06-02 23:38:14] Best translation 10 : တနင်္လာ နေ့ မနက် ပိုင်း က တနင်္လာ နေ့ က မနက် ၉ နာရီ မှာ စတင် ခဲ့ တယ် ။
[2021-06-02 23:38:14] Best translation 20 : အမေရိကန် - မြန်မာ အပြည်ပြည် ဆိုင်ရာ အကြံပေး ကော်မရှင် အတွင်းရေးမှူး မစ္စ တာ ငု ယင် ဖူး ကျော င့် ဦးဆောင် သည့် ကိုယ်စားလှယ် အဖွဲ့အား လက်ခံ တွေ့ဆုံ သည် ။
[2021-06-02 23:38:14] Best translation 40 : သူ မ သည် သူ မ သည် သူ မ ကို အကူအညီ ပေး ၍ သူ မ ကို အကူအညီ ပေး ခဲ့ သည် ။
[2021-06-02 23:38:14] Best translation 80 : သတ်မှတ် ထား သည့် အရေအတွက် ထက် မပိုသော ဒဏ်ငွေ ကို ပေးဆောင် ရ မည် ဖြစ် ပါ သည် ။
[2021-06-02 23:38:14] Best translation 160 : ဒုတိယ အကြိမ် သည် မြန်မာ နိုင်ငံ သို့ ရောက်ရှိ နေ သည့် ရထား များ ကို ဖြတ် ၍ လမ်း များ ကို ဖြတ် ၍ ခရီးသွား ခဲ့ သည် ။
[2021-06-02 23:38:19] Best translation 320 : &quot; ကျွန်တော် တို့ ရဲ့ အစီအစဉ် တွေ ထဲ က တစ် ခု က တစ် ခု ခု ဖြစ် ပါ တယ် ။ ဒါ ကြောင့် ကျွန်တော် တို့ ရဲ့ ဘဝ ဟာ ဘဝ တစ်လျှောက်လုံး ပါ ပဲ ။
[2021-06-02 23:38:47] Best translation 640 : မောင်တော ဒေသ စံတော်ချိန် နံနက် ၁၀ နာရီ မှ ၁၀ နာရီ ခွဲ ခန့် တွင် သိမ်းဆည်း ခဲ့ သည် ။
[2021-06-02 23:38:52] Total translation time: 54.51445s
[2021-06-02 23:38:52] [valid] Ep. 3 : Up. 25000 : bleu : 2.03251 : new best
[2021-06-02 23:48:42] Ep. 3 : Up. 25500 : Sen. 209,762 : Cost 3.28345466 * 258,405 after 13,115,609 : Time 669.87s : 385.75 words/s
[2021-06-02 23:58:29] Ep. 3 : Up. 26000 : Sen. 223,946 : Cost 3.25267172 * 256,653 after 13,372,262 : Time 586.22s : 437.81 words/s
[2021-06-03 00:08:14] Ep. 3 : Up. 26500 : Sen. 238,004 : Cost 3.26408887 * 254,882 after 13,627,144 : Time 585.85s : 435.07 words/s
[2021-06-03 00:18:04] Ep. 3 : Up. 27000 : Sen. 252,182 : Cost 3.23812199 * 259,871 after 13,887,015 : Time 590.02s : 440.44 words/s
[2021-06-03 00:20:26] Seen 255547 samples
[2021-06-03 00:20:26] Starting data epoch 4 in logical epoch 4
[2021-06-03 00:20:26] [data] Shuffling data
[2021-06-03 00:20:26] [data] Done reading 256,102 sentences
[2021-06-03 00:20:27] [data] Done shuffling 256,102 sentences to temp files
[2021-06-03 00:27:49] Ep. 4 : Up. 27500 : Sen. 10,871 : Cost 3.06801677 * 257,838 after 14,144,853 : Time 584.70s : 440.97 words/s
[2021-06-03 00:37:35] Ep. 4 : Up. 28000 : Sen. 24,997 : Cost 3.06021810 * 259,641 after 14,404,494 : Time 585.57s : 443.40 words/s
[2021-06-03 00:47:19] Ep. 4 : Up. 28500 : Sen. 39,195 : Cost 3.02174616 * 258,164 after 14,662,658 : Time 584.59s : 441.62 words/s
[2021-06-03 00:56:58] Ep. 4 : Up. 29000 : Sen. 53,573 : Cost 2.97439027 * 254,798 after 14,917,456 : Time 578.45s : 440.49 words/s
[2021-06-03 01:06:41] Ep. 4 : Up. 29500 : Sen. 67,792 : Cost 3.00927353 * 256,245 after 15,173,701 : Time 582.98s : 439.55 words/s
[2021-06-03 01:16:29] Ep. 4 : Up. 30000 : Sen. 81,999 : Cost 3.01977110 * 257,383 after 15,431,084 : Time 588.66s : 437.23 words/s
[2021-06-03 01:16:29] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 01:16:32] Saving model weights and runtime parameters to model.s2s-4.word/model.iter30000.npz
[2021-06-03 01:16:33] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 01:16:36] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 01:16:47] [valid] Ep. 4 : Up. 30000 : cross-entropy : 175.234 : new best
[2021-06-03 01:16:55] [valid] Ep. 4 : Up. 30000 : perplexity : 123.975 : new best
[2021-06-03 01:16:55] Translating validation set...
[2021-06-03 01:17:09] Best translation 0 : &quot; သူ ရဲ့ ဆုံးရှုံး မှု အတွက် ကျွန်တော် တို့ ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ က ပြော သည် ။
[2021-06-03 01:17:09] Best translation 1 : သူ က အမေရိကန် ပြည်ထောင်စု ကြံ့ခိုင်ရေး နှင့် ဖွံ့ဖြိုးရေး ဘဏ် (အေဒီဘီ) တို့ က ဖမ်းဆီး ခံ ရ သူ တစ် ဦး ဖြစ် သည် ဟု စွပ်စွဲ ခံ ရ သူ တစ် ဦး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 01:17:09] Best translation 2 : &quot; ယာဉ် မတော်တဆ မှု တစ် ခု ဖြစ် လာ ခဲ့ တယ် လို့ ပါမောက္ခ ချဲ လင် ဂျာ ကပြော တယ် ။
[2021-06-03 01:17:09] Best translation 3 : &quot; သူ တို့ က လည်း ဒီလို ကိစ္စ တွေ ကို ဖြေရှင်း ဖို့ တာဝန် ရှိ တယ် &quot; ဟု ပြော သည် ။
[2021-06-03 01:17:12] Best translation 4 : အန် စီ စီတီ အဖွဲ့ ဝင် တစ်ဦး သည် အဆိုပါ အဖွဲ့ ဝင် တစ်ဦး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 01:17:12] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို မ သိ ခဲ့ ပေ ။
[2021-06-03 01:17:12] Best translation 10 : ၁၂ နာရီ ခွဲ ခန့် တွင် ယူရီ ကပြော လိုက် သည့် အတိုင်း အတာ တစ် ခု ကို စတင် ခဲ့ သည် ။
[2021-06-03 01:17:12] Best translation 20 : အမေရိကန် နိုင်ငံခြားရေး ဝန်ကြီး ဌာန မှ အမေရိကန် ဒေါ်လာ ၃ သန်း နှင့် အင်တာနက် စာမျက်နှာ များ တွင် ဖော်ပြ ထား သည့် သတင်း အချက်အလက် များ နှင့် မှတ်တမ်း များ ကို ရှင်းလင်း တင်ပြ သည် ။
[2021-06-03 01:17:12] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ ဆံပင် တွေ က သူ မ ကို ကူညီ ဖို့ ကြိုးစား ခဲ့ တယ် ၊ သူ မ ရဲ့ အကူအညီ က သူ မ ကို အကူအညီ ပေး ဖို့ ကြိုးစား ခဲ့ တယ် ။
[2021-06-03 01:17:12] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ တစ် ဦး အဖြစ် ရွေးကောက် တင်မြှောက် ခံ ရ သူ တစ် ဦး မှာ ရွေးကောက် တင်မြှောက် ခံ ရ သူ တစ် ဦး ဖြစ် သည် ။
[2021-06-03 01:17:12] Best translation 160 : ဒုတိယ အကြိမ် သည် အိန္ဒိယ သမုဒ္ဒရာ သို့ ရောက်ရှိ နေ သည့် မြန် မာ သင်္ဘော တစ်စင်း ကို ပိတ် ထား ခဲ့ သည် ။
[2021-06-03 01:17:19] Best translation 320 : &quot; ကျွန်မ တို့ ရဲ့ ထုတ်ကုန် တွေ ထဲ က တစ် ခု က တစ် ခု ဖြစ် ပါ တယ် ။ ဒါ ကြောင့် ကျွန်တော် တို့ ရဲ့ ဈေးနှုန်း တွေ အားလုံး ဟာ ဘဝ အတွက် အကောင်းဆုံး ဖြစ် ပါ တယ် ။
[2021-06-03 01:17:46] Best translation 640 : နံနက် ၉ နာရီ တွင် အရေးပေါ် အခြေအနေ များ ကို ရှင်းလင်း တင်ပြ သည် ။
[2021-06-03 01:17:53] Total translation time: 57.99985s
[2021-06-03 01:17:53] [valid] Ep. 4 : Up. 30000 : bleu : 2.91801 : new best
[2021-06-03 01:27:47] Ep. 4 : Up. 30500 : Sen. 95,926 : Cost 3.00533438 * 258,554 after 15,689,638 : Time 677.43s : 381.67 words/s
[2021-06-03 01:37:36] Ep. 4 : Up. 31000 : Sen. 110,049 : Cost 2.97049284 * 257,238 after 15,946,876 : Time 589.07s : 436.68 words/s
[2021-06-03 01:47:17] Ep. 4 : Up. 31500 : Sen. 124,246 : Cost 2.95517349 * 258,003 after 16,204,879 : Time 581.33s : 443.81 words/s
[2021-06-03 01:57:02] Ep. 4 : Up. 32000 : Sen. 138,559 : Cost 2.93555856 * 257,247 after 16,462,126 : Time 584.72s : 439.95 words/s
[2021-06-03 02:06:49] Ep. 4 : Up. 32500 : Sen. 152,380 : Cost 2.94924760 * 254,479 after 16,716,605 : Time 586.82s : 433.66 words/s
[2021-06-03 02:16:35] Ep. 4 : Up. 33000 : Sen. 166,448 : Cost 2.93534374 * 258,378 after 16,974,983 : Time 586.61s : 440.46 words/s
[2021-06-03 02:26:20] Ep. 4 : Up. 33500 : Sen. 180,797 : Cost 2.89568353 * 257,722 after 17,232,705 : Time 584.46s : 440.96 words/s
[2021-06-03 02:36:07] Ep. 4 : Up. 34000 : Sen. 194,773 : Cost 2.93213868 * 257,353 after 17,490,058 : Time 587.65s : 437.93 words/s
[2021-06-03 02:45:48] Ep. 4 : Up. 34500 : Sen. 209,263 : Cost 2.87859893 * 259,675 after 17,749,733 : Time 580.79s : 447.10 words/s
[2021-06-03 02:55:40] Ep. 4 : Up. 35000 : Sen. 222,919 : Cost 2.92345476 * 257,009 after 18,006,742 : Time 591.80s : 434.29 words/s
[2021-06-03 02:55:40] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 02:55:43] Saving model weights and runtime parameters to model.s2s-4.word/model.iter35000.npz
[2021-06-03 02:55:44] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 02:55:46] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 02:55:58] [valid] Ep. 4 : Up. 35000 : cross-entropy : 170.051 : new best
[2021-06-03 02:56:05] [valid] Ep. 4 : Up. 35000 : perplexity : 107.502 : new best
[2021-06-03 02:56:05] Translating validation set...
[2021-06-03 02:56:18] Best translation 0 : &quot; ကျွန်တော် တို့ ဟာ သူ့ ရဲ့ ဆုံးရှုံး မှု အတွက် ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ က ပြော သည် ။
[2021-06-03 02:56:18] Best translation 1 : သူ က အမေရိကန် ပြည်ထောင်စု ကြံ့ခိုင်ရေး နှင့် ဖွံ့ဖြိုးရေး ဘဏ် (အေဒီဘီ) တို့ က ဖမ်းဆီး ခံ ထား ရ သူ တစ် ဦး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 02:56:19] Best translation 2 : အမ် အန် ဒီ အေအေ အဖွဲ့ က သတင်း ထုတ်ပြန် လိုက် သည် ။
[2021-06-03 02:56:19] Best translation 3 : &quot; သူ တို့ က လည်း ကောင်း မွန် တဲ့ ပုဂ္ဂိုလ် တစ် ဦး ဖြစ် တယ် &quot; ဟု ပြော သည် ။
[2021-06-03 02:56:22] Best translation 4 : အန် စီ စီတီ အဖွဲ့ ဝင် တစ်ဦး အနေဖြင့် အဆိုပါ အဖွဲ့ ဝင် တစ်ဦး ဖြစ် လာ ခဲ့ သည် ဟု ဆို သည် ။
[2021-06-03 02:56:22] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို မ သိ ခဲ့ ပေ ။
[2021-06-03 02:56:22] Best translation 10 : ၁၂ နာရီ ခွဲ ခန့် တွင် ယူရီ သည် တစ်နာရီ အတွင်း စောစော ရောက် လာ ခဲ့ သည် ။
[2021-06-03 02:56:22] Best translation 20 : အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမ် အန် ဒီ အေအေ ၊ အမ် အန် ဒီ အေအေ ၊ အမ် အန် ဒီ အေအေ တို့ ပါဝင် သည် ။
[2021-06-03 02:56:22] Best translation 40 : ထို အချိန် တွင် သူ မ သည် သူမ ၏ အကူအညီ ဖြင့် သူ မ ကို အကူအညီ ပေး ရန် ကြိုးစား ခဲ့ သည် ။
[2021-06-03 02:56:22] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရ ရှိ သူ များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ တစ် ဦး အဖြစ် ရွေးကောက် တင်မြှောက် ခံပိုင် ခွင့် ရှိ သည် ။
[2021-06-03 02:56:22] Best translation 160 : ဒုတိယ ကမ္ဘာစစ် သည် အိန္ဒိယ နိုင်ငံ အလယ်ပိုင်း ဒေသ စံတော်ချိန် နံနက် ၁၀ နာရီ ၁၅ မိနစ် တွင် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 02:56:27] Best translation 320 : &quot; ကျွန်တော် တို့ ရဲ့ ဖောက်သည် တွေ ထဲ က တစ် ခု က တစ် ခု ခု ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က တစ် ခု ခု ရ ခဲ့ ပါ တယ် ။
[2021-06-03 02:56:56] Best translation 640 : အင်းစိန် အကျဉ်းထောင် တွင် အရေးပေါ် အခြေအနေ ကို လက်ခံ ရရှိ ခဲ့ သည် ။
[2021-06-03 02:57:04] Total translation time: 58.38464s
[2021-06-03 02:57:04] [valid] Ep. 4 : Up. 35000 : bleu : 3.51917 : new best
[2021-06-03 03:06:51] Ep. 4 : Up. 35500 : Sen. 237,018 : Cost 2.88610125 * 256,477 after 18,263,219 : Time 671.20s : 382.12 words/s
[2021-06-03 03:16:33] Ep. 4 : Up. 36000 : Sen. 251,161 : Cost 2.87094998 * 256,048 after 18,519,267 : Time 581.85s : 440.06 words/s
[2021-06-03 03:19:33] Seen 255547 samples
[2021-06-03 03:19:33] Starting data epoch 5 in logical epoch 5
[2021-06-03 03:19:33] [data] Shuffling data
[2021-06-03 03:19:33] [data] Done reading 256,102 sentences
[2021-06-03 03:19:34] [data] Done shuffling 256,102 sentences to temp files
[2021-06-03 03:26:11] Ep. 5 : Up. 36500 : Sen. 9,937 : Cost 2.72528529 * 256,102 after 18,775,369 : Time 577.89s : 443.17 words/s
[2021-06-03 03:36:03] Ep. 5 : Up. 37000 : Sen. 23,825 : Cost 2.67405081 * 257,989 after 19,033,358 : Time 592.37s : 435.52 words/s
[2021-06-03 03:45:44] Ep. 5 : Up. 37500 : Sen. 38,104 : Cost 2.64869380 * 256,023 after 19,289,381 : Time 580.28s : 441.21 words/s
[2021-06-03 03:55:33] Ep. 5 : Up. 38000 : Sen. 51,929 : Cost 2.66107225 * 255,349 after 19,544,730 : Time 589.68s : 433.03 words/s
[2021-06-03 04:05:13] Ep. 5 : Up. 38500 : Sen. 66,478 : Cost 2.64474273 * 258,469 after 19,803,199 : Time 580.08s : 445.57 words/s
[2021-06-03 04:15:02] Ep. 5 : Up. 39000 : Sen. 80,592 : Cost 2.65897179 * 261,138 after 20,064,337 : Time 588.10s : 444.03 words/s
[2021-06-03 04:24:44] Ep. 5 : Up. 39500 : Sen. 94,799 : Cost 2.63200092 * 255,053 after 20,319,390 : Time 582.85s : 437.60 words/s
[2021-06-03 04:34:36] Ep. 5 : Up. 40000 : Sen. 108,874 : Cost 2.65264225 * 259,018 after 20,578,408 : Time 591.15s : 438.16 words/s
[2021-06-03 04:34:36] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 04:34:38] Saving model weights and runtime parameters to model.s2s-4.word/model.iter40000.npz
[2021-06-03 04:34:39] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 04:34:41] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 04:34:53] [valid] Ep. 5 : Up. 40000 : cross-entropy : 166.034 : new best
[2021-06-03 04:35:00] [valid] Ep. 5 : Up. 40000 : perplexity : 96.2571 : new best
[2021-06-03 04:35:00] Translating validation set...
[2021-06-03 04:35:14] Best translation 0 : &quot; ကျွန်တော် တို့ ဟာ သူ့ ရဲ့ ဆုံးရှုံး မှု အတွက် ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ က သူ့ ကို ရန်သူ ၏ ရန်သူ နှင့် ဘာသာ ရေး ကို အသိအမှတ်ပြု မည် ဟု ဆို သည် ။
[2021-06-03 04:35:14] Best translation 1 : သူ က အမေရိကန် ပြည်ထောင်စု ကြံ့ခိုင်ရေး နှင့် ဖွံ့ဖြိုးရေး ဘဏ် မှ လွတ်မြောက် လာ သည့် အမေရိကန် လေကြောင်း လိုင်း တစ်ခု မှ လွတ်မြောက် ခဲ့ သည် ဟု ၎င်း က ဆို သည် ။
[2021-06-03 04:35:14] Best translation 2 : အမ် အန် ဒီ အေအေ အဖွဲ့ က သတင်း ထုတ်ပြန် လိုက် သည် ။
[2021-06-03 04:35:14] Best translation 3 : &quot; သူ တို့ က လည်း ငြိမ်းချမ်းရေး နှင့် အစားထိုး သီးနှံ စိုက်ပျိုး ရေး လုပ်ငန်း တစ် ခု ရှိ တယ် &quot; ဟု ဆို သည် ။
[2021-06-03 04:35:18] Best translation 4 : အာ စီ အက်စ် အက်စ် အဖွဲ့ ဝင် တစ်ဦး အနေဖြင့် အဆိုပါ အဖွဲ့ ဝင် ၏ တတိယ အများဆုံး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 04:35:18] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို မ သိ ခဲ့ ပေ ။
[2021-06-03 04:35:18] Best translation 10 : ၁၂ နာရီ ခွဲ ခန့် တွင် အောင်ဝင်းခိုင် ထံမှ သေနတ် ဖြင့် ပစ်ခတ် ခဲ့ သည် ။
[2021-06-03 04:35:18] Best translation 20 : အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အမ် အန် ဒီ အေအေ တို့ ၏ သုတေသန သုတေသန နှင့် အချက်အလက် များ ကို ပြသ ခဲ့ သည် ။
[2021-06-03 04:35:18] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ကြောင့် သူ မ ရဲ့ အကူအညီ က သူ မ ကို အကူအညီ ပေး ဖို့ ကြိုးစား ခဲ့ တယ် ။
[2021-06-03 04:35:18] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရ ရှိ သူ များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ များ အနက် အနည်းဆုံး ၁၀ ရာခိုင်နှုန်း သာ လိုအပ် ပါ သည် ။
[2021-06-03 04:35:18] Best translation 160 : ဒုတိယ ကမ္ဘာစစ် သည် အိန္ဒိယ သမုဒ္ဒရာ မီးရထား ဘူတာရုံ သို့ ရောက် ရှိ ခဲ့ပြီး အိန္ဒိယ သမုဒ္ဒရာ ရထား ပေါ် တွင် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 04:35:24] Best translation 320 : &quot; ကျွန်မ တို့ ရဲ့ ဖောက်သည် တွေ ထဲ က တစ် ခု က တစ် ခု ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က တစ် ခု ခု ရ ခဲ့ ပါ တယ် ။ အဲဒါ က ဘဝ အတွက် အဓိက ဖြစ် ပါ တယ် ။
[2021-06-03 04:35:51] Best translation 640 : နံနက် ၇ နာရီ ၄၅ မိနစ် မှာ အရေးပေါ် အခြေအနေ ကို လက်ခံ ရရှိ ခဲ့ ပါ တယ် ။
[2021-06-03 04:35:59] Total translation time: 58.22516s
[2021-06-03 04:35:59] [valid] Ep. 5 : Up. 40000 : bleu : 4.18471 : new best
[2021-06-03 04:45:48] Ep. 5 : Up. 40500 : Sen. 123,184 : Cost 2.67034769 * 259,199 after 20,837,607 : Time 672.54s : 385.40 words/s
[2021-06-03 04:55:38] Ep. 5 : Up. 41000 : Sen. 137,199 : Cost 2.65536928 * 258,498 after 21,096,105 : Time 589.68s : 438.37 words/s
[2021-06-03 05:05:14] Ep. 5 : Up. 41500 : Sen. 151,506 : Cost 2.61266565 * 255,412 after 21,351,517 : Time 576.54s : 443.01 words/s
[2021-06-03 05:15:02] Ep. 5 : Up. 42000 : Sen. 165,443 : Cost 2.65113616 * 259,012 after 21,610,529 : Time 588.20s : 440.35 words/s
[2021-06-03 05:24:47] Ep. 5 : Up. 42500 : Sen. 179,496 : Cost 2.62463164 * 254,832 after 21,865,361 : Time 584.89s : 435.69 words/s
[2021-06-03 05:34:32] Ep. 5 : Up. 43000 : Sen. 193,736 : Cost 2.61460638 * 257,097 after 22,122,458 : Time 584.70s : 439.71 words/s
[2021-06-03 05:44:17] Ep. 5 : Up. 43500 : Sen. 207,791 : Cost 2.64609885 * 258,709 after 22,381,167 : Time 584.57s : 442.56 words/s
[2021-06-03 05:54:01] Ep. 5 : Up. 44000 : Sen. 221,810 : Cost 2.60887098 * 257,424 after 22,638,591 : Time 584.26s : 440.60 words/s
[2021-06-03 06:03:47] Ep. 5 : Up. 44500 : Sen. 236,195 : Cost 2.59936833 * 256,955 after 22,895,546 : Time 585.86s : 438.60 words/s
[2021-06-03 06:13:35] Ep. 5 : Up. 45000 : Sen. 250,172 : Cost 2.62177777 * 256,603 after 23,152,149 : Time 588.42s : 436.09 words/s
[2021-06-03 06:13:35] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 06:13:38] Saving model weights and runtime parameters to model.s2s-4.word/model.iter45000.npz
[2021-06-03 06:13:39] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 06:13:41] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 06:13:53] [valid] Ep. 5 : Up. 45000 : cross-entropy : 162.862 : new best
[2021-06-03 06:14:00] [valid] Ep. 5 : Up. 45000 : perplexity : 88.2132 : new best
[2021-06-03 06:14:01] Translating validation set...
[2021-06-03 06:14:13] Best translation 0 : &quot; ကျွန်တော် တို့ ဟာ သူ့ ရဲ့ ဆုံးရှုံး မှု အတွက် ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ က ရန်သူ နှင့် ဘာသာ ရေး ကို အသိအမှတ်ပြု မည် ဟု ဆို သည် ။
[2021-06-03 06:14:13] Best translation 1 : ၎င်း ကို အမေရိကန်ပြည်ထောင်စု က ထုတ်ပြန် ခဲ့ သည့် အမေရိကန် လေကြောင်း လိုင်း တစ်ခု မှ လွတ်မြောက် လာ သည့် အမေရိကန် လေကြောင်း လိုင်း တစ်ခု မှ လွတ်မြောက် လာ ခဲ့ သည် ဟု ၎င်း က ဆို သည် ။
[2021-06-03 06:14:14] Best translation 2 : &quot; ယာဉ် မတော်တဆ မှု က ယာဉ် တစ်စီး နဲ့ ပစ် လိုက် ရ တယ် &quot; ဟု ပါကစ္စတန် က ပြော သည် ။
[2021-06-03 06:14:14] Best translation 3 : &quot; သူ တို့ က လည်း ကောင်း မွန် တဲ့ အလုပ် တွေ ကို လုပ် ရ မယ့် စွမ်းရည် ရှိ တယ် &quot; ဟု ဆို သည် ။
[2021-06-03 06:14:17] Best translation 4 : အာ စီ အက်စ် အက်စ် အဖွဲ့ ဝင် တစ်ဦး အနေဖြင့် ၎င်း ၏ တတိယ မြောက် အမြင့်ဆုံး အဆင့် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 06:14:17] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို မ သိ ခဲ့ ပေ ။
[2021-06-03 06:14:17] Best translation 10 : ၁၂ နာရီ ခွဲ ခန့် တွင် အောင်ဝင်းခိုင် ထံမှ သေနတ် ဖြင့် ပစ်ခတ် ခဲ့ သည် ။
[2021-06-03 06:14:17] Best translation 20 : အမေရိကန် ကုန်သွယ် ရေး ဌာန တစ် ခု က ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် ဘေကျင်း လုပ်ငန်း ဆိုင်ရာ သုတေသန ဌာန တစ် ခု ဖြစ် သည် ။
[2021-06-03 06:14:17] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ကြောင့် သူ မ ရဲ့ အကူအညီ က သူ မ ကို အကူအညီ ပေး ဖို့ ကြိုးစား ခဲ့ တယ် ။
[2021-06-03 06:14:17] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရ ရှိ သူ များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ များ အားလုံး သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သည် ။
[2021-06-03 06:14:17] Best translation 160 : ဒုတိယ မြောက် အရှေ့တောင် အာရှ ဒေသ စံတော်ချိန် နံနက် ၁၀ နာရီ ၁၅ မိနစ် တွင် အိန္ဒိယ လေကြောင်း လိုင်း က အသုံးပြု ခဲ့ သည် ။
[2021-06-03 06:14:23] Best translation 320 : &quot; ကျွန်မ တို့ ရဲ့ ပုံစံ တွေ ထဲ က တစ် ခု ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ ထဲ က တစ် ခု က တစ် ခု ခု ဖြစ် ပါ တယ် ။
[2021-06-03 06:14:51] Best translation 640 : ပင်လယ် ရေကြောင်း သယ်ယူ ပို့ဆောင် ရေး အဖွဲ့ က အရေးပေါ် အခြေအနေ ကို လက်ခံ ရရှိ ခဲ့ သည် ။
[2021-06-03 06:14:57] Total translation time: 56.96962s
[2021-06-03 06:14:57] [valid] Ep. 5 : Up. 45000 : bleu : 4.63948 : new best
[2021-06-03 06:18:39] Seen 255547 samples
[2021-06-03 06:18:39] Starting data epoch 6 in logical epoch 6
[2021-06-03 06:18:39] [data] Shuffling data
[2021-06-03 06:18:39] [data] Done reading 256,102 sentences
[2021-06-03 06:18:39] [data] Done shuffling 256,102 sentences to temp files
[2021-06-03 06:24:42] Ep. 6 : Up. 45500 : Sen. 8,741 : Cost 2.46026874 * 255,662 after 23,407,811 : Time 666.51s : 383.58 words/s
[2021-06-03 06:34:34] Ep. 6 : Up. 46000 : Sen. 22,598 : Cost 2.38570666 * 256,761 after 23,664,572 : Time 592.03s : 433.70 words/s
[2021-06-03 06:44:17] Ep. 6 : Up. 46500 : Sen. 36,883 : Cost 2.38541722 * 255,444 after 23,920,016 : Time 583.73s : 437.60 words/s
[2021-06-03 06:54:02] Ep. 6 : Up. 47000 : Sen. 51,066 : Cost 2.40148687 * 257,716 after 24,177,732 : Time 584.42s : 440.98 words/s
[2021-06-03 07:03:40] Ep. 6 : Up. 47500 : Sen. 65,407 : Cost 2.37032461 * 257,377 after 24,435,109 : Time 577.72s : 445.50 words/s
[2021-06-03 07:13:31] Ep. 6 : Up. 48000 : Sen. 79,359 : Cost 2.38755608 * 256,412 after 24,691,521 : Time 591.75s : 433.31 words/s
[2021-06-03 07:23:13] Ep. 6 : Up. 48500 : Sen. 93,671 : Cost 2.38578987 * 256,532 after 24,948,053 : Time 581.17s : 441.41 words/s
[2021-06-03 07:32:59] Ep. 6 : Up. 49000 : Sen. 107,748 : Cost 2.40662932 * 259,609 after 25,207,662 : Time 586.82s : 442.40 words/s
[2021-06-03 07:42:42] Ep. 6 : Up. 49500 : Sen. 121,844 : Cost 2.39366794 * 257,149 after 25,464,811 : Time 582.89s : 441.16 words/s
[2021-06-03 07:52:29] Ep. 6 : Up. 50000 : Sen. 135,971 : Cost 2.42277598 * 259,503 after 25,724,314 : Time 586.67s : 442.33 words/s
[2021-06-03 07:52:29] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 07:52:31] Saving model weights and runtime parameters to model.s2s-4.word/model.iter50000.npz
[2021-06-03 07:52:32] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 07:52:35] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 07:52:46] [valid] Ep. 6 : Up. 50000 : cross-entropy : 160.797 : new best
[2021-06-03 07:52:54] [valid] Ep. 6 : Up. 50000 : perplexity : 83.3422 : new best
[2021-06-03 07:52:54] Translating validation set...
[2021-06-03 07:53:06] Best translation 0 : သူ့ ရဲ့ ဆုံးရှုံး မှု အတွက် ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ ၏ ဆုံးရှုံး မှု များ နှင့် ဘာသာ ရေး ကို ကာကွယ် နိုင် မည် ဖြစ် သည် ။
[2021-06-03 07:53:06] Best translation 1 : သူ သည် ပါကစ္စတန် နိုင်ငံ ၏ မြောက် ပိုင်း စစ်ဌာနချုပ် မှ ထုတ်ပယ် ခံ ရ ခြင်း ဖြစ် ပြီး ပါကစ္စတန် နိုင်ငံ ၏ မြောက် ပိုင်း စစ်ဌာနချုပ် မှ လွတ်မြောက် လာ သည့် အမေရိကန် လေကြောင်း လိုင်း တစ်ခု မှ လွတ်မြောက် ခဲ့ ခြင်း ဖြစ် သည် ။
[2021-06-03 07:53:06] Best translation 2 : &quot; ယာဉ် မတော်တဆ မှု က ယာဉ် တစ်စီး နဲ့ ပစ် လိုက် ရ တယ် &quot; ဟု ပါကစ္စတန် လူမျိုး အရာရှိ တစ် ဦး က ပြော သည် ။
[2021-06-03 07:53:06] Best translation 3 : &quot; သူ တို့ က လည်း ဒီလို လုပ် ရ မယ့် စွမ်းရည် ရှိ တယ် ဆို တဲ့ အရည်အချင်း ရှိ တယ် &quot; ဟု အနောက် ပိုင်း ဆိုင်ရာ သိပ္ပံ ပညာရှင် တစ် ဦး က ပြော သည် ။
[2021-06-03 07:53:10] Best translation 4 : ဘေးလ် ဝှိုက် ရဲ့ တတိယ မြောက် အကြီးဆုံး ရာထူး ဖြစ် ပါ တယ် ။
[2021-06-03 07:53:10] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို မ သိ ခဲ့ ပေ ။
[2021-06-03 07:53:10] Best translation 10 : ၁၂ နာရီ ခွဲ ခန့် တွင် အောင်ဝင်းခိုင် ထံမှ သေနတ် ဖြင့် ပစ်ခတ် ခဲ့ သည် ။
[2021-06-03 07:53:10] Best translation 20 : ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကုန်သွယ်ရေး ဌာန တစ် ခု ဖြစ် သည့် ၂၀၀၆ ခုနှစ် ၊ ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကူးသန်း ရောင်းဝယ်ရေး ဌာန တစ် ခု က သုတေသန နှင့် ဈေးကွက် ဆိုင်ရာ အချက်အလက် များ ကို သုတေသန ပြုလုပ် ခဲ့ သည် ။
[2021-06-03 07:53:10] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ကြောင့် သူ မ ရဲ့ အကူအညီ ကို ရယူ ဖို့ ကြိုးစား ခဲ့ တဲ့ လူ နှစ် ယောက် က သူ့ ကို ရိုက်နှက် ခဲ့ တယ် ။
[2021-06-03 07:53:10] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရ ရှိ သူ များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ များ အား ရာထူး မှ နုတ်ထွက် ရန် တာဝန် ရှိ သည် ။
[2021-06-03 07:53:10] Best translation 160 : ဒုတိယ မြောက် အရှေ့တောင် အာရှ ဒေသ စံတော်ချိန် နံနက် ၁၀ နာရီ ၁၅ မိနစ် တွင် အိန္ဒိယ လေကြောင်း ခရီးစဉ် ဖြင့် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 07:53:16] Best translation 320 : ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ ထဲ မှာ နမူနာ တွေ ပါ ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ က ဈေးနှုန်း တွေ ပါ ။
[2021-06-03 07:53:45] Best translation 640 : ဘူတာရုံ မှ ညနေ ၇ နာရီ တွင် အရေးပေါ် အခြေအနေ ကို လက်ခံ ရရှိ ခဲ့ ပါ သည် ။
[2021-06-03 07:53:51] Total translation time: 57.22345s
[2021-06-03 07:53:51] [valid] Ep. 6 : Up. 50000 : bleu : 4.92561 : new best
[2021-06-03 08:03:32] Ep. 6 : Up. 50500 : Sen. 150,567 : Cost 2.37762213 * 258,425 after 25,982,739 : Time 662.73s : 389.94 words/s
[2021-06-03 08:13:19] Ep. 6 : Up. 51000 : Sen. 164,814 : Cost 2.41410589 * 260,110 after 26,242,849 : Time 586.92s : 443.18 words/s
[2021-06-03 08:23:11] Ep. 6 : Up. 51500 : Sen. 178,640 : Cost 2.40461063 * 257,033 after 26,499,882 : Time 592.52s : 433.79 words/s
[2021-06-03 08:32:58] Ep. 6 : Up. 52000 : Sen. 192,741 : Cost 2.38806009 * 257,245 after 26,757,127 : Time 587.15s : 438.13 words/s
[2021-06-03 08:42:38] Ep. 6 : Up. 52500 : Sen. 206,938 : Cost 2.39213943 * 256,916 after 27,014,043 : Time 580.24s : 442.77 words/s
[2021-06-03 08:52:29] Ep. 6 : Up. 53000 : Sen. 221,153 : Cost 2.39515185 * 257,912 after 27,271,955 : Time 590.09s : 437.08 words/s
[2021-06-03 09:02:15] Ep. 6 : Up. 53500 : Sen. 235,421 : Cost 2.38340688 * 259,057 after 27,531,012 : Time 586.17s : 441.95 words/s
[2021-06-03 09:12:01] Ep. 6 : Up. 54000 : Sen. 249,517 : Cost 2.38813019 * 257,021 after 27,788,033 : Time 586.17s : 438.48 words/s
[2021-06-03 09:16:12] Seen 255547 samples
[2021-06-03 09:16:12] Starting data epoch 7 in logical epoch 7
[2021-06-03 09:16:12] [data] Shuffling data
[2021-06-03 09:16:12] [data] Done reading 256,102 sentences
[2021-06-03 09:16:12] [data] Done shuffling 256,102 sentences to temp files
[2021-06-03 09:21:51] Ep. 7 : Up. 54500 : Sen. 7,783 : Cost 2.27497935 * 257,065 after 28,045,098 : Time 590.60s : 435.26 words/s
[2021-06-03 09:31:37] Ep. 7 : Up. 55000 : Sen. 22,027 : Cost 2.17088056 * 256,243 after 28,301,341 : Time 585.33s : 437.77 words/s
[2021-06-03 09:31:37] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-03 09:31:39] Saving model weights and runtime parameters to model.s2s-4.word/model.iter55000.npz
[2021-06-03 09:31:40] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-03 09:31:43] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 09:31:55] [valid] Ep. 7 : Up. 55000 : cross-entropy : 159.093 : new best
[2021-06-03 09:32:02] [valid] Ep. 7 : Up. 55000 : perplexity : 79.5272 : new best
[2021-06-03 09:32:02] Translating validation set...
[2021-06-03 09:32:14] Best translation 0 : &quot; သူ ဆုံးရှုံး သွား တာ ကို ကျွန်တော် တို့ ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ ၏ ဆုံးရှုံး မှု များ နှင့် ဘာသာ ရေး ကို ကာကွယ် နိုင် မည် ဖြစ် သည် ။
[2021-06-03 09:32:14] Best translation 1 : သူ သည် ပါကစ္စတန် ၏ မြောက် ပိုင်း စစ်ဌာနချုပ် မှ ထုတ်ပယ် ခံ ရ ခြင်း ဖြစ် ပြီး ပါကစ္စတန် နိုင်ငံ ၏ မြောက် ပိုင်း စစ်ဌာနချုပ် မှ ထုတ်ပယ် ခံ ရ ခြင်း ဖြစ် သည် ဟု ၎င်း က ဆို သည် ။
[2021-06-03 09:32:15] Best translation 2 : အဆိုပါ ဒုံးပျံ သည် ယာဉ် တစ်စီး ဖြင့် ပစ်ခတ် ခံ ရ ခြင်း ဖြစ် သည် ဟု ပါကစ္စတန် အကြီးတန်း အရာရှိ တစ် ဦး က ပြော သည် ။
[2021-06-03 09:32:15] Best translation 3 : &quot; သူ တို့ က ဒီ လူ တွေ ကို ကျွမ်းကျင် ဖို့ စွမ်းရည် ရှိ တယ် &quot; ဟု အနောက် ပိုင်း ဆိုင်ရာ သိပ္ပံ ပညာရှင် တစ် ဦး က ဆို သည် ။
[2021-06-03 09:32:18] Best translation 4 : အယ် အေ ဒီ အက်ဖ် အဖွဲ့ ဝင် တစ် ဦး ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 09:32:18] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ့ သေဆုံး မှု အကြောင်း ကို မ သိ ဘူး လို့ ပါကစ္စတန် အစိုးရ က ပြော တယ် ။
[2021-06-03 09:32:18] Best translation 10 : နောက် ၁ နာရီ ခွဲ လောက် မှာ ဝေါ လ် ပီမာဆူဒီ က ဂိုး တစ်ဝက် လောက် မှာ ပစ်ခတ် ခဲ့ တယ် ။
[2021-06-03 09:32:18] Best translation 20 : အမေရိကန် ကူးသန်း ရောင်းဝယ်ရေး ဌာန တစ် ခု ဖြစ် သည့် ၂၀၀၆ ခုနှစ် ၊ ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု က သုတေသန နှင့် နည်းပညာ ဆိုင်ရာ အချက်အလက် များ ကို သုတေသန ပြုလုပ် သည် ။
[2021-06-03 09:32:18] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ပေး ဖို့ ကြိုးစား ခဲ့ တဲ့ သေနတ်သမား နှစ် ယောက် က သူ့ ကို ရိုက်နှက် ခဲ့ တယ် ။
[2021-06-03 09:32:18] Best translation 80 : ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ အားလုံး၏ ထက်ဝက် ကျော် က ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သည် ။
[2021-06-03 09:32:18] Best translation 160 : ဒုတိယ ပိုင်း တွင် အိန္ဒိယ နိုင်ငံ အရှေ့တောင် အာရှ ပစိဖိတ် ခရီးသည် မီးရထား ဖြင့် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 09:32:24] Best translation 320 : ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ ထဲ မှာ နမူနာ ပစ္စည်း တွေ ပါ ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က နမူနာ ပစ္စည်း တွေ ပါ ။
[2021-06-03 09:32:53] Best translation 640 : ဘူတာရုံ မှ ညနေ ၇ နာရီ တွင် အရေးပေါ် အခြေအနေ ကြေညာ ချက် ကို လက်ခံ ရရှိ သည် ။
[2021-06-03 09:32:57] Total translation time: 55.01495s
[2021-06-03 09:32:57] [valid] Ep. 7 : Up. 55000 : bleu : 5.26761 : new best
...
...
...
[2021-06-03 12:52:31] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 12:52:42] [valid] Ep. 8 : Up. 65000 : cross-entropy : 157.097 : new best
[2021-06-03 12:52:50] [valid] Ep. 8 : Up. 65000 : perplexity : 75.2782 : new best
[2021-06-03 12:52:50] Translating validation set...
[2021-06-03 12:53:02] Best translation 0 : &quot; သူ ဆုံးရှုံး သွား တာ ကို ကျွန်တော် တို့ ဝမ်းနည်း ပါ တယ် &quot; ဟု သူ က ရန်သူ နှင့် ဘာသာ ရေး ကို ကာကွယ် သွား မည် ဖြစ် သည် ။
[2021-06-03 12:53:02] Best translation 1 : သူ သည် ပါကစ္စတန် ၏ ဒုံးကျည် များ မှ ထုတ်ပယ် ခံ ရ ခြင်း ဖြစ် ပြီး ပါကစ္စတန် နိုင်ငံ ၏ မြောက် ပိုင်း စစ်ဌာနချုပ် မှ စတင် ပစ်ခတ် ခြင်း ခံ ခဲ့ ရ ပြီး စစ်သွေးကြွ ၃၀ ကျော် သေဆုံး ခဲ့ ကြောင်း တွေ့ရှိ ရ ပါ သည် ။
[2021-06-03 12:53:04] Best translation 2 : အဆိုပါ ဒုံးကျည် များ က သင်္ဘော တစ်စီး ဖြင့် ပစ်ခတ် ခံ ရ သည် ဟု ပါကစ္စတန် အကြီးတန်း အရာရှိ တစ် ဦး က ပြော သည် ။
[2021-06-03 12:53:04] Best translation 3 : &quot; သူ တို့ က ဒီ လူ တွေ ကို ကောင်းမွန်တဲ့ အလုပ် နဲ့ အစားထိုး ဖို့ စွမ်းရည် ရှိ တယ် &quot; ဟု အနောက် ပိုင်း ဆိုင်ရာ ကျွမ်းကျင်သူ တစ်ဦး က ပြော တယ် ။
[2021-06-03 12:53:06] Best translation 4 : အကျိုးဆောင် အဖွဲ့ ဝင် များ ၏ တတိယ မြောက် အမြင့်ဆုံး အဆင့်မြင့် ကိုယ်စားလှယ် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 12:53:06] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ့ သေဆုံး မှု အကြောင်း ကို မ သိ ဘူး လို့ ပါကစ္စတန် အစိုးရ က ပြော တယ် ။
[2021-06-03 12:53:06] Best translation 10 : ဇူလိုင် လ ၃ရက် နေ့ နံနက် စောစော ရောက် လာ သည့် ဂိုး တစ်ဂိုး ကို မှတ်တမ်းတင် ခဲ့ သည် ။
[2021-06-03 12:53:06] Best translation 20 : အမေရိကန် အခြေစိုက် ကူးသန်း ရောင်းဝယ်ရေး ဌာန တစ် ခု ဖြစ် သည့် ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အန် စီ စီတီ ကို သုတေသန နှင့် နည်းပညာ ဆိုင်ရာ အချက်အလက် များ ကို သုတေသန ပြုလုပ် သည် ။
[2021-06-03 12:53:06] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ကို ရ ဖို့ ကြိုးစား ခဲ့ တဲ့ သေနတ်သမား နှစ် ယောက် က သူ့ ကို ရိုက်နှက် ခဲ့ တယ် ။
[2021-06-03 12:53:06] Best translation 80 : မဲ အရေအတွက် ၅၀ အောက် မနည်း ပါဝင် သော မဲဆန္ဒရှင် များ သည် ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သူ များ ၏ အရေအတွက် မှာ ဆန္ဒမဲ ပေးပိုင် ခွင့် ရှိ သည် ။
[2021-06-03 12:53:06] Best translation 160 : ဒုတိယ မြောက် အရှေ့တောင် အာရှ ခရီးသည် တင် ရထား က အိန္ဒိယ ၏ ပစိဖိတ် ခရီးသည် တင် ရထား ပေါ် တွင် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 12:53:12] Best translation 320 : ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ ထဲ မှာ အဓိပ္ပာယ် မ ရှိ တာ တွေ ရှိ ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က နမူနာ ပစ္စည်း တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-03 12:53:40] Best translation 640 : သင်္ဘောဆိပ်ကမ်း မှ ညနေ ၇ နာရီ တွင် အရေးပေါ် အခြေအနေ ကြေညာ ချက် ကို လက်ခံ ရရှိ သည် ။
[2021-06-03 12:53:46] Total translation time: 56.30391s
[2021-06-03 12:53:46] [valid] Ep. 8 : Up. 65000 : bleu : 5.42704 : new best
...
...
...
[2021-06-03 16:13:25] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-03 16:13:37] [valid] Ep. 9 : Up. 75000 : cross-entropy : 156.252 : new best
[2021-06-03 16:13:45] [valid] Ep. 9 : Up. 75000 : perplexity : 73.5494 : new best
[2021-06-03 16:13:45] Translating validation set...
[2021-06-03 16:13:56] Best translation 0 : &quot; သူ ဆုံးရှုံး သွား တာ ကို ကျွန်တော် တို့ ဝမ်းနည်း ပါ တယ် ။ သူ က ရန်သူ နိုင်ငံ နဲ့ ဘာသာရေး ကို ဆန့်ကျင် တဲ့ အမွေအနှစ် တစ်ခု ထား ခဲ့ တယ် ။
[2021-06-03 16:13:56] Best translation 1 : ၎င်း ကို အမေရိကန်ပြည်ထောင်စု က မတ် လ ၁၆ ရက်နေ့ က ထုတ်ပြန် ခဲ့ သည့် အမေရိကန် လေကြောင်း လိုင်း တစ်ခု မှ ထုတ်ပယ် ခံ ခဲ့ ရ ပြီး စစ်သွေးကြွ ၃၀ ကျော် သေဆုံး ခဲ့ ကြောင်း တွေ့ရှိ ရ ပါ သည် ။
[2021-06-03 16:13:58] Best translation 2 : ဒီ ဒုံးကျည် တွေ က သင်္ဘော တစ်စီး နဲ့ ပစ် ခံ ရ တယ် &quot; ဟု ပါကစ္စတန် အကြီးတန်း အရာရှိ တစ် ဦး က ပြော တယ် ။
[2021-06-03 16:13:58] Best translation 3 : သူ တို့ တွေ က လည်း ဒီ လူငယ် တွေ ကို အစားထိုး ပြီး အစားထိုး ဖို့ စွမ်းရည် ရှိ တယ် &quot; ဟု အနောက် ပိုင်း ဆိုင်ရာ ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော တယ် ။
[2021-06-03 16:14:00] Best translation 4 : နှောင့်ယှက် ခံ ရ သူ ၏ တတိယ မြောက် အဆင့်မြင့် ကိုယ်စားလှယ် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-03 16:14:00] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ ၏ သေဆုံး မှု အကြောင်း ကို သူ တို့ မ သိ ခဲ့ ပေ ။
[2021-06-03 16:14:00] Best translation 10 : လော့စ်အိန်ဂျယ်လိစ် ကနေ စောစော ရောက် လာ တဲ့ ဂိုး တစ်ဂိုး ပါ ပဲ ။
[2021-06-03 16:14:00] Best translation 20 : အမေရိကန် ကူးသန်း ရောင်းဝယ်ရေး ဌာန တစ် ခု ဖြစ် သည့် ဝါရှင်တန် တွင် အခြေစိုက် သော အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် ယူ အန် အို ဒီစီ တို့ က သုတေသန နှင့် နည်းပညာ ဆိုင်ရာ အချက်အလက် များ ကို သုတေသန ပြုလုပ် သည် ။
[2021-06-03 16:14:00] Best translation 40 : အဲဒီ နောက် သူ မ ရဲ့ အကူအညီ ကို ရ ဖို့ ကြိုးစား ခဲ့ တဲ့ သေနတ်သမား က သူ့ ဆံပင် တွေ ကို ဖုံးကွယ် ခဲ့ တယ် ။
[2021-06-03 16:14:00] Best translation 80 : မဲပေး သူ အရေအတွက် သည် ၅၀ ရာခိုင်နှုန်း အောက် မနည်း ပါဝင် ပြီး ရွေးချယ် တင်မြှောက် ခံ ရ သူ အားလုံး ၏ အနည်းဆုံး လေးပုံ ရာခိုင်နှုန်း သာ ပါဝင် ပါ သည် ။
[2021-06-03 16:14:00] Best translation 160 : ဒုတိယ မြောက် အရှေ့တောင် အာရှ ခရီးသည် တင် ရထား က အိန္ဒိယ ၏ ပစိဖိတ် ခရီးသည် တင် ရထား ပေါ် တွင် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 16:14:05] Best translation 320 : ဘေလ် ထဲ မှာ ဆို ထား တဲ့ ပုံစံ က ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က နမူနာ ပစ္စည်း တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-03 16:14:34] Best translation 640 : ပင်လယ် ရေကြောင်း သယ်ယူ ပို့ဆောင် ရေး ဦးစီးဌာန မှ ညနေ ၇ နာရီ ၄၅ မိနစ် တွင် အရေးပေါ် အခြေအနေ ကြေညာ သည် ။
[2021-06-03 16:14:39] Total translation time: 54.52233s
[2021-06-03 16:14:39] [valid] Ep. 9 : Up. 75000 : bleu : 5.6817 : new best
...
...
...
[2021-06-03 17:54:39] Best translation 80 : မဲပေး သူ အရေအတွက် ၅၀ ရာခိုင်နှုန်း အောက် မနည်း ပါဝင် သော ကိုယ်စားလှယ်လောင်း တစ်ဦး သည် ဆန္ဒမဲ ပေးပိုင်ခွင့် ရှိ သူ အားလုံး ၏ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း ဖြစ် ပါ သည် ။
[2021-06-03 17:54:39] Best translation 160 : ဒုတိယ မြောက် ပိုင်း တွင် အိန္ဒိယ ပစိဖိတ် ခရီးသည် တင် ရထား က နေ အိန္ဒိယ သမုဒ္ဒရာ ရထား ပေါ် တွင် အသုံးပြု ခဲ့ သည် ။
[2021-06-03 17:54:44] Best translation 320 : ဘေလ် ထဲ မှာ ဆို ထား ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ တွေ က နမူနာ ပစ္စည်း တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-03 17:55:13] Best translation 640 : သင်္ဘော တပ်ဖွဲ့ မှ ညနေ ၇ နာရီ ခွဲ ခန့် တွင် အရေးပေါ် အခြေအနေ ကြေညာ ချက် ထုတ်ပြန် သည် ။
[2021-06-03 17:55:19] Total translation time: 55.91576s
[2021-06-03 17:55:19] [valid] Ep. 9 : Up. 80000 : bleu : 5.56102 : stalled 1 times (last best: 5.6817)
...
...
...
[2021-06-04 05:31:12] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-04 05:31:14] Saving model weights and runtime parameters to model.s2s-4.word/model.iter115000.npz
[2021-06-04 05:31:15] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-04 05:31:18] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-04 05:31:29] [valid] Ep. 13 : Up. 115000 : cross-entropy : 157.836 : stalled 5 times (last best: 155.956)
[2021-06-04 05:31:37] [valid] Ep. 13 : Up. 115000 : perplexity : 76.8234 : stalled 5 times (last best: 72.9532)
[2021-06-04 05:31:37] Translating validation set...
[2021-06-04 05:31:49] Best translation 0 : &quot; ဆုံးရှုံး မှု တွေ အတွက် ဝမ်းနည်း ပါ တယ် ဟု သူ က ပြောကြား သည် ။
[2021-06-04 05:31:49] Best translation 1 : ပါကစ္စတန် ဝါ ဇီ ရစ် တန် နယ်မြေ ထဲ မှ ရေနံ တင် သင်္ဘော တစ်စီး မှ ထုတ်ပယ် ခြင်း ခံ ခဲ့ ရ ပြီး နောက်ပိုင်း တွင် စစ်သွေးကြွ များ ထပ်မံ သေဆုံး ခဲ့ ကြောင်း သိရှိ ရ ပါ သည် ။
[2021-06-04 05:31:50] Best translation 2 : အဆိုပါ ဒုံးကျည် များ ကို မောင်းသူ မဲ့ လေယာဉ် တစ်စီး ဖြင့် ပစ် လိုက် ပြီ ဟု ပါကစ္စတန် ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော သည် ။
[2021-06-04 05:31:50] Best translation 3 : သူ တို့ က ဒါ တွေ ကို စီမံခန့်ခွဲ ဖို့ စွမ်းရည် ရှိ တယ် &quot; လို့ အနောက်တိုင်း ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-06-04 05:31:53] Best translation 4 : ယင်း နေ ရာတွင် အယ် ကိုင် ဒါ ၏ တတိယ မြောက် အဆင့်မြင့် ကိုယ်စားလှယ် အမတ် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-04 05:31:53] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ တို့ သေဆုံးမှု အကြောင်း ကို သူ တို့ မ သိ ဘူး လို့ ပြော တယ် ။
[2021-06-04 05:31:53] Best translation 10 : LosAngeles ကို ပထမ ပိုင်း ရောက်ရှိ လာ တဲ့ ဂိုး တစ်ဂိုး ပါ ပဲ ။
[2021-06-04 05:31:53] Best translation 20 : အမေရိကန် အခြေစိုက် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် ဝါရှင်တန် အခြေစိုက် အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အန် စီ စီတီ သည် ဒိုက် ကာ နှင့် လေထု တို့ အပေါ် သုတေသန နှင့် အတတ်ပညာ ဆိုင်ရာ အချက်အလက် များ ကို သုတေသန ပြုလုပ် ပါသည် ။
[2021-06-04 05:31:53] Best translation 40 : အဲဒီ နောက် သေနတ်သမား က သူ့ ကို သေနတ် နဲ့ ပစ် လိုက် တဲ့ သေနတ်သမား က သူ့ ဆံပင် ကို ပစ် လိုက် တယ် အဲဒီ နောက် လူ နှစ် ယောက် က သူ့ ကို ကူညီ ဖို့ ကြိုးစား ခဲ့ တယ် ။
[2021-06-04 05:31:53] Best translation 80 : မဲပေး သူ အရေအတွက် သည် ၅၀ ရာခိုင်နှုန်း အောက် လျော့နည်း ခဲ့ ပြီး ကိုယ်စားလှယ်လောင်း တစ်ဦး မှ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း ဆန္ဒမဲ ပေး ရန် လိုအပ် ပါ သည် ။
[2021-06-04 05:31:53] Best translation 160 : ဒုတိယ မြောက် အရှေ့တောင် အာရှ ရထား ရထား က အိန္ဒိယ ၏ ပစိဖိတ် ခရီးသည် တင် ရထား ဖြင့် သုံး ၍ ဖြတ်သန်း ခဲ့ သည် ။
[2021-06-04 05:31:58] Best translation 320 : ဘာ ဖြစ် လို့ လဲ ဆို တော့ ကျွန်တော် တို့ ရဲ့ ပုံစံ က ဗီတာမင် တွဲသုံး တာ ၊ အပူရှိန် ၊ အပူပေး စက် ၊ အပူပေး စက် တွေ နဲ့ သက်ရှိ တွေ အတွက် အဓိက ပါဝင် ပစ္စည်းတွေ ပါ ။
[2021-06-04 05:32:26] Best translation 640 : သင်္ဘော လိုင်း မှ ညနေ ၇ နာရီ ၃၅ မိနစ် တွင် သင်္ဘော လိုင်း မှ အရေးပေါ် သတင်း ရရှိ သည် ။
[2021-06-04 05:32:31] Total translation time: 53.99553s
[2021-06-04 05:32:31] [valid] Ep. 13 : Up. 115000 : bleu : 5.81631 : new best
...
...
...
[2021-06-04 08:50:34] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-04 08:50:46] [valid] Ep. 14 : Up. 125000 : cross-entropy : 159.018 : stalled 7 times (last best: 155.956)
[2021-06-04 08:50:53] [valid] Ep. 14 : Up. 125000 : perplexity : 79.3621 : stalled 7 times (last best: 72.9532)
[2021-06-04 08:50:53] Translating validation set...
[2021-06-04 08:51:06] Best translation 0 : &quot; ဆုံးရှုံး မှု တွေ အတွက် ဝမ်းနည်း ပါ တယ် ဟု သူ က ပြောကြား သည် ။
[2021-06-04 08:51:06] Best translation 1 : သူ တို့ ကို ပါကစ္စတန် ဝါ ဇီ ရစ် တန် နယ်မြေ ထဲ က ရေနံ တင် သင်္ဘော တစ်စီး မှ ပစ် ခံခဲ့ ရ တယ် လို့ အခိုင် အမာ ပြော ခဲ့ တယ် ။
[2021-06-04 08:51:07] Best translation 2 : ဒီ ဒုံး ကို မောင်းသူ မဲ့ လေယာဉ် တစ်စီး နဲ့ ပစ် တယ်လို့ ပြော တယ် ။
[2021-06-04 08:51:07] Best translation 3 : သူ တို့ တွေ က ဒီ လူငယ် တွေ ကို စီမံခန့်ခွဲ ဖို့ စွမ်းရည် ရှိ တယ် &quot; လို့ အနောက်တိုင်း ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-06-04 08:51:10] Best translation 4 : ယင်း နေ ရာတွင် အယ် ကိုင် ဒါ ၏ တတိယ မြောက် အဆင့်မြင့် ကိုယ်စားလှယ် အမတ် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-04 08:51:10] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ တို့ သေဆုံးမှု အကြောင်း ကို မ သိ ဘူး လို့ ပြော တယ် ။
[2021-06-04 08:51:10] Best translation 10 : နောက် တစ် လ အစော ပိုင်း က ဖြစ် လာ ခဲ့ တာ ဖြစ် ပါ တယ် ။
[2021-06-04 08:51:10] Best translation 20 : အမေရိကန် အခြေစိုက် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် ဝါရှင်တန် အခြေစိုက် အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အန် စီ စီတီ သည် ဒိုက် ကာ နှင့် လေထု တို့ အပေါ် သုတေသန လုပ်ငန်း များ ကို ပြုလုပ် လျက် ရှိ ပါ သည် ။
[2021-06-04 08:51:10] Best translation 40 : အဲဒီ နောက် လူ နှစ် ယောက် က သူ့ ကို ရိုက်နှက် ဖို့ ကြိုးစား တဲ့ သေနတ်သမား နှစ် ယောက် က သူ့ ဆံပင် ကို ဆွဲထုတ် လိုက် တယ် ။
[2021-06-04 08:51:10] Best translation 80 : မဲပေး သူ အရေအတွက် သည် ၅၀ ရာခိုင်နှုန်း အောက် လျော့နည်း ခဲ့ ပြီး ကိုယ်စားလှယ်လောင်း တစ်ဦး မှ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း ရ ရှိ ကြ ပါ သည် ။
[2021-06-04 08:51:10] Best translation 160 : ဒုတိယ အချက်အချာကျ သော ဆစ်ဒနီ မြို့ သည် အိန္ဒိယ ပစိဖိတ် ရထား ရထား က ပါ လာ မည့် မိုင် ရှည်လျား သည့် ဆစ်ဒနီ မြို့ ကို ဖြတ် ၍ ဖြတ်သန်း ခဲ့ ပြီ ဖြစ် သည် ။
[2021-06-04 08:51:15] Best translation 320 : အန် အမ် အီး ထဲ မှာ ဖြစ်ပေါ် နေ တဲ့ ပုံစံ ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ က တော့ ဟင်းခတ် အမွှေးအကြိုင် တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-04 08:51:42] Best translation 640 : သင်္ဘော လိုင်း မှ ညနေ ၇ နာရီ ၄၅ မိနစ် တွင် သင်္ဘော လိုင်း မှ အသံလွှင့် ခြင်း ခံ ရ သည် ။
[2021-06-04 08:51:48] Total translation time: 54.65454s
[2021-06-04 08:51:48] [valid] Ep. 14 : Up. 125000 : bleu : 5.7596 : stalled 2 times (last best: 5.81631)
...
...
...
[2021-06-04 10:31:53] Best translation 40 : အဲဒီ နောက် သေနတ်သမား က သူ့ ကို သေနတ် နဲ့ ပစ် ပြီး သူ့ ကို ကူညီ ဖို့ ကြိုးစား ခဲ့ တဲ့ သေနတ်သမား နှစ် ယောက် က သူ့ ကို ဆွဲခေါ် သွား တယ် ။
[2021-06-04 10:31:53] Best translation 80 : မဲပေး သူ အရေအတွက် သည် ၅၀ ရာခိုင်နှုန်း အောက် လျော့နည်း ခဲ့ ပြီး ကိုယ်စားလှယ်လောင်း တစ်ဦး မှ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း ဆန္ဒမဲ ရရှိ ရန် လိုအပ် ပါ သည် ။
[2021-06-04 10:31:53] Best translation 160 : ဒုတိယ စင်္ကြံ တွင် အိန္ဒိယ ပစိဖိတ် ခရီးသည် တင် ရထား က ပါ သွား သော လမ်းကြောင်း ကို ပိတ် လိုက် ပြီ ဖြစ် သည် ။
[2021-06-04 10:31:57] Best translation 320 : အန် အမ် အီး ထဲ မှာ ဖြစ်ပေါ် နေ တဲ့ ပုံစံ ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ က တော့ ဟင်းခတ် အမွှေးအကြိုင် တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-04 10:32:27] Best translation 640 : သင်္ဘော လိုင်း မှ ညနေ ၇ နာရီ ၄၅ မိနစ် တွင် သင်္ဘော လိုင်း မှ အသံလွှင့် ခြင်း ကို ခံ ရ သည် ။
[2021-06-04 10:32:31] Total translation time: 55.16228s
[2021-06-04 10:32:31] [valid] Ep. 15 : Up. 130000 : bleu : 5.63438 : stalled 3 times (last best: 5.81631)
...
...
...
[2021-06-04 13:54:11] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-04 13:54:13] Saving model weights and runtime parameters to model.s2s-4.word/model.iter140000.npz
[2021-06-04 13:54:15] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-04 13:54:17] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-04 13:54:29] [valid] Ep. 16 : Up. 140000 : cross-entropy : 161.408 : stalled 10 times (last best: 155.956)
[2021-06-04 13:54:37] [valid] Ep. 16 : Up. 140000 : perplexity : 84.7553 : stalled 10 times (last best: 72.9532)
[2021-06-04 13:54:37] Translating validation set...
[2021-06-04 13:54:50] Best translation 0 : &quot; ဆုံးရှုံး မှု တွေ အတွက် ဝမ်းနည်း ပါ တယ် ဟု သူ က ပြောကြား သည် ။
[2021-06-04 13:54:50] Best translation 1 : ပါကစ္စတန် ဝါ ဇီ ရစ် တန် ဝါ ဇီ ရစ် မှ စ ကာ ဟု သတ်မှတ် ဖော်ထုတ် ခဲ့ သည့် အမေရိကန်ပြည်ထောင်စု ဒုံး ကျည် တစ် စီး မှ သေနတ် ဖြင့် ပစ်ခတ် ခြင်း ခံ ခဲ့ ရ ကြောင်း တွေ့ရှိ ရ ပါ သည် ။
[2021-06-04 13:54:50] Best translation 2 : ဒီ ဒုံးပျံ ကို မောင်းသူ မဲ့ လေယာဉ် တစ်စီး နဲ့ ပစ် တယ်လို့ ပြော တယ် ။
[2021-06-04 13:54:50] Best translation 3 : သူ တို့ က ဒီ လူ တွေ ကို စီမံခန့်ခွဲ ဖို့ စွမ်းရည် ရှိ တယ် &quot; လို့ အနောက် ထောက်လှမ်းရေး အရာရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-06-04 13:54:53] Best translation 4 : ယင်း နေ ရာတွင် အယ် ကိုင် ဒါ ၏ တတိယ မြောက် အဆင့်မြင့် ကိုယ်စားလှယ် အမတ် ဖြစ် သည် ဟု ဆို တယ် ။
[2021-06-04 13:54:53] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ သေဆုံး တာ နဲ့ ပတ်သက် ပြီး မ သိ ဘူး လို့ ပြော တယ် ။
[2021-06-04 13:54:53] Best translation 10 : LosAngeles ကို ပထမ ပိုင်း တွင် ရောက်ရှိ လာ ခဲ့ ကြ သော လော့စ် လူ ဂျ လီး ယား ပြည်သူ များ က မှတ်တမ်းတင် ခဲ့ ကြ သည် ။
[2021-06-04 13:54:53] Best translation 20 : အမေရိကန် အခြေစိုက် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် ဝါရှင်တန် အခြေစိုက် အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး ဌာန တစ် ခု ဖြစ် သည့် အန် စီ စီတီ သည် ဒိုက် ကာ နှင့် လေထု တို့ အပေါ် သုတေသန လုပ်ငန်း များ ကို ပြုလုပ် လျက် ရှိ ပါ သည် ။
[2021-06-04 13:54:53] Best translation 40 : သူ့ ကို သေနတ် နဲ့ ပစ် လိုက် တဲ့ သေနတ်သမား က သူ မ ကို သေနတ် နဲ့ ပစ် ပြီး သူ့ ကို ကူညီ ဖို့ ကြိုးစား ခဲ့ တဲ့ သေနတ်သမား က သူ့ ဆံပင် ကို ဆတ် ခနဲ ဆွဲယူ ခဲ့ တယ် ။
[2021-06-04 13:54:53] Best translation 80 : မဲပေး သူ အရေအတွက် သည် ၅၀ ရာခိုင်နှုန်း အောက် လျော့နည်း ခဲ့ ပြီး ကိုယ်စားလှယ်လောင်း တစ်ဦး မှ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း ဆန္ဒမဲ ရရှိ ရန် လိုအပ် ပါ သည် ။
[2021-06-04 13:54:53] Best translation 160 : ဒုတိယ အချက်အချာကျ သော ဆစ်ဒနီ မြို့ သည် ရှည်လျား သော ဆစ်ဒနီ မြို့ ရှိ အိန္ဒိယ ပစိဖိတ် ခရီးသည် တင် ရထား ကို ဖြတ် ၍ သုံး ခဲ့ ပါ သည် ။
[2021-06-04 13:54:58] Best translation 320 : အန် အမ် အီး ထဲ မှာ ဖြစ်ပေါ် နေ တဲ့ ပုံစံ ဖြစ် ပါ တယ် ။ ကျွန်တော် တို့ ရဲ့ ပုံစံ က တော့ ဟင်းခတ် အမွှေးအကြိုင် တွေ ၊ အပူပေး စက် တွေ ၊ အပူပေး စက် တွေ ပါ ။
[2021-06-04 13:55:25] Best translation 640 : သင်္ဘော လိုင်း မှ ညနေ ၇ နာရီ ခွဲ ခန့် တွင် သင်္ဘော လိုင်း မှ အသံလွှင့် ခြင်း ကို ခံ ရ သည် ။
[2021-06-04 13:55:31] Total translation time: 54.07636s
[2021-06-04 13:55:31] [valid] Ep. 16 : Up. 140000 : bleu : 5.59372 : stalled 5 times (last best: 5.81631)
[2021-06-04 13:55:32] Training finished
[2021-06-04 13:55:35] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-04 13:55:37] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-04 13:55:40] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz

real	2792m23.906s
user	4421m19.381s
sys	2m3.689s
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$

## Update Script and Train Again

BLEU score နဲ့ပဲ တွက်ကြည့်ရင် stalled time က ၅ခါပဲ ရှိသေးလို့ ထပ်ကြိုးစားကြည့်။
ဒီအတိုင်း epoch ပဲ တိုးတာမျိုးထက် dropout ကိုပါ ကစားကြည့်ခဲ့...

  --dropout-rnn 0.2 --dropout-src 0.2 --exponential-smoothing \
  --early-stopping 20 \

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt$ ./s2s.deep4.word.sh 
...
...
...
[2021-06-05 03:52:40] [valid] Ep. 19 : Up. 165000 : bleu : 5.38886 : stalled 10 times (last best: 5.81631)
[2021-06-05 04:02:28] Ep. 19 : Up. 165500 : Sen. 80,984 : Cost 0.78812599 * 255,685 after 85,168,638 : Time 669.40s : 381.96 words/s
[2021-06-05 04:12:17] Ep. 19 : Up. 166000 : Sen. 95,342 : Cost 0.80177510 * 260,484 after 85,429,122 : Time 589.10s : 442.18 words/s
[2021-06-05 04:22:05] Ep. 19 : Up. 166500 : Sen. 109,448 : Cost 0.81399888 * 257,085 after 85,686,207 : Time 587.65s : 437.48 words/s
[2021-06-05 04:31:58] Ep. 19 : Up. 167000 : Sen. 123,517 : Cost 0.82127559 * 259,535 after 85,945,742 : Time 593.30s : 437.44 words/s
[2021-06-05 04:41:45] Ep. 19 : Up. 167500 : Sen. 137,851 : Cost 0.81652665 * 255,284 after 86,201,026 : Time 586.14s : 435.53 words/s
[2021-06-05 04:51:40] Ep. 19 : Up. 168000 : Sen. 151,718 : Cost 0.82104951 * 255,385 after 86,456,411 : Time 595.33s : 428.98 words/s
[2021-06-05 05:01:30] Ep. 19 : Up. 168500 : Sen. 165,752 : Cost 0.83428872 * 256,012 after 86,712,423 : Time 590.16s : 433.80 words/s
[2021-06-05 05:11:19] Ep. 19 : Up. 169000 : Sen. 180,049 : Cost 0.84342414 * 260,188 after 86,972,611 : Time 588.70s : 441.97 words/s
[2021-06-05 05:21:05] Ep. 19 : Up. 169500 : Sen. 194,111 : Cost 0.83802795 * 255,524 after 87,228,135 : Time 586.76s : 435.48 words/s
[2021-06-05 05:30:50] Ep. 19 : Up. 170000 : Sen. 208,436 : Cost 0.84385109 * 256,839 after 87,484,974 : Time 584.61s : 439.33 words/s
[2021-06-05 05:30:50] Saving model weights and runtime parameters to model.s2s-4.word/model.npz.orig.npz
[2021-06-05 05:30:52] Saving model weights and runtime parameters to model.s2s-4.word/model.iter170000.npz
[2021-06-05 05:30:53] Saving model weights and runtime parameters to model.s2s-4.word/model.npz
[2021-06-05 05:30:56] Saving Adam parameters to model.s2s-4.word/model.npz.optimizer.npz
[2021-06-05 05:31:08] [valid] Ep. 19 : Up. 170000 : cross-entropy : 169.823 : stalled 16 times (last best: 155.956)
[2021-06-05 05:31:15] [valid] Ep. 19 : Up. 170000 : perplexity : 106.831 : stalled 16 times (last best: 72.9532)
[2021-06-05 05:31:15] Translating validation set...
[2021-06-05 05:31:28] Best translation 0 : &quot; ဆုံးရှုံး သွား တာ က တော့ သူ ဆုံးရှုံး ရ တဲ့ ဆုံးရှုံးမှု အတွက် ဝမ်းနည်း ပါ တယ် ။
[2021-06-05 05:31:28] Best translation 1 : ပါကစ္စတန် ဝါ ဇီ ရစ် တန် ဝါ ဇီ ရစ် တန် ဝါ ဇီ ရစ် တန် ဝါ ဇီ ရစ် တန် ဝါ ဇီ ရစ် မှ ဒုံးကျည် များ သယ်ဆောင် လာ ကြောင်း တွေ့ရှိ ရ ပါ သည် ။
[2021-06-05 05:31:28] Best translation 2 : ဒီ ဒုံးပျံ ကို မောင်းသူ မဲ့ လေယာဉ် တစ်စင်း ဖြင့် ပစ် ပါတယ် ဟု ပါကစ္စတန် ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော သည် ။
[2021-06-05 05:31:28] Best translation 3 : သူ တို့ တွေ က ဒီ လူငယ် တွေ ကို စီမံခန့်ခွဲ နိုင် တဲ့ စွမ်းရည် ရှိ ပါ တယ် &quot; လို့ အနောက်ပိုင်း ထောက်လှမ်း ရေး အရာရှိ တစ် ဦး က ပြော ပါ တယ် ။
[2021-06-05 05:31:31] Best translation 4 : ယင်း နေ ရာတွင် အယ် ကိုင် ဒါ ၏ တတိယ မြောက် အဆင့်မြင့် ကိုယ်စားလှယ် အမတ် ဖြစ် သည် ဟု ဆို သည် ။
[2021-06-05 05:31:31] Best translation 5 : ပါကစ္စတန် အစိုးရ က သူ သေဆုံး တာ ကို သူ တို့ မ သိ ဘူး လို့ ပြော တယ် ။
[2021-06-05 05:31:31] Best translation 10 : လော့စ်အိန်ဂျလိ စ် မှာ ပထမ ပိုင်း ရောက်ရှိ လာ တဲ့ ဂိုး တစ်ဂိုး နဲ့ တူ ပါ တယ် ။
[2021-06-05 05:31:31] Best translation 20 : အမေရိကန် ကုန်သွယ်ရေး ဌာန အခြေစိုက် အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး အေဂျင်စီ တစ်ခု သည် ဝါရှင်တန် ၊ ဒီ စီ တွင် အခြေစိုက် ထား သည့် အမေရိကန် ကူးသန်း ရောင်းဝယ် ရေး အေဂျင်စီ တစ်ခု ဖြစ် သည့် အားလျော်စွာ စာတမ်း များ နှင့် မှတ်တမ်း များ ဆိုင်ရာ သတင်း အချက်အလက် များ ကို ဖော်ပြ သည် ။
[2021-06-05 05:31:31] Best translation 40 : အဲဒီ နောက် သေနတ်သမား က သူ မ ကို သေနတ် နဲ့ ပစ် ပြီး သူ့ ကို ကူညီ ဖို့ ကြိုးစား တဲ့ သေနတ်သမား နှစ် ယောက် က သူ့ ဆံပင် ကို ဖမ်းကိုင် လိုက် တယ် ။
[2021-06-05 05:31:31] Best translation 80 : မဲဆန္ဒရှင် အရေအတွက် ၅၀ ရာခိုင်နှုန်း အောက် က မဲပေး သူ အရေအတွက် သည် ဆန္ဒမဲ ပေးပိုင်ခွင့် ရှိ သူ များ ၏ အနည်းဆုံး ၃၃ ရာခိုင်နှုန်း သာ ပါဝင် ပါ သည် ။
[2021-06-05 05:31:31] Best translation 160 : ဒုတိယ အချက်အချာကျ သော ဆစ်ဒနီ မြို့ သည် ရှည်လျား သော ဆစ်ဒနီ ရှိ အိန္ဒိယ ပစိဖိတ် ခရီးသည် တင် ရထား ကို ဖြတ် ၍ သုံး ပါ သည် ။
[2021-06-05 05:31:36] Best translation 320 : ကျွန်တော် တို့ ရဲ့ ပုံစံ တွ ကြေား မှာ ဖြစ်ပေါ် နေ တဲ့ လက္ခဏာ တွေ က တော့ မျှတမှု အပြည့် ရှိ တာ ပဲ ဖြစ် ပါ တယ် ။ အဲဒီ ထဲ က ပုံစံ တွေ က တော့ သက်ရှိ တွေ အတွက် အဓိက ပါဝင် ပစ္စည်းတွေ ပါ ပဲ &quot;။
[2021-06-05 05:32:05] Best translation 640 : ကမ်းခြေ လိုင်း မှ မွန်းလွဲ ၇ နာရီ ခွဲ ခန့် တွင် သင်္ဘော လိုင်း မှ စာတို အပြန်အလှန် လာရောက် ခဲ့ ပါ သည် ။
[2021-06-05 05:32:09] Total translation time: 54.58023s
[2021-06-05 05:32:09] [valid] Ep. 19 : Up. 170000 : bleu : 5.46387 : stalled 11 times (last best: 5.81631)
***
***
BLEU မှာလည်း stalled time က ၁၀ခါ ကျော်သွားပြီမို့ ရပ်ပြီးတော့ Transformer ကို run ဖို့ ပြင်ခဲ့...

## Translation

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.word$ time marian-decoder -m ./model.npz -v ../data_word/vocab/vocab.en.yml ../data_word/vocab/vocab.my.yml --devices 0 1 --output hyp.model.my < ../data_word/test.en
...
...
[2021-06-05 06:25:39] Best translation 983 : အိုင်ယာလန် ဟာ ရေကူးကန် ထဲ မှာ ဒုတိယ အချက် ၈ ချက် ၊ အာဂျင်တီးနား နောက်ကွယ် မှာ ရှိ တယ် ။
[2021-06-05 06:25:39] Best translation 984 : ပြင်သစ် တို့ ဟာ တစ်ဖွဲ့ တည်း နဲ့ တတိယ အချက် က တတိယ အချက် တစ်ချက် ပါ ။
[2021-06-05 06:25:39] Best translation 985 : ဆင် ဆင် ဆင် သည် ဇူးရစ် မြို့ ရှိအ ကျဉ်းထောင် သို့ တနင်္ဂနွေ နေ့ ည တွင် ပြန်လည် ရောက်ရှိ လာပြီး ရဲ များ က ပြန်လည် သိမ်းယူ ခဲ့ သည် ။
[2021-06-05 06:25:40] Best translation 986 : အမည် မည်း စာရင်း ကို လည်းကောင်း ၊ ဆွစ်ဇာလန် နိုင်ငံ မှ အမည် မည်း စာရင်း လည်း ဖြစ် သည် ။
[2021-06-05 06:25:40] Best translation 987 : သူ့ အနေနှင့် ယာဉ် ပေါ် မ လိမ်း ခင် သူမ ၏ လွတ်မြောက် မှု ကို ပြုလုပ် နိုင် ခဲ့ သည် ။
[2021-06-05 06:25:40] Best translation 988 : ပြီး ခဲ့ သည့် ဒေသ စံတော်ချိန် ၁၇ ၃၀ ခန့် အကွာ ၌ မြို့ ပေါ် ၌ လမ်းလျှောက် ခြင်း မ ပြု မီ အချိန်တို အတွင်း ကျောက်မိုင်း လုပ်ငန်းခွင် ကို ကျော်လွန် နိုင် ခဲ့ ပါ သည် ။
[2021-06-05 06:25:40] Best translation 989 : မြို့လယ် က အထင်ကရ လမ်း တစ်လမ်း သွား လျှောက်သွား နေ ခဲ့ တယ် လို့ ဇူးရစ် ရဲတပ်ဖွဲ့ က ပြော ပါ တယ် ။
[2021-06-05 06:25:41] Best translation 990 : သူ မ လည်း အိမ် မှာ ရှိ တဲ့ မြို့ ရဲ့ အဓိက ရထား ဘူတာရုံ လည်း ရောက် နေ ခဲ့ပြီး အဲဒီ ထဲ မှာ တော့ အာ စီ အက်စ် အက် စ် ရဲ့ ထိန်းချုပ်မှု အောက် မှာ ရှိ တဲ့ မြေနေရာ တစ် ခု လည်း ဖြစ် ပါ တယ် ။
[2021-06-05 06:25:41] Best translation 991 : ပြီး ခဲ့ သည့် တစ်နာရီ နီးပါး တွင် ရဲ သည် ဇူးရစ် မြို့ ရှိ ဆင် ကို ပြန်လည် သိမ်းယူ ခဲ့ စဉ် အတွင်း ၌ ဆင် တစ်ကောင် ကို သူ မ နောက်ဆုံး ပြန်လည် သိမ်းယူ ခဲ့ သည် ။
[2021-06-05 06:25:41] Best translation 992 : ဝဲ ဘက် တာဝန်ရှိသူ များ နှင့် ရဲ များ က လည်း နောက်တစ်နေ့ တွင် ထွက်ခွာ လာ ခဲ့ သော်လည်း ပြော ရ သည် က လည်း သူ တို့ ၏ ဖုန်း ခေါ်ဆိုမှု ကို တုံ့ပြန် ခြင်း မ ရှိ ကြောင်း ပြော သည် ။
[2021-06-05 06:25:41] Best translation 993 : ရဲ တွေ က လည်း သူ မ နဲ့ အလုပ် လုပ် ဖို့ အခက်အခဲ ရှိ နေ တယ် လို့ လည်း ပြော ကြ တယ် ။
[2021-06-05 06:25:41] Best translation 994 : ဒေသ စံတော်ချိန် ၂၀၀၀ ခန့် တွင် ဂိုးသမား တစ် ယောက် က တိရစ္ဆာန် ကို ထိန်းချုပ် နိုင် ခဲ့ပြီး သူ မ ကို ထရပ်ကား တစ်စီး သို့ ပို့ ပေး ခဲ့ သည် ။
[2021-06-05 06:25:41] Best translation 995 : အဆိုပါ ဖြစ်စဉ် အတွင်း ထိခိုက်ဒဏ်ရာ ရ မှု သို့မဟုတ် ထိခိုက်ဒဏ်ရာ ရရှိ မှု တစ်စုံတစ်ရာ မ ရှိ ခဲ့ ပါ ။
[2021-06-05 06:25:42] Best translation 996 : ဇူးရစ် မြို့ အနီး တွင် တိုက်ခတ် သွား သော မုန်တိုင်း ကြောင့် ထွက်ပြေး လွတ်မြောက် လာ နိုင် ကြောင်း လည်း ဆပ်ကပ် ပြော ကြ သည် ။
[2021-06-05 06:25:42] Best translation 997 : ဆပ်ကပ် ပွဲ ပြန် လာ ပြီးနောက် သူ မ ပင်ပန်း နေ တယ် လို့ ပြော ခဲ့ တယ် ဒါပေမဲ့ သူ ပြန် ရ လို့ ဝမ်းသာ နေ တယ် ။
[2021-06-05 06:25:42] Best translation 998 : ဝဲ လ် နှင့် သူ ၏ ဇနီး မောင်နှံ တို့သည် အိမ် မှ အိမ် တစ်အိမ် မှ အိမ် သို့ ကားမောင်း နေ စဉ် အတွင်း ၎င်းတို့ ၏ အားလပ်ရက် အိမ် သို့ ကားမောင်း ချိန် တွင် ပါဝင် ခဲ့ ကြ သည် ။
[2021-06-05 06:25:42] Best translation 999 : မစ္စ တာ စ ပဲ ရိုး က ချက်ချင်း ပင် ချက်ချင်း သေဆုံး သွား ခဲ့ တယ်
[2021-06-05 06:25:42] Best translation 1000 : ထို စုံတွဲ သည် နှစ်ဖက် စလုံး က ပေး ထားသော ကဗျာ များ ကို ဖတ်ကြား ကြ သည် ။
[2021-06-05 06:25:43] Best translation 1001 : အိမ် ထဲ မှာ နေတဲ့ ဂျူး လူမျိုး ဟာ တောင်အမေရိက က နေထိုင် တဲ့ ဂျူး လူမျိုး စာရေးဆရာ တစ်ယောက် ပါ ။
[2021-06-05 06:25:43] Best translation 1002 : ဂျုံး ကျကျ သူ့ ဇနီး မှာ အနုပညာ ဗဟို အဖွဲ့ နှင့် စာရေးဆရာ ဖြစ် သည် ။
[2021-06-05 06:25:43] Best translation 1003 : အိမ် ကို ကဗျာ ဆရာ နဲ့ ဆေးပညာ ဆရာဝန် တစ်ယောက် လို့ လူသိများ ကြ တယ် ။
[2021-06-05 06:25:43] Best translation 1004 : သာမန် အားဖြင့် တော့ ဆေးခန်း မှာ နှစ် ၃၀ ကျော် ရင် ဆေးခန်း တစ် ခု ရှိ တယ် ။
[2021-06-05 06:25:43] Best translation 1005 : ဒါပေမဲ့ ကောင်းကောင်း စာ တွေ က စာ တွေ ထဲ မှာ အကောင်းဆုံး သိ နေပြီး စာပေ ဆု တွေ လည်း အများကြီး လက်ခံ ရရှိ ခဲ့ ပါ တယ် ။
[2021-06-05 06:25:43] Best translation 1006 : ၁၉၈၉ ခုနှစ် တွင် ဝေလ နိုင်ငံ တက္ကသိုလ် မှ ဂုဏ်ထူးဆောင် ဘွဲ့များ ပေးအပ် ချီးမြှင့် သည် ။
[2021-06-05 06:25:43] Best translation 1007 : ဇနီးမောင်နှံ သည် ၁၉၈၀ ခုနှစ် များ တွင် စာအုပ် နှစ်အုပ် ကို အတူတကွ တည်းဖြတ် ကြ သည် ။
[2021-06-05 06:25:43] Best translation 1008 : ဂျုံး ကို သား က သူမ ခင်ပွန်း ၊ သား နှစ် ယောက် နဲ့ သမီး နှစ် ယောက် ကျန်ရစ် တယ် ။
[2021-06-05 06:25:44] Best translation 1009 : ဝတ်စား ဆင်ယင်ပုံ ကို လိုက် ပြီး ဗုဒ္ဓဟူး နေ့ ညနေ ပိုင်း က ရန်ကုန် တိုင်း ဒေသ ကြီး ဟင်္သာတ ခရိုင် အုပ်ချုပ်ရေးမှူးရုံး သို့ ကားမောင်း ပြီး ကားမောင်း လိုင်စင် ဖြင့် ဗုဒ္ဓဟူး နေ့ က ဖမ်းဆီးရမိခဲ့ ကြောင်း သိ ရ သည် ။
[2021-06-05 06:25:44] Best translation 1010 : အခြား အနည်းဆုံး ၄ ဦး ကိုလည်း ရဲ များ က ဟန့်တား ထား သော်လည်း ဖမ်းဆီး ခြင်း မ ခံ ခဲ့ ရ ပါ ။
[2021-06-05 06:25:44] Best translation 1011 : တင်ပြ ချက် များ အရ သိရှိ ရ သည် ဟု ရဲ များ က ဖြစ်စဉ် တစ်ခုလုံး ကို မျက်မြင် သက်သေ များ က မျက်မြင် သက်သေ များ အား ပြောကြား ခဲ့ ပါ သည် ။
[2021-06-05 06:25:44] Best translation 1012 : နောက် တော့ သူ တို့ က လည်း သူ မ ကို အနီးကပ် လိုက် ကြ တယ် ။ ပြီး တော့ သူ မ နဲ့ လိုက် ပါ တယ် ။
[2021-06-05 06:25:45] Best translation 1013 : ရဲတပ်ဖွဲ့ က ကား မောင်း နေသော သူမ ၏ ကား ကို မောင်း ပြီး လမ်း ပေါ် မှ ထွက်ပြေး ရန် ကြိုးစား ခဲ့ သည် ၊ သို့သော် ယာဉ် ပေါ် မှ ထွက် ၍ ကား ပေါ် မှ ထွက် လာ သည် ကို မ ဖော်ထုတ် နိုင် ခဲ့ ပေ ။
[2021-06-05 06:25:45] Best translation 1014 : သူ မ ရဲ့ သက်သေခံ ကတ်ပြား ကိုအ တည်ပြု ပြီး သူ မ ကို လွှတ် လိုက် တယ်
[2021-06-05 06:25:45] Best translation 1015 : ရဲ များ က လိုင်စင် ရရှိ မည် ဆိုပါ က ရဲ များကို စစ်ဆေး လျက် ရှိ ကြောင်း သိရှိ ရ ပါ သည် ။
[2021-06-05 06:25:45] Best translation 1016 : ဖောက်ထွင်း ခံ ရ သူ အား မည်သည့် ပစ္စည်း ကို မှ ပေးဆောင် ရ မည် မ ဟုတ် ပါ သို့ရာတွင် လူများ အား ဖမ်းဆီး ထား ခြင်း ဖြစ် ပါ သည် ။
[2021-06-05 06:25:45] Best translation 1017 : မီးသတ် ဌာန ဆိုတာ အဖွဲ့ ရဲ့ အစိတ်အပိုင်း ဖြစ် ပါ တယ် ။ ဒါပေမဲ့ မ မောင်း သင့် ဘူး ဟု လော့ အိန်ဂျယ် လိ စ် ရဲ ဌာန မှ ပြောရေး ဆို ခွင့်ရ အမျိုးသမီး ပြောရေးဆိုခွင့်ရှိသူ က ပြော သည် ။
[2021-06-05 06:25:45] Total time: 214.62913s wall

real	3m37.514s
user	7m9.482s
sys	0m2.578s


## Evaluation

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.word$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ../data_word/test.my < ./hyp.model.my  >> results.txt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/model.s2s-4.word$ cat ./results.txt 
BLEU = 6.27, 39.8/14.2/5.4/2.1 (BP=0.704, ratio=0.740, hyp_len=26830, ref_len=36255)

=============================================================

    
### Extra/Bonus Note (Transformer+The-Sounds-of-Scilence)

တခါတလေ stress release အတွက် လုပ်ဖြစ်ခဲ့တာတွေထဲက log တစ်ခုပါ... :)    

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ffmpeg -i ./ music.wav
Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3
transformer-translation-29May2021.mp4
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ffmpeg -i ./Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3 music.wav
ffmpeg version 4.3.1-4ubuntu1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 10 (Ubuntu 10.2.0-9ubuntu2)
  configuration: --prefix=/usr --extra-version=4ubuntu1 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libdav1d --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librabbitmq --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-pocketsphinx --enable-libmfx --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-nvenc --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared
  libavutil      56. 51.100 / 56. 51.100
  libavcodec     58. 91.100 / 58. 91.100
  libavformat    58. 45.100 / 58. 45.100
  libavdevice    58. 10.100 / 58. 10.100
  libavfilter     7. 85.100 /  7. 85.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  7.100 /  5.  7.100
  libswresample   3.  7.100 /  3.  7.100
  libpostproc    55.  7.100 / 55.  7.100
[mp3 @ 0x55c82f04c100] Estimating duration from bitrate, this may be inaccurate
Input #0, mp3, from './Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3':
  Metadata:
    title           : The Sounds of Silence
    artist          : Simon &amp; Garfunkel
    album           : Greatest Hits
    genre           : pop
  Duration: 00:03:04.92, start: 0.000000, bitrate: 192 kb/s
    Stream #0:0: Audio: mp3, 44100 Hz, stereo, fltp, 192 kb/s
Stream mapping:
  Stream #0:0 -> #0:0 (mp3 (mp3float) -> pcm_s16le (native))
Press [q] to stop, [?] for help
Output #0, wav, to 'music.wav':
  Metadata:
    INAM            : The Sounds of Silence
    IART            : Simon &amp; Garfunkel
    IPRD            : Greatest Hits
    IGNR            : pop
    ISFT            : Lavf58.45.100
    Stream #0:0: Audio: pcm_s16le ([1][0][0][0] / 0x0001), 44100 Hz, stereo, s16, 1411 kb/s
    Metadata:
      encoder         : Lavc58.91.100 pcm_s16le
size=   31856kB time=00:03:04.92 bitrate=1411.2kbits/s speed= 942x    
video:0kB audio:31856kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.000527%
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ls
music.wav
Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3
transformer-translation-29May2021.mp4
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ffmpeg -i music.wav -ss 0 -t 1:49 musicshort.wav
ffmpeg version 4.3.1-4ubuntu1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 10 (Ubuntu 10.2.0-9ubuntu2)
  configuration: --prefix=/usr --extra-version=4ubuntu1 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libdav1d --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librabbitmq --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-pocketsphinx --enable-libmfx --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-nvenc --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared
  libavutil      56. 51.100 / 56. 51.100
  libavcodec     58. 91.100 / 58. 91.100
  libavformat    58. 45.100 / 58. 45.100
  libavdevice    58. 10.100 / 58. 10.100
  libavfilter     7. 85.100 /  7. 85.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  7.100 /  5.  7.100
  libswresample   3.  7.100 /  3.  7.100
  libpostproc    55.  7.100 / 55.  7.100
Guessed Channel Layout for Input Stream #0.0 : stereo
Input #0, wav, from 'music.wav':
  Metadata:
    artist          : Simon &amp; Garfunkel
    genre           : pop
    title           : The Sounds of Silence
    album           : Greatest Hits
    encoder         : Lavf58.45.100
  Duration: 00:03:04.92, bitrate: 1411 kb/s
    Stream #0:0: Audio: pcm_s16le ([1][0][0][0] / 0x0001), 44100 Hz, stereo, s16, 1411 kb/s
Stream mapping:
  Stream #0:0 -> #0:0 (pcm_s16le (native) -> pcm_s16le (native))
Press [q] to stop, [?] for help
Output #0, wav, to 'musicshort.wav':
  Metadata:
    IART            : Simon &amp; Garfunkel
    IGNR            : pop
    INAM            : The Sounds of Silence
    IPRD            : Greatest Hits
    ISFT            : Lavf58.45.100
    Stream #0:0: Audio: pcm_s16le ([1][0][0][0] / 0x0001), 44100 Hz, stereo, s16, 1411 kb/s
    Metadata:
      encoder         : Lavc58.91.100 pcm_s16le
size=   18777kB time=00:01:49.00 bitrate=1411.2kbits/s speed=3.19e+03x    
video:0kB audio:18777kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.000895%
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ls
musicshort.wav  Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3
music.wav       transformer-translation-29May2021.mp4
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ffmpeg -i ./ -i balipraiavid.wav -map 0:v:0 -map 1:a:0 
musicshort.wav                                 Simon-amp-Garfunkel-The-Sounds-of-Silence.mp3  
music.wav                                      transformer-translation-29May2021.mp4          
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ ffmpeg -i ./transformer-translation-29May2021.mp4 -i ./musicshort.wav -map 0:v:0 -map 1:a:0 output.mp4
ffmpeg version 4.3.1-4ubuntu1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 10 (Ubuntu 10.2.0-9ubuntu2)
  configuration: --prefix=/usr --extra-version=4ubuntu1 --toolchain=hardened --libdir=/usr/lib/x86_64-linux-gnu --incdir=/usr/include/x86_64-linux-gnu --arch=amd64 --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libdav1d --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librabbitmq --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-pocketsphinx --enable-libmfx --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-nvenc --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared
  libavutil      56. 51.100 / 56. 51.100
  libavcodec     58. 91.100 / 58. 91.100
  libavformat    58. 45.100 / 58. 45.100
  libavdevice    58. 10.100 / 58. 10.100
  libavfilter     7. 85.100 /  7. 85.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  7.100 /  5.  7.100
  libswresample   3.  7.100 /  3.  7.100
  libpostproc    55.  7.100 / 55.  7.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from './transformer-translation-29May2021.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf58.45.100
  Duration: 00:01:49.90, start: 0.000000, bitrate: 7195 kb/s
    Stream #0:0(und): Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1828x998, 7194 kb/s, 10 fps, 10 tbr, 10240 tbn, 20 tbc (default)
    Metadata:
      handler_name    : VideoHandler
Guessed Channel Layout for Input Stream #1.0 : stereo
Input #1, wav, from './musicshort.wav':
  Metadata:
    artist          : Simon &amp; Garfunkel
    genre           : pop
    title           : The Sounds of Silence
    album           : Greatest Hits
    encoder         : Lavf58.45.100
  Duration: 00:01:49.00, bitrate: 1411 kb/s
    Stream #1:0: Audio: pcm_s16le ([1][0][0][0] / 0x0001), 44100 Hz, stereo, s16, 1411 kb/s
Stream mapping:
  Stream #0:0 -> #0:0 (h264 (native) -> h264 (libx264))
  Stream #1:0 -> #0:1 (pcm_s16le (native) -> aac (native))
Press [q] to stop, [?] for help
[libx264 @ 0x5595e450cec0] using cpu capabilities: MMX2 SSE2Fast SSSE3 SSE4.2 AVX FMA3 BMI2 AVX2
[libx264 @ 0x5595e450cec0] profile High, level 4.0, 4:2:0, 8-bit
[libx264 @ 0x5595e450cec0] 264 - core 160 r3011 cde9a93 - H.264/MPEG-4 AVC codec - Copyleft 2003-2020 - http://www.videolan.org/x264.html - options: cabac=1 ref=3 deblock=1:0:0 analyse=0x3:0x113 me=hex subme=7 psy=1 psy_rd=1.00:0.00 mixed_ref=1 me_range=16 chroma_me=1 trellis=1 8x8dct=1 cqm=0 deadzone=21,11 fast_pskip=1 chroma_qp_offset=-2 threads=12 lookahead_threads=2 sliced_threads=0 nr=0 decimate=1 interlaced=0 bluray_compat=0 constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1 open_gop=0 weightp=2 keyint=250 keyint_min=10 scenecut=40 intra_refresh=0 rc_lookahead=40 rc=crf mbtree=1 crf=23.0 qcomp=0.60 qpmin=0 qpmax=69 qpstep=4 ip_ratio=1.40 aq=1:1.00
Output #0, mp4, to 'output.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf58.45.100
    Stream #0:0(und): Video: h264 (libx264) (avc1 / 0x31637661), yuv420p(progressive), 1828x998, q=-1--1, 10 fps, 10240 tbn, 10 tbc (default)
    Metadata:
      handler_name    : VideoHandler
      encoder         : Lavc58.91.100 libx264
    Side data:
      cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: N/A
    Stream #0:1: Audio: aac (LC) (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 128 kb/s
    Metadata:
      encoder         : Lavc58.91.100 aac
frame= 1099 fps= 70 q=-1.0 Lsize=  100929kB time=00:01:49.60 bitrate=7543.9kbits/s speed=6.97x    
video:99167kB audio:1714kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.046618%
[libx264 @ 0x5595e450cec0] frame I:8     Avg QP:17.81  size:391054
[libx264 @ 0x5595e450cec0] frame P:592   Avg QP:21.66  size:147412
[libx264 @ 0x5595e450cec0] frame B:499   Avg QP:21.61  size: 22345
[libx264 @ 0x5595e450cec0] consecutive B-frames: 29.1% 24.9% 18.3% 27.7%
[libx264 @ 0x5595e450cec0] mb I  I16..4: 27.8%  3.6% 68.6%
[libx264 @ 0x5595e450cec0] mb P  I16..4:  5.8%  4.2% 19.8%  P16..4: 12.8%  8.1%  5.8%  0.0%  0.0%    skip:43.6%
[libx264 @ 0x5595e450cec0] mb B  I16..4:  0.9%  0.6%  2.4%  B16..8: 14.9%  2.3%  1.3%  direct: 0.5%  skip:77.0%  L0:49.7% L1:47.1% BI: 3.2%
[libx264 @ 0x5595e450cec0] 8x8 transform intra:13.8% inter:7.7%
[libx264 @ 0x5595e450cec0] coded y,uvDC,uvAC intra: 47.2% 67.0% 64.3% inter: 8.0% 10.2% 8.2%
[libx264 @ 0x5595e450cec0] i16 v,h,dc,p: 54% 44%  2%  0%
[libx264 @ 0x5595e450cec0] i8 v,h,dc,ddl,ddr,vr,hd,vl,hu: 22% 16% 60%  1%  0%  0%  0%  0%  1%
[libx264 @ 0x5595e450cec0] i4 v,h,dc,ddl,ddr,vr,hd,vl,hu: 28% 19% 24%  3%  5%  6%  7%  4%  5%
[libx264 @ 0x5595e450cec0] i8c dc,h,v,p: 60% 17% 22%  2%
[libx264 @ 0x5595e450cec0] Weighted P-Frames: Y:0.0% UV:0.0%
[libx264 @ 0x5595e450cec0] ref P L0: 45.7%  4.1% 28.9% 21.3%
[libx264 @ 0x5595e450cec0] ref B L0: 72.1% 20.2%  7.8%
[libx264 @ 0x5595e450cec0] ref B L1: 96.9%  3.1%
[libx264 @ 0x5595e450cec0] kb/s:7391.92
[aac @ 0x5595e450e180] Qavg: 175.352
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/Videos/add-sound$ mv ./output.mp4 transformer-plus-the-sounds-of-silence.mp4
```

