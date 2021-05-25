# Experiment with Setting B

ပထမပိုင်း experiment တွေက Training ဒေတာက ALT training data မပါပဲ run ခဲ့တာ။
အခု ရလဒ်တွေက UCSY+ALT ...

## Adding ALT Training Data with UCSY Training Data

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021$ ls
data      dict     exp-syl2  exp-syl4       exp-syl5  exp-syl7   hiero     osm     result-note.txt  thinking  tree-tmp
data.zip  exp-syl  exp-syl3  exp-syl4-tran  exp-syl6  exp-word1  note.txt  result  sys-combi        tree-smt  wer
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021$ cd exp-syl4
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4$ ls
baseline  config.baseline  data  generate_configs.pl  nohup.out  run1.log  run-baseline.pl  run.sh  steps
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4$ mv baseline/ baseline-no-alt

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ mkdir add-alt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ mv ./train.my ./add-alt/
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ mv ./train.en ./add-alt/
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ cd add-alt/
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt/add-alt$ pwd
/home/ye/exp/smt/wat2021/exp-syl4/data-alt/add-alt

Copying ...
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ cp alt.train.ready.{my,en} /home/ye/exp/smt/wat2021/exp-syl4/data-alt/add-alt/

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt/add-alt$ cat ./train.my ./alt.train.ready.my > ../train.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt/add-alt$ cat ./train.en ./alt.train.ready.en > ../train.en
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt/add-alt$ cd ..
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ wc ./train.{my,en}
  256102  7324636 70957711 ./train.my
  256102  3770260 19768494 ./train.en
  512204 11094896 90726205 total
