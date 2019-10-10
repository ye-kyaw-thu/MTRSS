# Note for Evaluations with BLEU, RIBES and charF

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

## Evaluation with BLEU

BLEU: Bilingual Evaluation Understudy  
Several scripts for calculating BLEU scores such as NIST-BLEU, IBM-BLEU, Multi-BLEU ...  

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ ls /home/lar/tool/moses/scripts/generic/mteval-v1
mteval-v11b.pl  mteval-v12.pl   mteval-v13a.pl  mteval-v14.pl
```

Help option:
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ perl /home/lar/tool/moses/scripts/generic/mteval-v13a.pl
MT evaluation scorer began on 2019 Oct 10 at 10:39:47
command line:  /home/lar/tool/moses/scripts/generic/mteval-v13a.pl 
Error in command line:  ref_file not defined

Usage: /home/lar/tool/moses/scripts/generic/mteval-v13a.pl -r <ref_file> -s <src_file> -t <tst_file>

Description:  This Perl script evaluates MT system performance.

Required arguments:
  -r <ref_file> is a file containing the reference translations for
      the documents to be evaluated.
  -s <src_file> is a file containing the source documents for which
      translations are to be evaluated
  -t <tst_file> is a file containing the translations to be evaluated

Optional arguments:
  -h prints this help message to STDOUT
  -c preserves upper-case alphabetic characters
  -b generate BLEU scores only
  -n generate NIST scores only
  -d detailed output flag:
         0 (default) for system-level score only
         1 to include document-level scores
         2 to include segment-level scores
         3 to include ngram-level scores
  -e enclose non-ASCII characters between spaces
  --brevity-penalty ( closest | shortest )
         closest (default) : acts as IBM BLEU (takes the closest reference translation length)
         shortest : acts as previous versions of the script (takes the shortest reference translation length)
  --international-tokenization
         when specified, uses Unicode-based (only) tokenization rules
         when not specified (default), uses default tokenization (some language-dependant rules)
  --metricsMATR : create three files for both BLEU scores and NIST scores:
         BLEU-seg.scr and NIST-seg.scr : segment-level scores
         BLEU-doc.scr and NIST-doc.scr : document-level scores
         BLEU-sys.scr and NIST-sys.scr : system-level scores
  --no-smoothing : disable smoothing on BLEU scores
```

## Note relating to mteval-v13a.pl

Input: SGM XML Format  
Word Segmentation: NIST Tokenizer  
N-gram Order: Minimum 4-gram  
Option: Support NIST Score  
Smoothing: NIST Geometric SCoring  

Ref: [https://stackoverflow.com/questions/46084574/what-is-the-difference-between-mteval-v13a-pl-and-nltk-bleu](https://stackoverflow.com/questions/46084574/what-is-the-difference-between-mteval-v13a-pl-and-nltk-bleu)

-----

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

## RIBES Score Calculation for Myanmar-Rakhine PBSMT

```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/RIBES-1.03.1/RIBES.py -r ./data/test.rk ./baseline/my-rk/evaluation/test.cleaned.1
# RIBES evaluation start at 2019-10-10 10:12:26.477757
0.902317 alpha=0.250000 beta=0.100000 ./baseline/my-rk/evaluation/test.cleaned.1
# RIBES evaluation done at 2019-10-10 10:12:26.846261
```

## RIBES Score Calculation for Rakhine-Myanmar PBSMT

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
သူ |0-0| အမှန်အတိုင်း |1-1| မ |2-2| ကျိန်ဆို |3-3| ရဲ |4-4| ပါလား |5-
5| ။ |6-6| 
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

## Reference

Hideki Isozaki, Tsutomu Hirao, Kevin Duh, Katsuhito Sudoh, Hajime Tsukada  
Automatic Evaluation of Translation Quality for Distant Language Pairs  
Conference on Empirical Methods on Natural Language Processing (EMNLP), Oct. 2010.  
[https://www.aclweb.org/anthology/D10-1092.pdf](https://www.aclweb.org/anthology/D10-1092.pdf)  

-----------

## Evaluation with chrF

chrF: a tool for calcualting character n-gram F score  

Download link:  
[https://github.com/m-popovic/chrF](https://github.com/m-popovic/chrF)  

How to run:  
chrF++.py -R example.ref.en -H example.hyp.en  

### chrF Evaluation for Myanmar-Rakhine PBSMT
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/chrF/chrF++.py -R ./data/test.rk -H ./baseline/my-rk/evaluation/test.cleaned.1 
start_time:	1570675516
c6+w2-F2	80.2834
c6+w2-avgF2	81.3348
end_time:	1570675516
```

### chrF Evaluation for Rakhine-Myanmar PBSMT
```
lar@lar-air:/media/lar/Transcend/student/lecture/mtrss/pbsmt-demo/MTRSS/pbsmt$ python /home/lar/tool/chrF/chrF++.py -R ./data/test.my -H ./baseline/rk-my/evaluation/test.cleaned.1 
start_time:	1570675534
c6+w2-F2	77.9372
c6+w2-avgF2	78.4115
end_time:	1570675534
```

### Refernce for calculation of chrF


Maja Popovic:  
chrF: character n-gram F-score for automatic MT evaluation. WMT@EMNLP 2015: 392-395  
[https://www.aclweb.org/anthology/W15-3049.pdf](https://www.aclweb.org/anthology/W15-3049.pdf)  

Maja Popovic:  
chrF deconstructed: beta parameters and n-gram weights. WMT 2016: 499-504  
[https://www.aclweb.org/anthology/W16-2341.pdf](https://www.aclweb.org/anthology/W16-2341.pdf)  

Maja Popovic:  
chrF++: words helping character n-grams. WMT 2017: 612-618  
[https://www.aclweb.org/anthology/W17-4770.pdf](https://www.aclweb.org/anthology/W17-4770.pdf)  

