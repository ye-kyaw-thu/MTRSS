## git clone my-rk original parallel corpus:

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo$ git clone https://github.com/ye-kyaw-thu/myPar
Cloning into 'myPar'...  
remote: Enumerating objects: 72, done.  
remote: Counting objects: 100% (72/72), done.  
remote: Compressing objects: 100% (66/66), done.  
remote: Total 72 (delta 27), reused 0 (delta 0), pack-reused 0  
Unpacking objects: 100% (72/72), done.
Checking connectivity... done.
```

## list my-rk parallel data 

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/myPar/my-rk/ver-0.1$ ls
dev.my  dev.rk  test.my  test.rk  tmp  train.my  train.rk
```

## Copy original my-rk parallel data into data/

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/myPar/my-rk/ver-0.1$ cp * ../../../data/
```

### Check original corpus size

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ wc *
   2485   17104  286978 dev.my
   2485   16795  282388 dev.rk
   1812   12478  208710 test.my
   1812   12275  205385 test.rk
      1       0       1 tmp
  14076   95738 1588605 train.my
  14076   93957 1567486 train.rk
  36747  248347 4139553 total
lar@lar-air:/media/lar/Transcen
```

### Write a shell script for making a small corpus

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ vi ./make-small-corpus.sh
```

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ cat ./make-small-corpus.sh 
#!/bin/bash

mkdir small-corpus

head -n 5000 ./train.my > ./small-corpus/train.my
head -n 500 ./dev.my > ./small-corpus/dev.my
head -n 100 ./test.my > ./small-corpus/test.my

head -n 5000 ./train.rk > ./small-corpus/train.rk
head -n 500 ./dev.rk > ./small-corpus/dev.rk
head -n 100 ./test.rk > ./small-corpus/test.rk
```

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ chmod +x ./make-small-corpus.sh 
```

### run shell script for making a small corpus for running 

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ ./make-small-corpus.sh 
```

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data$ ls
dev.my  dev.rk  make-small-corpus.sh  small-corpus  test.my  test.rk  tmp  train.my  train.rk
```

### Check the output files

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data/small-corpus$ wc *
    500    3454   57964 dev.my
    500    3397   57216 dev.rk
    100     667   10887 test.my
    100     661   10633 test.rk
   5000   33847  561195 train.my
   5000   33302  554426 train.rk
  11200   75328 1252321 total
```

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data/small-corpus$ head -2 ./*.my

==> ./dev.my <==
ကျွန်တော် မနက်ဖြန် ကား အသစ် တွေ သွား ကြည့် မလို့ ။
မင်း ဘာ တွေ သတင်းပေး မှာလဲ ။

==> ./test.my <==
သူ အမှန်အတိုင်း မ ကျိန်ဆို ရဲ ဘူးလား ။
ကျွန်တော်သာဆို ပြန်ပေး လိုက်မှာ ။

==> ./train.my <==
မင်း အဲ့ဒါ ကို အခြား တစ်ခုနဲ့ မ ချိတ် ဘူးလား ။
သူမ ဘယ်သူ့ကိုမှ မ မှတ်မိတော့ဘူး ။
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/data/small-corpus$ head -2 ./*.rk
==> ./dev.rk <==
ကျွန်တော် နက်ဖန် ကား အသစ် တိ လား ကြည့် ဖို့လို့ ။
မင်း ဇာ တိ သတင်းပီး ဖို့လေး။

==> ./test.rk <==
သူ အမှန်အတိုင်း မ ကျိန်ဆို ရဲ  ပါလား။
ကျွန်တော်ဆိုကေ ပြန်ပီး လိုက်ဖို့ ။

==> ./train.rk <==
မင်း ယင်းချင့် ကို အခြား တစ်ခုနန့်  မ ချိတ် ပါလား ။
ထိုမချေ   တစ်ယောက်လေ့  မ မှတ်မိပါယာ ။
```

####################

# I don't want to keep small-corpus/ folder as a backup
# and thus, I copied that folder for running PBSMT

lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt/data$ cp ../../data/small-corpus/* .
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt/data$ ls
dev.my  dev.rk  test.my  test.rk  train.my  train.rk

-----

## Prepare SGML test files

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt/data/test-gen$ ./generate_sgms.pl
```

## After you running you will get .SGM files

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt/data/test-sgm$ ls *.sgm
test.my.ref.sgm  test.my.src.sgm  test.rk.ref.sgm  test.rk.src.sgm
```

## Updating path of perl programs

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt$ ls
data  generate_configs.pl  run-baseline.pl  run-pbsmt.sh
```

```
vi ./generate_configs.pl
vi ./run-baseline.pl

```
### Run 1st time PBSMT Experiment with Myanmar-Rakhine small corpus

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/pbsmt$ ./run-pbsmt.sh
```