```

## Check Roughly

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ tail ./train.my
မ တီ ကိုင် တောင့် ကန် မို လ ကီ လို သည် ၇၄ မိ နစ် အ တွင်း အ မေ ရိ ကန် နိုင် ငံ အ တွက် အ နိုင် ရ ယူ နိုင် ခဲ့ သည် ။
ဘု ရင် ခံ ဂျွန် ကော် ဇိုင်း က ပင် မ က လပ် စည်း သု တေ သ န သို့ အ မေ ရိ ကန် ဒေါ် လာ ၂၇၀ မီ လီ ယမ် ထောက် ပံ လိမ့် မည် ဟု ငွေ ပ မာ ဏ ကြေ ငြာ ခဲ့ သည် ။
“ ကျွန် တော် န ယူး ဂျာ စီ ကို ပင် မ က လပ် စည်း သု တေ သ န ဖော် ပြ ချက် များ ၏ အ စု အ ဝေး တွင် ပါ ဝင် ဖို့ မ လို လား ပါ ၊ န ယူး ဂျာ စီ ဒါ ကို ဦး ဆောင် ဖို့ ကျွန် တော် လို လား ပါ သည် ” ၊ သူ ကြေ ငြာ ခဲ့ သည် ။
ကော် ဇိုင်း ကြေ ငြာ ခဲ့ ပြီး နောက် ကြော ငြာ ချက် ၂ ရက် အ ရောက် တွင် စီး ပွား ရေး သ တင်း ပတ် မှ သ တင်း တင် ပြ သည် မှာ ပြည် နယ် မှ ပင် မ က လပ် စည်း သု တေ သ န အ တွက် အ မေ ရိ ကန် ဒေါ် လာ ၇ မီ လီ ယမ် အ ပါ အ ဝင် ၊ နောက် နှစ် သု တေ သ န ထောက် ပံ့ မှု များ တွင် အ မေ ရိ ကန် ဒေါ် လာ ၁၀ မီ လီ ယမ် ထုတ် ပေး လိမ့် မည် ။
ဓာတ် ရ ထား မောင်း နှင် သူ တစ် ဦး အ ဖြစ် အ လုပ် လုပ် ရန် ခွင့် ပြု ခြင်း မ ခံ ရ သည့် အ သက် ၁၅ နှစ် အ ရွယ် ကောင် လေး တစ် ယောက် သည် ဩ စ တြေး လျ ဓာတ် ရ ထား ၊ မဲလ် ဘုန်း ကို ခိုး ခဲ့ သည် နှင့် အ ညီ ၎င်း အ ဖြစ် အ ပျက် အ တွက် ဆက် စပ် သော သူ ၏ ပြစ် မှု ကိုး ခု ရှိ လင့် က စား မိ နစ် ၄၀ ခန့် ခ ရီး သည် များ အ သွား နှင့် အ ပြန် အ တွက် မောင်း နှင် ခဲ့ သည် ။
“ ကျွန် တော် တို့ မှာ အ ရမ်း ကို ကောင်း မွန် တဲ့ အ လုပ် သ မား စု ဆောင်း ရေး မူ ဝါ ဒ တစ် ခု ရှိ ပြီး ကျွန် တော် တို့ ရဲ့ အ လုပ် သ မား စု ဆောင်း ရေး မူ ဝါ ဒ အ တွက် စည်း မျဉ်း တွေ ကို အောင် မြင် တဲ့ မည် သူ မ ဆို ယာဉ် မောင်း လိုင် စင် တစ် ခု ကိုင် ဆောင် ဖို့ အ သက် လုံ လောက် တဲ့ သူ ကို ထောက် ပံ့ ခဲ့ ၍ အ လုပ် ပေး ဖို့ ကျွန် တော် တို့ က ဝမ်း မြောက် ပါ သည် ဟု ၊ ” ရာ ရ ဓာတ် ရ ထား ဒု တိ ယ ကာ ကွယ် ရေး ဦး စီး ချုပ် ၊ ဒန်း နစ် ချီ ချီ ၊ မှ ဩ စ တြေး လျ ပူး ပေါင်း ဖြန့် ချီ မှု သ တင်း စာ သို့ တ နင်္လာ နေ့ တွင် ပြော ကြား ခဲ့ သည် ။
ဗစ် တိုး ရီး ယား ရဲ ၏ အ ကြီး တန်း ပု လိပ် စုံ ထောက် ဘယ် ရီ ဟေး က ၊ ကောင် လေး အ ကြောင်း ပြော ခဲ့ သည် မှာ ၊ “ သူ က လူ ကောင်း လေး တစ် ယောက် ဖြစ် သည် ၊ သူ က ဖြောင့် မတ် တဲ့ ကောင် လေး တစ် ယောက် ဖြစ် သည် ။ ”
“ သူ့ ရဲ့ အ စွဲ အ လမ်း က သူ့ ကို လုံး ဝ ပို ကောင်း စေ အောင် လုပ် တယ် လို့ ငါ ထင် တယ် ။ ”
ရ ထား လမ်း သို့ လျှပ် စစ် မီး ဖြတ် တောက် ခဲ့ သည့် အ ခါ ၊ ၎င်း ဓာတ် ရ ထား အ ခိုး ခံ ခဲ့ ရ သည့် နေ ရာ မှ ၁၅ ကီ လို မီ တာ အ ကွာ ၊ ကော် အ ရှေ့ ဆင် ခြေ ဖုံး တွင် ရဲ များ မှ တ နင်္ဂ နွေ နေ့ ည တွင် ဖမ်း ဆီး ခံ ခဲ့ သော ကောင် လေး သည် ၊ ရာ ရ တ ရား ဝင် ဓာတ် ရ ထား လိုင်း ယူ နီ ဖောင်း များ နှင့် ဆင် တူ သည့် ဂျာ ကင် အ ကျီ ကို ဝတ် ဆင် ထား ကြောင်း ဖော် ပြ ခဲ့ သည် ။
သူ လည်း ပဲ မယ် ဘုန်းလ် တောင် ပိုင်း ရ ထား ဘူ တာ မှ ၊ သော ကြာ နေ့ ည တွင် ဓာတ် ရ ထား တစ် စီး ခိုး ခြင်း ကြောင့် တ ရား စွဲ ခံ ရ ခဲ့ သည် ။
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ tail ./train.en
Matekitonga Moeakiola scored for the Americans in the 74th minute.
Governor Jon Corzine announced a bill that would provide $270 million to stem cell research.
He announced, &quot;I don&apos;t want New Jersey to join the crowd of stem cell research states, I want New Jersey to lead it.&quot;
BusinessWeek reports that the announcement came two days after Corzine announced that the state will give out $10 million in research grants next year, including $7 million for stem cell research.
A 15-year-old boy who allegedly stole a Melbourne, Australia tram and drove for 40 minutes picking up and setting down passengers, may yet be allowed to work as a tram driver, despite his nine charges related to the incident.
&quot;We have a very good recruiting policy and anybody who passes the muster for our recruiting policy we&apos;d be glad to offer a job to, provided he&apos;s old enough to hold a driver&apos;s license,&quot; Yarra Trams Deputy Chief Executive, Dennis Cliche, told Australian Associated Press on Monday.
Detective Senior Constable Barry Hills of Victoria Police, said of the boy, &quot;He&apos;s a nice lad, he&apos;s a good lad.&quot;
&quot;I think his obsession just got the better of him.&quot;
Described as wearing a jacket similar to official Yarra Trams uniforms, the boy was caught on Sunday night by police in east suburban Kew, 15km from where the tram was stolen, when electricity was shut off to the route.
He is also accused of stealing a tram on Friday night, from South Melbourne depot.
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-alt$ 
```

