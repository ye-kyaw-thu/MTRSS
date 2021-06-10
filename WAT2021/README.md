# Some Notes/Logs of WAT2021 Participation

NICT, Japan က ကြီးမှုးကျင်းပတဲ့ [WAT2021](https://lotus.kuee.kyoto-u.ac.jp/WAT/WAT2021/index.html) ရဲ့ English-Myanmar, Myanmar-English Machine Translation Share Task မှာ   
University of Technology (Yatanarpon Cyber City) ကို ကိုယ်စားပြုပြီး Team နှစ်ခု (YCC-MT1, YCC-MT2) နဲ့  
NECTEC (National Electronics and Computer Technology Center, Thailand) ကို ကိုယ်စားပြုပြီး (NECTEC) Team တစ်ခု၊ စုစုပေါင်း အဖွဲ့သုံးဖွဲ့ ဝင်ရောက်ပြီး contribuion လုပ်ခဲ့ပါတယ်။  
အဲဒီတုန်းက run ထားတာတဲ့ experiment တွေနဲ့ ပတ်သက်တဲ့ log/script ဖိုင်တချို့ကို share လိုက်ပါမယ်။ စာတမ်းက YCC-MT1 အဖွဲ့နဲ့ NECTEC အဖွဲ့အတွက်ပဲ WAT2021 အတွက်တင်ဖြစ်ခဲ့ပါတယ်။ YCC-MT2 ရဲ့ ရလဒ်တွေအပြင်၊ experiment အသစ် ထပ်ဖြည့်ပြီးတော့ တခြား conference သို့မဟုတ် journal အနေနဲ့တင်ဖို့ စိတ်ကူးထားပါတယ်။  

Experiment တွေကို Jan လကုန်လောက်က စတင်ပြင်ဆင်ခဲ့တယ်လို့ ထင်တယ်။ Feb လက စပြီး အင်တာနက်က ပုံမှန်သုံးလို့မရတဲ့အခက်အခဲကြောင့် မြန်မာကျောင်းသားတွေနဲ့က အဆက်အသွယ်လုပ်လို့ မရဖြစ်လာခဲ့ပါတယ်။ အဲဒါကြောင့် SMT/NMT experiment တော်တော်များများကို ကျွန်တော်ပဲဦးဆောင် run ခဲ့ရပါတယ်။ NMT ကလည်း GPU နှစ်လုံးပဲ ရှိတဲ့ HP Workstation စက်တစ်လုံးကိုပဲ သုံးပြီး လုပ်ခဲ့တာမို့ လုပ်ချင်ခဲ့တဲ့ NMT experiment တွေအားလုံးကိုတော့ စိတ်တိုင်းကျ မပြီးစီးခဲ့ပါဘူး။ တစ်ခုကောင်းတာက under-resource (both data/hardware) ဆိုတဲ့ condition မှာ run ခဲ့တာမို့ အထူးသဖြင့် GPU ကို ဖောဖောသီသီ မသုံးနိုင်ကြသေးတဲ့ မြန်မာက ကျောင်းသားတွေအတွက်တော့ refer လုပ်စရာ ဖြစ်ကောင်းဖြစ်နိုင်ပါလိမ့်မယ်။ နောက်ပြီးတော့ English-Myanmar, Myanmar-English machine translation R&D အတွက် အတိုင်းအတာတစ်ခုအထိ contribution ဖြစ်မယ်လို့ ယူဆပါတယ်။  

လက်ရှိမှာ [WAT2021 workshop](https://lotus.kuee.kyoto-u.ac.jp/WAT/WAT2021/index.html) မှာ စာတမ်း ဖတ်နိုင်ဖို့အတွက်၊ system description paper ၃စောင်ကို အမှီရေးတင်လိုက်နိုင်ဖို့ contact လုပ်လို့ communication လုပ်လို့အဆင်ပြေတဲ့ member တချို့နဲ့ပြင်ဆင်နေပါတယ်။  

Running log ဖိုင်တွေက တကယ် အကြမ်းရေးထားတာမို့ SMT/NMT experiment တွေနဲ့ ပတ်သက်ပြီး သိပ်အတွေ့အကြုံမရှိရင် လိုက်ဖတ်ရတာ ခက်ခဲတဲ့ အပိုင်းတွေလည်း ရှိနိုင်ပါတယ်။ သို့သော် တစ်ယောက်ယောက်အတွက် အကျိုးရှိမယ်လို့ ယုံကြည်လို့ ရှဲပေးထားလိုက်ပါတယ်။  

Thanks for visiting my GitHub!!! :)  

ရဲကျော်သူ  
7 May 2021  

**အချိန်ရတဲ့အခါမှာ README ဖိုင်ကို ဆက် update လုပ်သွားပါမယ်...**


-----------

## YCC-MT1 Team Members

1. Dr. Ye Kyaw Thu (UTYCC and LU Lab., Myanmar)
2. Dr. Hnin Aye Thant (UTYCC, Myanmar)
3. Hlaing Myat Nwe (UTYCC, Myanmar)
4. Naing Linn Phyo (UTYCC, Myanmar)
5. Nann Hwan Khun (UTYCC, Myanmar)
6. Khaing Zar Mon (UTYCC, Myanmar)
7. Nang Aeindray Kyaw (UTYCC, Myanmar)
8. Thazin Myint Oo (LU Lab., Myanmar)


## YCC-MT2 Team Members

1. Dr. Ye Kyaw Thu (UTYCC and LU Lab. Myanmar)
2. Dr. Hnin Aye Thant (UTYCC, Myanmar)
3. Hlaing Myat Nwe (UTYCC, Myanmar)
4. Eithandar Phyu (UTYCC, Myanmar)
5. Khaing Hsu Wai (UTYCC, Myanmar)
6. Myo Mar Thinn (UTYCC, Myanmar)
7. Hay Man Htun (UTYCC, Myanmar)

Note: No paper submission for YCC-MT2 Team.   
We submitted experiment results lately because of we faced many difficulties in communicating through internet.  

## NECTEC Team Members

1. Zar Zar Hlaing (KMITL, Thailand)
2. Mya Ei San (SIIT, Thailand)
3. Dr. Thepchai Supnithi (NECTEC, Thailand)
4. Dr. Ponrudee Netisopakul (KMITL, Thailand)
5. Dr.Sasiporn Usanavasin (SIIT, Thailand)
6. Dr. Ye Kyaw Thu (NECTEC, Thailand)
7. Thazin Myint Oo (LU Lab., Myanmar)

## Part-Time Members of UTYCC

The following members helped for manual word segmentation (i.e. some sentences of WAT2021, UCSY corpus data):  

* Phyo Thu Htet
* Amie Mie Lwin
* Khine Thet Thet Zaw
* Aye Min Than
* Zin Min Thaw
* Thiha Nyein

## Experiments

The followings are the brief explanation of three experiments that we implemented for WAT2021 en-my, my-en share task:  

### Exp 1: Hybrid Translation with XML Markup (YCC-MT1 Team)
   Sometimes we have external knowledge that we want to bring to the SMT decoder. We plug in XML markup based translations for transliterated words to the decoder without changing the PBSMT, HPBSMT and OSM models.  
   
   WAT2021 English-Myanmar share task ရဲ့ test data ကို ကြည့်တဲ့အခါမှာ အင်္ဂလိပ်စကားလုံးတွေကို တိုက်ရိုက် ဗမာလိုအသံထွက်အတိုင်းချရေးထားတဲ့ စာလုံးတွေ (transliterated word) အများကြီးတွေ့ရလို့ corpus တစ်ခုလုံး (i.e.[UCSY](http://lotus.kuee.kyoto-u.ac.jp/WAT/my-en-data/)+[ALT](https://www2.nict.go.jp/astrec-att/member/mutiyama/ALT/)) ထဲက နေ transliterated word တွေကို ဆွဲထုတ်ဖို့ မလွယ်ကူပေမဲ့ ALT corpus (စာကြောင်းရေ နှစ်သောင်းကျော်) ထဲက အသံထွက်အတိုင်းပဲ ချရေးပြီး ဘာသာပြန်ထားတဲ့ စာလုံးတွေအားလုံးကို manually ဆွဲထုတ်ပြီး dictionary ဆောက်လိုက်တယ်။ SMT decoding လုပ်တဲ့အခါမှာ အဲဒီ dictionary ကို သုံးပြီး hybrid translation လုပ်ခဲ့တယ်။ ဆွဲထုတ်တဲ့အခါမှာ အဓိကပါဝင်တဲ့ စာလုံးတွေက လူနာမည်တွေ၊ အဖွဲ့အစည်းနာမည်၊ နိုင်ငံနာမည် အများစုမို့ NER (Named-entity recognition) စာလုံးတွေလို့ မှတ်ယူနိုင်ပါတယ်။    
   
   ပြင်ဆင်ထားတဲ့ transliteration dictionary ကို သုံးပြီးတော့ perl script နဲ့ source စာကြောင်းတွေကို XML markup ပုံစံအရင်ပြောင်းပြီးမှ moses decoder ကို ဘာသာပြန်ခိုင်းတာပါ။ အဲဒါကြောင့် ဥပမာ အင်္ဂလိပ်စာကြောင်းတွေကနေ ဗမာလို ဘာသာပြန်ခိုင်းမယ်ဆိုရင် source စာကြောင်းတွေက အောက်ပါ format အတိုင်းရှိနေပါလိမ့်မယ်။ HPBSMT decoder ကို input လုပ်တဲ့ source ဖိုင်ကနေ sentence length တိုတဲ့ ဥပမာပြလို့ကောင်းတဲ့ စာကြောင်း သုံးကြောင်းကို ရွေးပြထားတာပါ။  
   
```
Tanks of {{np translation="အောက် စီ ဂျင်" prob="0.8"}}oxygen{{/np}} , {{np translation="ဟီ လီ ရမ်" prob="0.8"}}helium{{/np}}   
and {{np translation="အက် ဆီ တ လင်း" prob="0.8"}}acetylene{{/np}} began to explode after  
a connector used to join {{np translation="အက် ဆီ တ လင်း" prob="0.8"}}acetylene{{/np}}  
tanks during the filling process malfunctioned .  
Human Rights {{np translation="ကော် မ ရှင်" prob="0.8"}}Commission{{/np}} of   
{{np translation="ပါ ကစ္စ တန်" prob="0.8"}}Pakistan{{/np}} co-chairman   
{{np translation="အီ ကွေ ဟေ ဒါ" prob="0.8"}}Iqbal Haider{{/np}} said that the daughter of   
Dr. Aafia was also in {{np translation="အာ ဖ ဂန် နစ္စ တန်" prob="0.8"}}Afghanistan{{/np}} .  
The pair , who were transferred from {{np translation="ဟော် လန်" prob="0.8"}}Holland{{/np}} ,   
claim that {{np translation="ရိ မု တ က" prob="0.8"}}Rimutaka{{/np}} prison   
is run by gang members who dominate the prison guards .
```
   
   စုစုပေါင်း run ခဲ့တာက အောက်ပါအတိုင်းပါ။  
   
**\[English-Myanmar\]**  
**Baseline:** PBSMT (Phrase-based Statistical Machine Translation)  
**Hybrid Translation:** PBSMT + XML Markup; -xml-input exclusive  
**Hybrid Translation:** PBSMT + XML Markup; -xml-input inclusive  

**Baseline:** HPBSMT (Hiero Phrase-based Statistical Machine Translation)  
**Hybrid Translation:** HPBSMT + XML Markup; -xml-input exclusive  
**Hybrid Translation:** HPBSMT + XML Markup; -xml-input inclusive  

**Baseline:** OSM (Operation Sequence Model)  
**Hybrid Translation:** OSM + XML Markup; -xml-input exclusive  
**Hybrid Translation:** OSM + XML Markup; -xml-input inclusive  

Note: HPBSMT အတွက် XML markup နဲ့ decode လုပ်တဲ့အခါမှာ ``` --xml-brackets "{{ }}" ``` option ကိုပါ သုံးဖို့လိုအပ်ပါတယ်။ ဘာကြောင့်လဲ ဆိုတော့ Hiero မှာလည်း grammar tree ကို XML format ဖြစ်တဲ့ angle bracket တွေကိုသုံးပြီး ဆောက်ထားတာကြောင့်ပါ။ decode လုပ်တဲ့ command အပြည့်အစုံက အောက်ပါအတိုင်း ဥပမာအတိုင်းပါ။  

```
$~/tool/mosesbin/ubuntu-17.04/moses/bin/moses_chart -xml-input exclusive --xml-brackets "{{ }}" -i ./test.xml.en -f ../evaluation/test.filtered.ini.1 > en-my.xml.hyp1 
```

Running Log1: [https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/smt-experiments-log-wat2021.txt](https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/smt-experiments-log-wat2021.txt)   
Running Log2: [https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/smt-experiments-log-wat2021-with-alt.md](https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/smt-experiments-log-wat2021-with-alt.md)  

### Exp 2: Ensemble Two Models (YCC-MT2 Team)
   Models of different types and architectures can be ensembled as long as they use common vocabularies and we tried RNN Attention plus Transformer models for Myanmar to English and English to Myanmar translations.  
   
   မြန်မာလို ထပ်ဖြည့်ရှင်းရရင်တော့ ensemble လုပ်တဲ့အခါ မော်ဒယ်တွေကို နှစ်ခုထက်မကလည်း လုပ်နိုင်ပါတယ်။ WAT2019 မှာ Facebook team က လုပ်ခဲ့သလိုမျိုး မော်ဒယ် ငါးခုဆောက်ပြီး အဲဒီ မော်ဒယ်ငါးခုကို ensemble လုပ်ပြီး translation လုပ်တာမျိုးပါ။ သို့သော် အဲဒီလို လုပ်ဖို့အတွက်က NMT မော်ဒယ် ငါးခုဆောက်ဖို့အတွက် GPU ကဒ် အရေအတွက်ကသိပ်မရှိရင် အချိန်အများကြီးပေးရပါတယ်။ ပြီးတော့ မော်ဒယ် ၅ခုကို တွဲပြီး run ဖို့က memory, GPU လည်း အများကြီးလိုအပ်ပါတယ်။ ဒီတစ်ခေါက် WAT2021 မှာ YCC-MT2 အဖွဲ့အနေနဲ့က under-resourced ဆိုတဲ့ condition ကိုပဲ အခြေခံပါတယ်၊ လက်တွေ့ မြန်မာနိုင်ငံက တက္ကသိုလ်တွေအနေနဲ့ကလည်း GPU အများကြီးကို သုံးပြီး run တဲ့ experiment တွေက မဖြစ်နိုင်သေးတာမို့၊ GPU နှစ်လုံးထဲကို သုံးပြီး၊ မော်ဒယ်ကိုလည်း ၂မျိုးကိုပဲ ensemble လုပ်ခဲ့ပါတယ်။  
   
   စုစုပေါင်း run ခဲ့တာက အောက်ပါအတိုင်းပါ။  

### #Used only UCSY Corpus for Training

**\[English-Myanmar\]**  
**System-1:** s2s or RNN-based  
**System-2:** Transformer  
**Ensemble 1+2:** s2s+Transformer (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**System-3:** s2s or RNN-based; tree2string  
**System-4:** Transformer; tree2string    
**Ensemble 3+4:** s2s (t2s) + Transformer (t2s); (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**\[Myanmar-English\]**  
**System-5:** s2s; syllable  
**System-6:** Transformer; syllable     
**Ensemble:** s2s+Transformer; (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**System-7:** s2s; word2word  
**System-8:** Transformer; word2word  
**Ensemble 7+8:** s2s + Transformer (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  
Here, we used our in-house __*myWord*__ word segmenter for Myanmar language.  

Running Log: [https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-experiments-log-wat2021.txt](https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-experiments-log-wat2021.txt)  

### #Used UCSY+ALT Corpus for Training

**\[English-Myanmar\]**  
**System-1:** s2s or RNN-based, word-to-syllable  
**System-2:** Transformer, word-to-syllable  
**Ensemble 1+2:** s2s+Transformer (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**\[Myanmar-English\]**  
**System-5:** s2s; syllable-to-word    
**System-6:** Transformer; syllable-to-word     
**Ensemble:** s2s+Transformer; (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**\[English-Myanmar\]**  
**System-3:** s2s or RNN-based; word-to-word  
**System-4:** Transformer, word-to-word  
**Ensemble 3+4:** s2s (t2s) + Transformer (t2s); (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  

**\[Myanmar-English\]**  
**System-7:** s2s; word-to-word  
**System-8:** Transformer; word-to-word  
**Ensemble 7+8:** s2s + Transformer (Run with --weights 0.4 0.6, --weights 0.5 0.5 and --weights 06 04)  
Here, we used our in-house __*myWord*__ word segmenter for Myanmar language.  

Running Log: [https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-exp-plus-alt.md](https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-exp-plus-alt.md)  

### Exp 3: Multi-source Neural Machine Translation (NECTEC Team)
   We used two encoders for multi-source neural machine translation experiments. Here, we used parsed tree and POS tagged data as one more source language together with the original string source. 
   We used only UCSY Training Data for this experiment.  
   
   Marian framework ရဲ့ အော်ရဂျင်နယ် multi-source ပရိုပိုဇယ် (Junczys-Dowmunt et al. 2016, Junczys-Dowmunt et al. 2017) က post editing အတွက် ရည်ရွယ်ခဲ့ပေမဲ့ WAT2021 share task အတွက် experiment လုပ်ခဲ့တာက grammar tree တို့ POS tagged တွေကနေ target language ကို တိုက်ရိုက် ဘာသာပြန်တာထက်၊ အော်ရဂျင်နယ် source language ကိုပါ နောက်ထပ် source တစ်ခုအနေနဲ့ ဖြည့်ပြီး decode လုပ်ရင် translation performance ဘယ်လောက်ထိ တက်နိုင်သလဲ ဆိုတာကို သိချင်လို့ လုပ်ခဲ့တာပါ။  
   
   စုစုပေါင်း run ခဲ့တာက အောက်ပါအတိုင်းပါ။  

### #Used UCSY+ALT Corpus for Training
**\[English-Myanmar\]**  
**Baseline:** RNN-based Architecture; Source: Tree ===> Target: String  
**Multi-Source:** RNN-based Architecture; Source-1: string, Source-2: tree ===> Target: String  
**Shared-Multi-Source:** RNN-based Architecture; Source-1: string, Source-2: tree ===> Target: String  

**Baseline:** Transformer Architecture; Source: Tree ===> Target: String  
**Multi-Source:** Transformer Architecture; Source-1: string, Source-2: tree ===> Target: String  
**Shared-Multi-Source:** Transformer Architecture; Source-1: string, Source-2: tree ===> Target: String  

**\[Myanmar-English\]**  
**Baseline:** RNN-based Architecture; Source: POS ===> Target: String  
**Multi-Source:** RNN-based Architecture; Source-1: string, Source-2: POS ===> Target: String  
**Shared-Multi-Source:** RNN-based Architecture; Source-1: string, Source-2: POS ===> Target: String  

**Baseline:** Transformer Architecture; Source: POS ===> Target: String  
**Multi-Source:** Transformer Architecture; Source-1: string, Source-2: POS ===> Target: String  
**Shared-Multi-Source:** Transformer Architecture; Source-1: string, Source-2: POS ===> Target: String  

Running Log: [https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-experiments-log-wat2021.txt](https://github.com/ye-kyaw-thu/MTRSS/blob/master/WAT2021/nmt-experiments-log-wat2021.txt)  

## System/Framework

NMT အတွက်က framework သုံးမျိုးလောက် test run လုပ်ခဲ့ပါသေးတယ်။ GPU နှစ်လုံးထဲနဲ့ limited memory မှာ deadline အချိန်မှီအောင် ပြင်ဆင်ခဲ့ရတာမို့ တကယ် experiment တွေလုပ်ဖြစ်သွားတာက Marian NMT Framework တစ်ခုတည်းပေါ်မှာပါပဲ။   

* Moses: [http://www.statmt.org/moses/](http://www.statmt.org/moses/)  
* Marian: [https://github.com/marian-nmt/marian](https://github.com/marian-nmt/marian)

## System Description Papers

### For YCC-MT1 Team  
- Ye Kyaw Thu, Thazin Myint Oo, Hlaing Myat Nwe, Khaing Zar Mon, Nang Aeindray Kyaw, Naing Linn Phyo, Nann Hwan Khun and Hnin Aye Thant, "Hybrid Statistical Machine Translation for English-Myanmar: UTYCC Submission to WAT-2021", In Proceedings of the 8th Workshop on Asian Translation (WAT2021), Aug 5-6, 2021, Bangkok, Thailand, pp. xx-xx. (to appear)  

### For NECTEC Team
- Zar Zar Hlaing, Ye Kyaw Thu, Thazin Myint Oo, Mya Ei San, Sasiporn Usanavasin, Ponrudee Netisopakul and Thepchai Supnithi, "NECTEC’s Participation in WAT-2021", In Proceedings of the 8th Workshop on Asian Translation (WAT2021), Aug 5-6, 2021, Bangkok, Thailand, pp. xx-xx. (to appear)  

## References

* Hybrid Translation of Moses: [http://www.statmt.org/moses/?n=Advanced.Hybrid](http://www.statmt.org/moses/?n=Advanced.Hybrid) 
* Marcin Junczys-Dowmunt, Roman Grundkiewicz, Log-linear Combinations of Monolingual and Bilingual Neural Machine Translation Models for Automatic Post-Editing:[https://www.aclweb.org/anthology/W16-2378/](https://www.aclweb.org/anthology/W16-2378/)  
* Marcin Junczys-Dowmunt, Roman Grundkiewicz, An Exploration of Neural Sequence-to-Sequence Architectures for Automatic Post-Editing, [https://arxiv.org/abs/1706.04138](https://arxiv.org/abs/1706.04138)  
* Documentation of MARIANNMT: [https://marian-nmt.github.io/docs/](https://marian-nmt.github.io/docs/)  
