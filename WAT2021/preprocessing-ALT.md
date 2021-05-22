
### training/dev/test splitting of ALT data

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ tree
.
├── ALT-Parallel-Corpus-20191206
│   ├── ALT-O-COCOSDA.pdf
│   ├── ChangeLog.txt
│   ├── data_bg.txt
│   ├── data_en_tok.txt
│   ├── data_en.txt
│   ├── data_fil.txt
│   ├── data_hi.txt
│   ├── data_id.txt
│   ├── data_ja.txt
│   ├── data_khm.txt
│   ├── data_lo.txt
│   ├── data_ms.txt
│   ├── data_my.txt
│   ├── data_th.txt
│   ├── data_vi.txt
│   ├── data_zh.txt
│   ├── README.txt
│   └── URL.txt
├── ALT-Parallel-Corpus-20191206.zip
├── doit.sh
├── tools
│   ├── doit.sh
│   └── extract_sentences.prl
├── tools.zip
├── URL-dev.txt
├── URL-test.txt
└── URL-train.txt

2 directories, 26 files
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ ./doit.sh 
```

## Checking

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ ls
ALT-Parallel-Corpus-20191206      data_en.txt.dev   data_en.txt.train  data_my.txt.test   doit.sh   tools      URL-dev.txt   URL-train.txt
ALT-Parallel-Corpus-20191206.zip  data_en.txt.test  data_my.txt.dev    data_my.txt.train  note.txt  tools.zip  URL-test.txt

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ wc *.dev
  1000  23294 152884 data_en.txt.dev
  1000  26974 535317 data_my.txt.dev
  2000  50268 688201 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ wc data_en.*
   1000   23294  152884 data_en.txt.dev
   1018   23955  157019 data_en.txt.test
  18088  431088 2819169 data_en.txt.train
  20106  478337 3129072 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ wc data_my.*
    1000    26974   535317 data_my.txt.dev
    1018    27335   545540 data_my.txt.test
   18088   496272  9836929 data_my.txt.train
   20106   550581 10917786 total
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ head -3 ./data_en.txt.*
==> ./data_en.txt.dev <==
SNT.98301.329	"Though we are sad for his loss, he left a legacy that will inflame the enemy nation and religion."
SNT.98301.330	It is speculated that he was hit by a United States missile, which is now identified as being fired from a Predator drone, in the North Waziristan of Pakistan, and a dozen more militants were also reported dead.
SNT.98301.331	"The missile appeared to have been fired by a drone," said a Pakistani intelligence official.

==> ./data_en.txt.test <==
SNT.78103.34	It has been confirmed that eight thoroughbred race horses at Randwick Racecourse in Sydney have been infected with equine influenza.
SNT.78103.35	Randwick has been locked down, and is expected to remain so for up to two months.
SNT.78103.36	It is expected that the virulent flu will affect the majority of the 700 horses stabled at Randwick.

==> ./data_en.txt.train <==
SNT.80188.1	Italy have defeated Portugal 31-5 in Pool C of the 2007 Rugby World Cup at Parc des Princes, Paris, France.
SNT.80188.2	Andrea Masi opened the scoring in the fourth minute with a try for Italy.
SNT.80188.3	Despite controlling the game for much of the first half, Italy could not score any other tries before the interval but David Bortolussi kicked three penalties to extend their lead.
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ head -3 ./data_my.txt.*
==> ./data_my.txt.dev <==
SNT.98301.329	" သူ၏ ဆုံးပါးခြင်း အတွက် ကျွန်တော်တို့ ဝမ်းနည်း သော်ငြားလည်း ၊ လူမျိုးရေး နှင့် ဘာသာရေး ရန်စွယ် ကို နှိုးဆွပေး သော အမွေနှစ် တစ်ခု ကို သူ ချန်ထားခဲ့သည် ။ "
SNT.98301.330	ပါကစ္စတန်နိုင်ငံ ၏ ဝတ်ဇီရီစတန် မြောက်ပိုင်း ရှိ ၊ လူကထိန်းရန်မလိုသောစစ်လေယာဉ် မှ ပစ်ခတ်ခြင်း အနေဖြင့် ယခု သတ်မှတ်ထား သော ၊ အမေရိကန်ပြည်ထောင်စု ဒုံးကျည် ဖြင့် ၊ သူ့ ကို ထိခိုက်စေခဲ့သည် ဟု ထင်ကြေးပေးခဲ့ ပြီးနောက် နောက်ထပ် အလွန်များပြားသော စစ်သွေးကြွများ လည်း သေဆုံးကြောင်း သတင်းပို့ခဲ့သည် ။
SNT.98301.331	" လူကထိန်းရန်မလိုသောလေယာဉ် မှ ပစ်ခတ် ရန် ဒုံးကျည် ပေါ်ပေါက်ခဲ့သည် ၊ " ဟု ပါကစ္စတန် သတင်းထောက်လှမ်းရေး အရာရှိ တစ်ယောက် က ပြောခဲ့သည် ။

==> ./data_my.txt.test <==
SNT.78103.34	ဆစ်ဒနီ က ရန့်ဝစ်(ခ်) မြင်းပြိုင်ကွင်း မှ မျိုးသန့် ပြိုင်မြင်း ရှစ်ကောင် ဟာ မြင်းတုတ်ကွေးရောဂါ ကူးစက်ခံခဲ့ရတယ် ဆိုတာ အတည်ပြုခဲ့ပါတယ် ။
SNT.78103.35	ရန့်ဝစ်(ခ်) ကို ပိတ်ထားခဲ့ ပြီး ၂လ အထိ ကြာကြာ ဆက်လက်ထိမ်းသိမ်းထား ရန် မျှော်လင့်ပါတယ် ။
SNT.78103.36	အလွန်ပြင်းထန်သော တုတ်ကွေး ဟာ ရန့်ဝစ်(ခ်) မှာ အမြဲထားသော မြင်း ၇၀၀ ထဲက အများစု ကို ကူးစက်လိမ့်မယ် လို့ ခန့်မှန်းထားပါတယ် ။

==> ./data_my.txt.train <==
SNT.80188.1	ပြင်သစ်နိုင်ငံ ပါရီမြို့ ပါ့ဒက်စ် ပရင့်စက် ၌ ၂၀၀၇ခုနှစ် ရပ်ဘီ ကမ္ဘာ့ ဖလား တွင် အီတလီ သည် ပေါ်တူဂီ ကို ၃၁-၅ ဂိုး ဖြင့် ရေကူးကန် စီ တွင် ရှုံးနိမ့်သွားပါသည် ။
SNT.80188.2	အန်ဒရီယာ မာစီ သည် အီတလီ အတွက် စမ်းသပ်မှု တစ်ခု အဖြစ် စတုတ္ထ မိနစ် တွင် အမှတ်ပေးခြင်း ကို ဖွင့်လှစ်ပေးခဲ့သည် ။
SNT.80188.3	ပထမ တစ်ဝက် ၏ တော်တော်များများ အတွက် ကစားပွဲ ကို ထိန်းချုပ်ခြင်း မရှိခဲ့လျှင် အီတလီ သည် ပွဲနားချိန် မတိုင်မှီ အခြား မည်သည့် ကြိုးစားမှု များ ကိုမှ အမှတ် မရနိုင် ပေမယ့် ဒေးဗစ် ဘော်တိုလပ်စီ သည် သူတို့၏ ဦးဆောင်မှု ကို အဓွန့်ရှည် စေရန် ပယ်နယ်လ်တီ ၃ဂိုး သွင်းပေးခဲ့သည် ။
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$
```