## Updating

```
ပထမတော့ config ဖိုင်မှာ data-alt/ ထားပြီး run ဖို့ စဉ်းစားခဲ့ပေမဲ့... data/ နဲ့ပဲ run တာက ပို safe ဖြစ်လို့
အချိန်လည်း လုနေရလို့...

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4$ mv data data-without-alt
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4$ mv data-alt data

config ဖိုင် ကိုတော့ နာမည်ပြောင်းသိမ်းခဲ့...

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4$ mv config.baseline without-alt.config.baseline
```

## SMT PBSMT Training

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/baseline/en-my/evaluation$ cat test.multi-bleu.1 
BLEU = 23.93, 59.1/31.5/17.5/10.1 (BP=1.000, ratio=1.000, hyp_len=58909, ref_len=58895)

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/baseline/my-en/evaluation$ cat ./test.multi-bleu.1 
BLEU = 9.16, 44.3/13.5/5.4/2.2 (BP=1.000, ratio=1.062, hyp_len=29668, ref_len=27929)
```
## Evaluation

[en-my]  
--xml-input exclusive  
Result of -xml-input exclusive:  
BLEU = 26.82, 61.3/34.4/20.1/12.2 (BP=1.000, ratio=1.018, hyp_len=59983, ref_len=58895)  

-xml-input inclusive  
Result of -xml-input inclusive:  
BLEU = 27.33, 61.7/34.9/20.6/12.6 (BP=1.000, ratio=1.023, hyp_len=60260, ref_len=58895)  

[my-en]  
Result of -xml-input exclusive:  
BLEU = 10.40, 45.5/14.8/6.3/2.8 (BP=1.000, ratio=1.093, hyp_len=30536, ref_len=27929)  

Result of -xml-input inclusive:  
BLEU = 11.72, 49.7/16.7/7.2/3.2 (BP=1.000, ratio=1.022, hyp_len=28542, ref_len=27929)  


## OSM Training

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/osm/osm/en-my/evaluation$ cat test.multi-bleu.1 
BLEU = 23.45, 58.5/30.9/17.1/9.8 (BP=1.000, ratio=1.009, hyp_len=59442, ref_len=58895)

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/osm/osm/my-en/evaluation$ cat test.multi-bleu.1 
BLEU = 9.70, 45.1/13.8/5.7/2.5 (BP=1.000, ratio=1.037, hyp_len=28959, ref_len=27929)
```

