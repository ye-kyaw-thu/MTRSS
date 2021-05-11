# Some Notes/Logs of WAT2021 Participation

NICT, Japan က ကြီးမှုးကျင်းပတဲ့ [WAT2021](https://lotus.kuee.kyoto-u.ac.jp/WAT/WAT2021/index.html) ရဲ့ English-Myanmar, Myanmar-English Machine Translation Share Task မှာ   
University of Technology (Yatanarpon Cyber City) ကို ကိုယ်စားပြုပြီး Team နှစ်ခု (YCC-MT1, YCC-MT2) နဲ့  
NECTEC (National Electronics and Computer Technology Center, Thailand) ကို ကိုယ်စားပြုပြီး (NECTEC) Team တစ်ခု၊ စုစုပေါင်း အဖွဲ့သုံးဖွဲ့ ဝင်ရောက်ပြီး contribuion လုပ်ခဲ့ပါတယ်။  
အဲဒီတုန်းက run ထားတာတဲ့ experiment တွေနဲ့ ပတ်သက်တဲ့ log/script ဖိုင်တချို့ကို share လိုက်ပါမယ်။   

Experiment တွေကို Jan လကုန်လောက်က စတင်ပြင်ဆင်ခဲ့တယ်လို့ ထင်တယ်။ Feb လက စပြီး အင်တာနက်က ပုံမှန်သုံးလို့မရတဲ့အခက်အခဲကြောင့် မြန်မာကျောင်းသားတွေနဲ့က အဆက်အသွယ်လုပ်လို့ မရဖြစ်လာခဲ့ပါတယ်။ အဲဒါကြောင့် SMT/NMT experiment တော်တော်များများကို ကျွန်တော်ပဲဦးဆောင် run ခဲ့ရပါတယ်။ NMT ကလည်း GPU နှစ်လုံးပဲ ရှိတဲ့ HP Workstation စက်တစ်လုံးကိုပဲ သုံးပြီး လုပ်ခဲ့တာမို့ လုပ်ချင်ခဲ့တဲ့ NMT experiment တွေအားလုံးကိုတော့ စိတ်တိုင်းကျ မပြီးစီးခဲ့ပါဘူး။ တစ်ခုကောင်းတာက under-resource (both data/hardware) ဆိုတဲ့ condition မှာ run ခဲ့တာမို့ အထူးသဖြင့် GPU ကို ဖောဖောသီသီ မသုံးနိုင်ကြသေးတဲ့ မြန်မာက ကျောင်းသားတွေအတွက်တော့ refer လုပ်စရာ ဖြစ်ကောင်းဖြစ်နိုင်ပါလိမ့်မယ်။ နောက်ပြီးတော့ English-Myanmar, Myanmar-English machine translation R&D အတွက် အတိုင်းအတာတစ်ခုအထိ contribution ဖြစ်မယ်လို့ ယူဆပါတယ်။  

လက်ရှိမှာ WAT2021 workshop မှာ စာတမ်း ဖတ်နိုင်ဖို့အတွက်၊ system description paper ၃စောင်ကို အမှီရေးတင်လိုက်နိုင်ဖို့ contact လုပ်လို့ communication လုပ်လို့အဆင်ပြေတဲ့ member တချို့နဲ့ပြင်ဆင်နေပါတယ်။  
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
3. Eithandar Phyu (UTYCC, Myanmar)
4. Khaing Hsu Wai (UTYCC, Myanmar)
5. Myo Mar Thinn (UTYCC, Myanmar)
6. Hay Man Htun (UTYCC, Myanmar)

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

### Hybrid Translation with XML Markup 
   Sometimes we have external knowledge that we want to bring to the SMT decoder. We plug in XML markup based translations for transliterated words to the decoder without changing the PBSMT, HPBSMT and OSM model.  
   
   WAT2021 English-Myanmar share task ရဲ့ test data ကို ကြည့်တဲ့အခါမှာ အင်္ဂလိပ်စကားလုံးတွေကို တိုက်ရိုက် ဗမာလိုအသံထွက်အတိုင်းချရေးထားတဲ့ စာလုံးတွေ (transliterated word) အများကြီးတွေ့ရလို့ corpus တစ်ခုလုံး (i.e.UCSY+ALT) ထဲက နေ transliterated word တွေကို ဆွဲထုတ်ဖို့ မလွယ်ကူပေမဲ့ ALT corpus (စာကြောင်းရေ နှစ်သောင်းကျော်) ထဲက အသံထွက်အတိုင်းပဲ ချရေးပြီး ဘာသာပြန်ထားတဲ့ စာလုံးတွေအားလုံးကို manually ဆွဲထုတ်ပြီး dictionary ဆောက်လိုက်တယ်။ SMT decoding လုပ်တဲ့အခါမှာ အဲဒီ dictionary ကို သုံးပြီး hybrid translation လုပ်ခဲ့တယ်။ ဆွဲထုတ်တဲ့အခါမှာ အဓိကပါဝင်တဲ့ စာလုံးတွေက လူနာမည်တွေ၊ အဖွဲ့အစည်းနာမည်၊ နိုင်ငံနာမည် အများစုမို့ NER (Named-entity recognition) စာလုံးတွေလို့ မှတ်ယူနိုင်ပါတယ်။    
   
### Ensemble Two Models

### Multi-source Neural Machine Translation

## System/Framework

NMT အတွက်က framework သုံးမျိုးလောက် test run လုပ်ခဲ့ပါသေးတယ်။ GPU နှစ်လုံးထဲနဲ့ limited memory မှာ deadline အချိန်မှီအောင် ပြင်ဆင်ခဲ့ရတာမို့ တကယ် experiment တွေလုပ်ဖြစ်သွားတာက Marian NMT Framework တစ်ခုတည်းပေါ်မှာပါပဲ။   

* Moses: [http://www.statmt.org/moses/](http://www.statmt.org/moses/)  
* Marian: [https://github.com/marian-nmt/marian](https://github.com/marian-nmt/marian)

## System Description Papers

To Appear  