## Prepare training files of ALT

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ cut -f2 ./data_en.txt.train > alt.en.train
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ cut -f2 ./data_my.txt.train > alt.my.train
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ head ./alt.en.train
Italy have defeated Portugal 31-5 in Pool C of the 2007 Rugby World Cup at Parc des Princes, Paris, France.
Andrea Masi opened the scoring in the fourth minute with a try for Italy.
Despite controlling the game for much of the first half, Italy could not score any other tries before the interval but David Bortolussi kicked three penalties to extend their lead.
Portugal never gave up and David Penalva scored a try in the 33rd minute, providing their only points of the match.
Italy led 16-5 at half time but were matched by Portugal for much of the second half.
However Bortolussi scored his fourth penalty of the match, followed by tries from Mauro Bergamasco and a second from Andrea Masi to wrap up the win for Italy.
Currently third in Pool C with eight points, Italy face a tough match against second placed Scotland on 29 September.
New Zealand lead the group with ten points, ahead of Scotland on points difference.
Portugal are bottom of the group with no points, behind Romania with one.
Some personal details of 3 million British learner drivers who had applied for the 'theory test' component of their Driving licence have been lost in Iowa, in the USA.
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ head ./alt.my.train 
ပြင်သစ်နိုင်ငံ ပါရီမြို့ ပါ့ဒက်စ် ပရင့်စက် ၌ ၂၀၀၇ခုနှစ် ရပ်ဘီ ကမ္ဘာ့ ဖလား တွင် အီတလီ သည် ပေါ်တူဂီ ကို ၃၁-၅ ဂိုး ဖြင့် ရေကူးကန် စီ တွင် ရှုံးနိမ့်သွားပါသည် ။
အန်ဒရီယာ မာစီ သည် အီတလီ အတွက် စမ်းသပ်မှု တစ်ခု အဖြစ် စတုတ္ထ မိနစ် တွင် အမှတ်ပေးခြင်း ကို ဖွင့်လှစ်ပေးခဲ့သည် ။
ပထမ တစ်ဝက် ၏ တော်တော်များများ အတွက် ကစားပွဲ ကို ထိန်းချုပ်ခြင်း မရှိခဲ့လျှင် အီတလီ သည် ပွဲနားချိန် မတိုင်မှီ အခြား မည်သည့် ကြိုးစားမှု များ ကိုမှ အမှတ် မရနိုင် ပေမယ့် ဒေးဗစ် ဘော်တိုလပ်စီ သည် သူတို့၏ ဦးဆောင်မှု ကို အဓွန့်ရှည် စေရန် ပယ်နယ်လ်တီ ၃ဂိုး သွင်းပေးခဲ့သည် ။
ပေါ်တူဂီ သည် ဘယ်သောအခါမှ စွန့်လွှတ်မှု မရှိခဲ့ ပဲ ဒေးဗစ် ပန်နယ်ဗါ သည် ၃၃ မိနစ် တွင် သူတို့ ၏ ကစားပွဲ ရဲ့ အမှတ်များ ကိုသာ အထောက်အကူပြုသည့် ကြိုးစားမှု တစ်ခု မှ အမှတ်ရခဲ့ပါသည်။
အီတလီ သည် ပထမပိုင်း ၌ ၁၆-၅ ဖြင့် ဦးဆောင်ခဲ့ သော်လည်း ပေါ်တူဂီ မှ ဒုတိယပိုင်း တော်တော်များများ တွင် ဂိုးအရေအတွက်ညီစေခဲ့သည် ။
သို့သော်လည်း ဘော်တိုလပ်စီ သည် မော်ရို ဘာဂမ်မက်စကို ၏ ကြိုးစားမှု များ နှင့် အန်ဒရီယာ မာစီ ၏ ဒုတိယဂိုး နောက်ပိုင်း အီတလီ အတွက် အနိုင် ရရှိစေရန် သူ၏ စတုတ္ထမြောက် ကစားပွဲ ၏ ပယ်နယ်လ်တီ ကို သွင်းယူပေးခဲ့သည် ။
လောလောဆယ် ရေကူးကန် စီ ၌ ရှစ်မှတ် နှင့် တတိယ ဖြစ်နေသော အီတလီ သည် စက်တင်ဘာ ၂၉ တွင် ဒုတိယ ရရှိထားသော စကော့တလန် နှင့် ခက်ခဲသော ယှဉ်ပြိုင်မှု တစ်ခု ကို ရင်ဆိုင်နေရသည် ။
နယူးဇီလန် သည် ရမှတ် ကွာခြားချက် အပေါ် စကော့တလန် ၏ ရှေ့မှ ရမှတ် ဆယ်မှတ် နှင့်အတူ အုပ်စု ကို ဦးဆောင်နေသည် ။
ပေါ်တူဂီ သည် တစ်မှတ် ရသော ရိုမေးနီးယား နောက်တွင် အမှတ် မရှိဘဲ အုပ်စု ၏ အောက်ဆုံးတွင် ရှိသည်။
သူတို့ ယာဉ်မောင်း လိုင်စင် ၏ သီအိုရီ စာမေးပွဲ အပိုင်း အတွက် လျှောက်ထားခဲ့သော ဗြိတိသျှ သင်ယူသူ ယာဉ်မောင်း ၃ သန်း ၏ ကိုယ်ရေး အသေးစိတ်များ အချို့ အမေရိကန်ပြည်ထောင်စု ရှိ အိုင်အိုဝါ တွင် ပျောက်ဆုံးသွားခဲ့သည် ။
```

## Check file size

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ wc alt.en.train
  18088  413000 2532525 alt.en.train
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ wc alt.my.train
  18088  478184 9550285 alt.my.train
```