[en-my]  
-xml-input exclusive  
Result of -xml-input exclusive:  
BLEU = 25.99, 61.0/33.5/19.4/11.5 (BP=1.000, ratio=1.020, hyp_len=60057, ref_len=58895)  

-xml-input inclusive  
Result of -xml-input inclusive:  
BLEU = 25.78, 60.5/33.3/19.2/11.4 (BP=1.000, ratio=1.039, hyp_len=61169, ref_len=58895)  

[my-en]  

PBSMT တုန်းက ပြင်ထားတဲ့ test.xml.my ကိုပဲ ယူသုံးခဲ့...  
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/osm/osm/my-en/evaluation$ ~/tool/mosesbin/ubuntu-17.04/moses/bin/moses -xml-input exclusive -i ~/exp/smt/wat2021/exp-syl4/baseline/my-en/xml/test.xml.my -f ./test.filtered.ini.1 > en-my.xml.hyp1

-xml-input exclusive
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/osm/osm/my-en/evaluation$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./en-my.xml.hyp1
BLEU = 10.91, 45.8/14.9/6.6/3.2 (BP=1.000, ratio=1.068, hyp_len=29823, ref_len=27929)
```

-xml-input inclusive  
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/osm/osm/my-en/evaluation$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./en-my.xml.hyp2
BLEU = 11.36, 49.0/16.0/6.8/3.1 (BP=1.000, ratio=1.004, hyp_len=28052, ref_len=27929)
```


## HPBSMT Training

Decoding မှာ error ပေးပြီး ရပ်သွားတာကို တွေ့ရလို့...

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/en-my/evaluation$ ~/tool/mosesbin/ubuntu-17.04/moses/bin/moses_chart -i ./test.input.txt.1 -f ../evaluation/test.filtered.ini.1 > en-my.hiero.baseline1

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/en-my/evaluation$ wc ./en-my.hiero.baseline1 
  1018  58564 547752 ./en-my.hiero.baseline1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/en-my/evaluation$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./en-my.hiero.baseline1 
BLEU = 23.85, 59.3/31.7/17.5/10.0 (BP=0.994, ratio=0.994, hyp_len=58564, ref_len=58895)

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/my-en/evaluation$ ~/tool/mosesbin/ubuntu-17.04/moses/bin/moses_chart -i ./test.input.txt.1 -f ../evaluation/test.filtered.ini.1 > ./my-en.hiero.baseline1

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/my-en/evaluation$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./my-en.hiero.baseline1 
BLEU = 10.53, 46.4/15.5/6.4/2.7 (BP=1.000, ratio=1.047, hyp_len=29231, ref_len=27929)
```

Path info:  
/home/ye/exp/smt/wat2021/hiero/hiero/en-my/xml  

[en-my]  
-xml-input exclusive  
Result of HPBSMT -xml-input exclusive:  
BLEU = 27.98, 62.5/35.6/21.2/13.0 (BP=1.000, ratio=1.017, hyp_len=59899, ref_len=58895)  

-xml-input inclusive  
Result of HPBSMT -xml-input inclusive:  
BLEU = 27.98, 62.5/35.6/21.2/13.0 (BP=1.000, ratio=1.017, hyp_len=59899, ref_len=58895)  


[my-en]  
-xml-input exclusive  
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/my-en/xml$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./my-en.xml.hyp1
BLEU = 27.98, 62.5/35.6/21.2/13.0 (BP=1.000, ratio=1.017, hyp_len=59899, ref_len=58895)
```

