# Note for Evaluations

## Checking Report File of Moses

### for Myanmar-Rakhine PBSMT BLEU Score
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt/baseline/my-rk/evaluation$ cat report.1 
test: 56.26 (1.003) BLEU-c ; 56.26 (1.003) BLEU
```

### for Rakhine-Myanmar PBSMT BLEU Score
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt/baseline/rk-my/evaluation$ cat report.1 
test: 56.40 (1.001) BLEU-c ; 56.40 (1.001) BLEU
```

## Evaluation with RIBES Score

RIBES: Rank-based Intuitive Bilingual Evaluation Score

Download link is as follows:
[http://www.kecl.ntt.co.jp/icl/lirg/ribes/](http://www.kecl.ntt.co.jp/icl/lirg/ribes/)

After you downloaded, untar the .tar.gz file:
```
lar@lar-air:~/tool$ mv ~/Downloads/RIBES-1.03.1.tar.gz .
lar@lar-air:~/tool$ tar -xzvf ./RIBES-1.03.1.tar.gz 
RIBES-1.03.1/
RIBES-1.03.1/RIBES.py
RIBES-1.03.1/LICENSE
```

### How to run  
```
$ python RIBES.py -r REFERENCE_TRANSLATION EVALUATING_TRANSLATION
```

### for help
```
$ python RIBES.py -h
```

## RIBES Score Calculation for my-rk PBSMT

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/RIBES-1.03.1/RIBES.py -r ./data/test.rk ./baseline/my-rk/evaluation/test.cleaned.1
# RIBES evaluation start at 2019-10-10 10:12:26.477757
0.902317 alpha=0.250000 beta=0.100000 ./baseline/my-rk/evaluation/test.cleaned.1
# RIBES evaluation done at 2019-10-10 10:12:26.846261
```

## RIBES Score Calculation for rk-my PBSMT

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/RIBES-1.03.1/RIBES.py -r ./data/test.my ./baseline/rk-my/evaluation/test.cleaned.1
# RIBES evaluation start at 2019-10-10 10:17:19.585608
0.907448 alpha=0.250000 beta=0.100000 ./baseline/rk-my/evaluation/test.cleaned.1
# RIBES evaluation done at 2019-10-10 10:17:19.947768
```

## Check the Hyphothesis Filename Carefully

Example error:
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/RIBES-1.03.1/RIBES.py -r ./data/test.rk ./baseline/my-rk/evaluation/test.output.1
# RIBES evaluation start at 2019-10-10 10:11:32.309000
0.765147 alpha=0.250000 beta=0.100000 ./baseline/my-rk/evaluation/test.output.1
# RIBES evaluation done at 2019-10-10 10:11:32.684895
```

In PBSMT, test.output.1 is not the file that we need for evaluation!

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ head ./baseline/my-rk/evaluation/test.output.1
သူ |0-0| အမှန်အတိုင်း |1-1| မ |2-2| ကျိန်ဆို |3-3| ရဲ |4-4| ပါလား |5-5| ။ |6-6| 
ကျွန်တော်သာဆို |0-0| ပြန် ပီး |1-1| လိုက်မှာ |2-2| ။ |3-3| 
ဆူပြီးတဲ့ |0-0| ရေကို |1-1| သောက် |2-2| သင့်ရေ |3-3| ။ |4-4| 
မင်း |0-0| မေးစရာ |1-1| မ |2-2| လို |3-3| ပါ။ |4-5| 
ထိုမချေ |0-0| ကို |1-1| သူ |2-2| အဂယောင့် |3-3| မ |4-4| မြတ်နိုး |5-5| လာခပါ |6-6| ။ |7-7| 
ကိုယ် |0-0| မင်း |1-1| ကို |2-2| နားလည် |3-3| ပါရေ |4-4| ။ |5-5| 
ငါ |0-0| အလုပ် |1-1| မ |2-2| ပြီး သိ |3-4| ပါ |5-5| ။ |6-6| 
ကျွန်တော် |0-0| ဘတ်စ်ကား |1-1| အတွက် |2-2| အကြွီး |3-3| အချို့ |4-4| လို |5-5| ချင်လို့ပါ |6-6| ။ |7-7| 
မိုး |0-0| ချက်ချင်း |1-1| ရွာတဲ့အခါ |2-2| သူရို့ဘာတွေ |3-3| လုပ် |4-4| နီစွာလေး |5-5| ။ |6-6| 
မင်း |0-0| တောင်တွေကို |1-1| တက်နေ |2-2| ကျလား |3-3| ။ |4-4| 
```