## Prepare for Myanmar Data

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation$ ./clean-my-data-arg.sh ./alt.my.train 
./alt.my.train.syl:
   18088  1038640 10092758 ./alt.my.train.syl
./alt.my.train.syl.escaped:
   18088  1038640 10110361 ./alt.my.train.syl.escaped
./alt.my.train.syl.escaped.print:
   18088  1038640 10110361 ./alt.my.train.syl.escaped.print
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation$

   18088  1038640 10110361 ./alt.my.train.syl.escaped.print
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation$ head ./alt.my.train.syl.escaped.print 
ပြင် သစ် နိုင် ငံ ပါ ရီ မြို့ ပါ့ ဒက်စ် ပ ရင့် စက် ၌ ၂၀၀၇ ခု နှစ် ရပ် ဘီ ကမ္ဘာ့ ဖ လား တွင် အီ တ လီ သည် ပေါ် တူ ဂီ ကို ၃၁ - ၅ ဂိုး ဖြင့် ရေ ကူး ကန် စီ တွင် ရှုံး နိမ့် သွား ပါ သည် ။
အန် ဒ ရီ ယာ မာ စီ သည် အီ တ လီ အ တွက် စမ်း သပ် မှု တစ် ခု အ ဖြစ် စ တုတ္ထ မိ နစ် တွင် အ မှတ် ပေး ခြင်း ကို ဖွင့် လှစ် ပေး ခဲ့ သည် ။
ပ ထ မ တစ် ဝက် ၏ တော် တော် များ များ အ တွက် က စား ပွဲ ကို ထိန်း ချုပ် ခြင်း မ ရှိ ခဲ့ လျှင် အီ တ လီ သည် ပွဲ နား ချိန် မ တိုင် မှီ အ ခြား မည် သည့် ကြိုး စား မှု များ ကို မှ အ မှတ် မ ရ နိုင် ပေ မယ့် ဒေး ဗစ် ဘော် တို လပ် စီ သည် သူ တို့ ၏ ဦး ဆောင် မှု ကို အ ဓွန့် ရှည် စေ ရန် ပယ် နယ်လ် တီ ၃ ဂိုး သွင်း ပေး ခဲ့ သည် ။
ပေါ် တူ ဂီ သည် ဘယ် သော အ ခါ မှ စွန့် လွှတ် မှု မ ရှိ ခဲ့ ပဲ ဒေး ဗစ် ပန် နယ် ဗါ သည် ၃၃ မိ နစ် တွင် သူ တို့ ၏ က စား ပွဲ ရဲ့ အ မှတ် များ ကို သာ အ ထောက် အ ကူ ပြု သည့် ကြိုး စား မှု တစ် ခု မှ အ မှတ် ရ ခဲ့ ပါ သည် ။
အီ တ လီ သည် ပ ထ မ ပိုင်း ၌ ၁၆ - ၅ ဖြင့် ဦး ဆောင် ခဲ့ သော် လည်း ပေါ် တူ ဂီ မှ ဒု တိ ယ ပိုင်း တော် တော် များ များ တွင် ဂိုး အ ရေ အ တွက် ညီ စေ ခဲ့ သည် ။
သို့ သော် လည်း ဘော် တို လပ် စီ သည် မော် ရို ဘာ ဂမ် မက် စ ကို ၏ ကြိုး စား မှု များ နှင့် အန် ဒ ရီ ယာ မာ စီ ၏ ဒု တိ ယ ဂိုး နောက် ပိုင်း အီ တ လီ အ တွက် အ နိုင် ရ ရှိ စေ ရန် သူ ၏ စ တုတ္ထ မြောက် က စား ပွဲ ၏ ပယ် နယ်လ် တီ ကို သွင်း ယူ ပေး ခဲ့ သည် ။
လော လော ဆယ် ရေ ကူး ကန် စီ ၌ ရှစ် မှတ် နှင့် တ တိ ယ ဖြစ် နေ သော အီ တ လီ သည် စက် တင် ဘာ ၂၉ တွင် ဒု တိ ယ ရ ရှိ ထား သော စ ကော့ တ လန် နှင့် ခက် ခဲ သော ယှဉ် ပြိုင် မှု တစ် ခု ကို ရင် ဆိုင် နေ ရ သည် ။
န ယူး ဇီ လန် သည် ရ မှတ် ကွာ ခြား ချက် အ ပေါ် စ ကော့ တ လန် ၏ ရှေ့ မှ ရ မှတ် ဆယ် မှတ် နှင့် အ တူ အုပ် စု ကို ဦး ဆောင် နေ သည် ။
ပေါ် တူ ဂီ သည် တစ် မှတ် ရ သော ရို မေး နီး ယား နောက် တွင် အ မှတ် မ ရှိ ဘဲ အုပ် စု ၏ အောက် ဆုံး တွင် ရှိ သည် ။
သူ တို့ ယာဉ် မောင်း လိုင် စင် ၏ သီ အို ရီ စာ မေး ပွဲ အ ပိုင်း အ တွက် လျှောက် ထား ခဲ့ သော ဗြိ တိ သျှ သင် ယူ သူ ယာဉ် မောင်း ၃ သန်း ၏ ကိုယ် ရေး အ သေး စိတ် များ အ ချို့ အ မေ ရိ ကန် ပြည် ထောင် စု ရှိ အိုင် အို ဝါ တွင် ပျောက် ဆုံး သွား ခဲ့ သည် ။
```

## Prepare for English

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/marian/wat2021/exp-syl4/data-alt/alt$ cp alt.en.train /home/ye/exp/smt/wat2021/exp-syl4/data/preparation/alt/

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ ./escape-all-data.sh ./alt.en.train 
Escaping  ...
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ ls
alt.en.train  alt.en.train.escape  alt.my.train  alt.my.train.syl.escaped.print  escape-all-data.sh
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ head ./alt.en.train
Italy have defeated Portugal 31-5 in Pool C of the 2007 Rugby World Cup at Parc des Princes, Paris, France.
Andrea Masi opened the scoring in the fourth minute with a try for Italy.
Despite controlling the game for much of the first half, Italy could not score any other tries before the interval but David Bortolussi kicked three penalties to extend their lead.
Portugal never gave up and David Penalva scored a try in the 33rd minute, providing their only points of the match.
Italy led 16-5 at half time but were matched by Portugal for much of the second half.
However Bortolussi scored his fourth penalty of the match, followed by tries from Mauro Bergamasco and a second from Andrea Masi to wrap up the win for Italy.
Currently third in Pool C with eight points, Italy face a tough match against second placed Scotland on 29 September.
New Zealand lead the group with ten points, ahead of Scotland on points difference.
Portugal are bottom of the group with no points, behind Romania with one.
Some personal details of 3 million British learner drivers who had applied for the 'theory test' component of their Driving licence have been lost in Iowa, in the USA.

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ head ./alt.en.train.escape 
Italy have defeated Portugal 31-5 in Pool C of the 2007 Rugby World Cup at Parc des Princes, Paris, France.
Andrea Masi opened the scoring in the fourth minute with a try for Italy.
Despite controlling the game for much of the first half, Italy could not score any other tries before the interval but David Bortolussi kicked three penalties to extend their lead.
Portugal never gave up and David Penalva scored a try in the 33rd minute, providing their only points of the match.
Italy led 16-5 at half time but were matched by Portugal for much of the second half.
However Bortolussi scored his fourth penalty of the match, followed by tries from Mauro Bergamasco and a second from Andrea Masi to wrap up the win for Italy.
Currently third in Pool C with eight points, Italy face a tough match against second placed Scotland on 29 September.
New Zealand lead the group with ten points, ahead of Scotland on points difference.
Portugal are bottom of the group with no points, behind Romania with one.
Some personal details of 3 million British learner drivers who had applied for the &apos;theory test&apos; component of their Driving licence have been lost in Iowa, in the USA.
```

## Change Filenames

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ cp alt.my.train.syl.escaped.print alt.ready.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ rm alt.ready.my 
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ cp alt.my.train.syl.escaped.print alt.train.ready.my
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ cp alt.en.train.escape alt.train.ready.en
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/smt/wat2021/exp-syl4/data/preparation/alt$ wc alt.train.ready.{my,en}
   18088  1038640 10110361 alt.train.ready.my
   18088   413000  2581834 alt.train.ready.en
   36176  1451640 12692195 total
```

အထက်က ပြင်ခဲ့တဲ့ ALT training data ကို UCSY training data နဲ့ ပေါင်းရမယ်။  