-xml-input inclusive
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/hiero/hiero/my-en/xml$ perl ~/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl ./test.reference.txt.1 < ./my-en.xml.hyp2
BLEU = 27.98, 62.5/35.6/21.2/13.0 (BP=1.000, ratio=1.017, hyp_len=59899, ref_len=58895)
```

===================

## Data Statistic without ALT

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-without-alt$ wc *.my
    1000    57709   550454 dev.my
    1018    58895   561443 test.my
  238014  6285996 60847350 train.my
  240032  6402600 61959247 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data-without-alt$ wc *.en
    1000    27318   147768 dev.en
    1018    27929   151447 test.en
  238014  3357260 17186660 train.en
  240032  3412507 17485875 total
```

## Data with ALT (i.e. UCSY+ALT)

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
```

UCSY Train (#my words: 6,285,996, #en words: 3,357,260)  
ALT Train (#my words: 1,038,640, #en words: 413000)  

Dev (#my words: 57,709), (#en words: 27318)  
Test (#my words: 58,895), (#en words: 27929)  

## Preparing for Uploading

[PBSMT, en-my]  
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/en-my/evaluation/test.cleaned.1 ./pbsmt.withalt.enmy.hyp
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/en-my/xml/en-my.xml.hyp1 ./pbsmt.withalt.enmy.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/en-my/xml/en-my.xml.hyp2 ./pbsmt.withalt.enmy.xml.inclusive.hyp1
```

[PBSMT, my-en]
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/my-en/evaluation/test.cleaned.1 ./pbsmt.withalt.myen.hyp
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/my-en/xml/my-en.xml.hyp1 ./pbsmt.withalt.myen.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ../../exp-syl4/baseline/my-en/xml/my-en.xml.hyp2 ./pbsmt.withalt.myen.xml.inclusive.hyp2
```

[OSM, en-my]
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/en-my/evaluation/test.cleaned.1 ./osm.withalt.enmy.hyp
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/en-my/evaluation/xml/en-my.xml.hyp1 ./osm.withalt.enmy.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/en-my/evaluation/xml/en-my.xml.hyp2 ./osm.withalt.enmy.xml.exclusive.hyp2
```

[OSM, my-en]
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/my-en/evaluation/test.cleaned.1 ./osm.withalt.myen.hyp
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/my-en/evaluation/en-my.xml.hyp1 ./osm.withalt.myen.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp ~/exp/smt/wat2021/osm/osm/my-en/evaluation/en-my.xml.hyp2 ./osm.withalt.myen.xml.exclusive.hyp2
```

Note: ဖိုင်နာမည် en-my.xml.hyp1 run တုန်းက နာမည်ပေး မှားသွားတာ... ပြဿနာမဟုတ်ဘူး...  
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ head -n 3 ./osm.withalt.myen.xml.exclusive.hyp1
Sydney &amp; apos ; s Randwick horse racing Queen from Myo Thant won eight horse was horse influenza infected had to confirmed . 
Randwick were closed and 2 months long maintain hope to . 
very severe flu is always in Randwick by 700 horse in the contagious will guess . 
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ head -n 3 ./osm.withalt.myen.xml.exclusive.hyp2
Sydney Randwick racetrack from Myo Thant won eight horse was horse influenza infected had to confirmed . 
Randwick were closed and 2 months long maintain hope to . 
very severe flu is always in Randwick by 700 horse in the contagious will guess . 
```

[HPBSMT, en-my]
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp  ~/exp/smt/wat2021/hiero/hiero/en-my/evaluation/test.output.2 ./hiero.withalt.enmy.hyp 
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp  ~/exp/smt/wat2021/hiero/hiero/en-my/xml/en-my.xml.hyp1 ./hiero.withalt.enmy.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp  ~/exp/smt/wat2021/hiero/hiero/en-my/xml/en-my.xml.hyp2 ./hiero.withalt.enmy.xml.inclusive.hyp2
```

[HPBSMT, my-en]
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/pbsmt$ cp  ~/exp/smt/wat2021/hiero/hiero/my-en/evaluation/test.output.2 ./hiero.withalt.myen.hyp 
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/hiero$ cp /home/ye/exp/smt/wat2021/hiero/hiero/my-en/xml/my-en.xml.hyp1 ./hiero.withalt.myen.xml.exclusive.hyp1
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt/hiero$ cp /home/ye/exp/smt/wat2021/hiero/hiero/my-en/xml/my-en.xml.hyp2 ./hiero.withalt.myen.xml.inclusive.hyp2
```

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/final-result-with-alt$ tree
.
├── hiero
│   ├── hiero.withalt.enmy.hyp
│   ├── hiero.withalt.enmy.xml.exclusive.hyp1
│   ├── hiero.withalt.enmy.xml.inclusive.hyp2
│   ├── hiero.withalt.myen.hyp
│   ├── hiero.withalt.myen.xml.exclusive.hyp1
│   └── hiero.withalt.myen.xml.inclusive.hyp2
├── osm
│   ├── osm.withalt.enmy.hyp
│   ├── osm.withalt.enmy.xml.exclusive.hyp1
│   ├── osm.withalt.enmy.xml.inclusive.hyp2
│   ├── osm.withalt.myen.hyp
│   ├── osm.withalt.myen.xml.exclusive.hyp1
│   ├── osm.withalt.myen.xml.inclusive.hyp2
│   └── osm.withalt.myen.xml.inclusive.hyp2b
└── pbsmt
    ├── pbsmt.withalt.enmy.hyp
    ├── pbsmt.withalt.enmy.xml.exclusive.hyp1
    ├── pbsmt.withalt.enmy.xml.inclusive.hyp1
    ├── pbsmt.withalt.myen.hyp
    ├── pbsmt.withalt.myen.xml.exclusive.hyp1
    └── pbsmt.withalt.myen.xml.inclusive.hyp2

3 directories, 19 files
```


## Evaluation Results with WAT2021 Standard

*** UCSY Corpus Only Results  
BLEU, RIBES, AMFM  

en-my  
PBSMT baseline: 15.01, 0.519451, 0.550400  
xml-exclusive: 20.80, 0.551514, 0.653850  
xml-inclusive: 20.88, 0.553319, 0.655310  

en-my  
OSM baseline: 15.05, 0.528968, 0.557240  
xml-exclusive: 19.94, 0.540820, 0.651070  
xml-inclusive: 20.13, 0.545962, 0.654820  

en-my  
Hiero baseline: 14.83, 0.555290, 0.545900  
xml-exclusive: 21.02, 0.588198, 0.653840  
xml-inclusive: 21.02, 0.588198, 0.653840  

*** UCSY + ALT Results  
BLEU, RIBES, AMFM  

en-my  
PBSMT baseline: 20.80, 0.542406, 0.617900  
xml-exclusive: 24.54, 0.563854, 0.690020  
xml-inclusive: 25.11, 0.567187, 0.689400  

my-en  
PBSMT baseline: 5.00, 0.519789, 0.493530  
xml-exclusive: 6.32, 0.532525, 0.492900  
xml-inclusive: 7.43, 0.542773, 0.502980  
===========
en-my  
OSM baseline: 20.33, 0.550329, 0.622350  
xml-exclusive: 23.82, 0.554226, 0.691450  
xml-inclusive: 23.73, 0.556381, 0.691910  

my-en  
OSM baseline: 5.18, 0.523378, 0.479690  
xml-exclusive: 6.58, 0.536259, 0.474910  
xml-inclusive: 6.70, 0.541372, 0.491530  
===========  
en-my  
Hiero baseline: 20.29, 0.587136, 0.612400  
xml-exclusive: 25.48, 0.607339, 0.684110  
xml-inclusive: 25.48, 0.607339, 0.684110  

my-en  
Hiero baseline: 7.36, 0.555453, 0.497490  
xml-exclusive:   
xml-inclusive:   

=============

Error found for XML markup hyprid translation for my-en:

```
ERROR: tag np closed, but not opened:{{np translation="{{np translation="Berlin" prob="0.8"}}Berlin{{/np}}'s Neukoellner Opera House" prob="0.8"}}{{np translation="{{np translation="Berlin" prob="0.8"}}Berlin{{/np}}" prob="0.8"}}ဘာ လင်{{/np}} ရဲ့ နီ ကို အဲလ် နာ တေး သံ စုံ ပြ ဇာတ် ရုံ{{/np}} က ၎င်း ၏ ထုတ် လုပ် {{np translation="Yass" prob="0.8"}}ရေး{{/np}} အ သစ် ဖြစ် တဲ့ အ ဝါ ရောင် မင်း သ မီး ၊ နှ င့် အ တူ လှုပ် လှုပ် ရှား ရှား ဖြစ် စေ သည် ။
Unable to parse XML in line: {{np translation="{{np translation="Berlin" prob="0.8"}}Berlin{{/np}}'s Neukoellner Opera House" prob="0.8"}}{{np translation="{{np translation="Berlin" prob="0.8"}}Berlin{{/np}}" prob="0.8"}}ဘာ လင်{{/np}} ရဲ့ နီ ကို အဲလ် နာ တေး သံ စုံ ပြ ဇာတ် ရုံ{{/np}} က ၎င်း ၏ ထုတ် လုပ် {{np translation="Yass" prob="0.8"}}ရေး{{/np}} အ သစ် ဖြစ် တဲ့ အ ဝါ ရောင် မင်း သ မီး ၊ နှ င့် အ တူ လှုပ် လှုပ် ရှား ရှား ဖြစ် စေ သည် ။  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40 
```

{{ }} အစား { } ပြောင်းပြီး လုပ်ခဲ့လည်း error က ဆက်ရှိ အောက်ပါအတိုင်း  

```
39]=X (1) [38,40]=X (1) [39,39]=X (1) [39,40]=X (1) [40,40]=X (1) 

ERROR: tag np closed, but not opened:{np translation="{np translation="Berlin" prob="0.8"}Berlin{/np}'s Neukoellner Opera House" prob="0.8"}{np translation="{np translation="Berlin" prob="0.8"}Berlin{/np}" prob="0.8"}ဘာ လင်{/np} ရဲ့ နီ ကို အဲလ် နာ တေး သံ စုံ ပြ ဇာတ် ရုံ{/np} က ၎င်း ၏ ထုတ် လုပ် {np translation="Yass" prob="0.8"}ရေး{/np} အ သစ် ဖြစ် တဲ့ အ ဝါ ရောင် မင်း သ မီး ၊ နှ င့် အ တူ လှုပ် လှုပ် ရှား ရှား ဖြစ် စေ သည် ။
Unable to parse XML in line: {np translation="{np translation="Berlin" prob="0.8"}Berlin{/np}'s Neukoellner Opera House" prob="0.8"}{np translation="{np translation="Berlin" prob="0.8"}Berlin{/np}" prob="0.8"}ဘာ လင်{/np} ရဲ့ နီ ကို အဲလ် နာ တေး သံ စုံ ပြ ဇာတ် ရုံ{/np} က ၎င်း ၏ ထုတ် လုပ် {np translation="Yass" prob="0.8"}ရေး{/np} အ သစ် ဖြစ် တဲ့ အ ဝါ ရောင် မင်း သ မီး ၊ နှ င့် အ တူ လှုပ် လှုပ် ရှား ရှား ဖြစ် စေ သည် ။  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40 
  1  19  20  20  20  20  20   1  20  20  21  20  20  20  20  20  20  20  20  20  20  20  18  20  20  20  20  20  20  20  20  20  20  20  20  20  20  20  20  20   0 
   19 200 200 200 200 200  20  16 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200 200   0 
```
==========

Reference from Moses Manual:  
% echo 'das ist <np translation="a cute place">ein kleines haus</np>' 

*** add-xml-markup.pl ကို update လုပ်ဖို့ လိုအပ်တယ်။

=============

