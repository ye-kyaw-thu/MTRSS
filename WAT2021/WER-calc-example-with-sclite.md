# WER Calculation for Model Ensemble Experiment

Preparing files...   

##  English-Myanmar
### Reference File:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ cp ~/exp/nmt/plus-alt/data/test.my .
```
### s2s:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ cp ~/exp/nmt/plus-alt/model.s2s-4/hyp.model.my ./s2s.en-my.hyp
```
### transformer:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ cp ~/exp/nmt/plus-alt/model.transformer/hyp.model.my ./transformer.en-my.hyp
```
### Ensemble, s2s+transformer:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ cp ~/exp/nmt/plus-alt/ensembling-results/hyp.s2s-plus-transformer.my{1,2,3} .
```

## Myanmar-English
### Reference File:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/my-en$ cp ~/exp/nmt/plus-alt/data/test.en .
```
### s2s:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/my-en$ cp ~/exp/nmt/plus-alt/model.s2s-4.my-en/hyp.model.en ./s2s.my-en.hyp
```
### transformer:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/my-en$ cp ~/exp/nmt/plus-alt/model.transformer.my-en/hyp.model.en ./transformer.my-en.hyp
```
### Ensemble, s2s+transformer:
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/my-en$ cp ~/exp/nmt/plus-alt/ensembling-results/2.hyp.s2s-plus-transformer.en{1,2,3} .
```
## Folder Structure
```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ tree
.
├── en-my
│   ├── hyp.s2s-plus-transformer.my1
│   ├── hyp.s2s-plus-transformer.my2
│   ├── hyp.s2s-plus-transformer.my3
│   ├── s2s.en-my.hyp
│   ├── test.my
│   └── transformer.en-my.hyp
├── my-en
│   ├── 2.hyp.s2s-plus-transformer.en1
│   ├── 2.hyp.s2s-plus-transformer.en2
│   ├── 2.hyp.s2s-plus-transformer.en3
│   ├── s2s.my-en.hyp
│   ├── test.en
│   └── transformer.my-en.hyp
└── note.txt

2 directories, 13 files
```

## Prepare a Shell Script

```bash
#!/bin/bash

for folder in *; do
    if [ -d "$folder" ]; then
    for file in $folder/*; do
        echo "Adding speaker id to $file"
        perl add-spu_id.pl $file > $file.id 
     done
    fi
done
```

## Add Speaker ID

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ ./add-id.sh 
Adding speaker id to en-my/hyp.s2s-plus-transformer.my1
Adding speaker id to en-my/hyp.s2s-plus-transformer.my2
Adding speaker id to en-my/hyp.s2s-plus-transformer.my3
Adding speaker id to en-my/s2s.en-my.hyp
Adding speaker id to en-my/test.my
Adding speaker id to en-my/transformer.en-my.hyp
Adding speaker id to my-en/2.hyp.s2s-plus-transformer.en1
Adding speaker id to my-en/2.hyp.s2s-plus-transformer.en2
Adding speaker id to my-en/2.hyp.s2s-plus-transformer.en3
Adding speaker id to my-en/s2s.my-en.hyp
Adding speaker id to my-en/test.en
Adding speaker id to my-en/transformer.my-en.hyp
```

## Check Files

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ head -n 3 ./en-my/*.id
==> ./en-my/hyp.s2s-plus-transformer.my1.id <==
ဆစ် ဒ နီ တွင် စိတ် ထက် မြက် သော မြင်း ရှစ် ကောင် သည် တုပ် ကွေး ရော ဂါ ခံ စား နေ ရ သည် ဟု အ တည် ပြု ထား ပါ သည် ။ (ye_1)
ဝေ ဒ နာ ခံ စား နေ ရ ပြီး နှစ် လ အ ထိ ဆက် လက် တည် ရှိ နေ မည် ဟု ယူ ဆ ရ ပါ သည် ။ (ye_2)
တုပ် ကွေး ရော ဂါ သည် ကု လ သ မဂ္ဂ အ တွင်း ရှိ မြင်း ၇၀၀ အ များ စု အ တွက် အ ကျိုး သက် ရောက် မည် ဟု မျှော် လ င့် ပါ သည် ။ (ye_3)

==> ./en-my/hyp.s2s-plus-transformer.my2.id <==
ဆစ် ဒ နီ တွင် စိတ် ထက် သန် သော မြင်း ရှစ် ကောင် သည် တုပ် ကွေး ရော ဂါ ခံ စား နေ ရ သည် ဟု အ တည် ပြု ထား ပါ သည် ။ (ye_1)
ဝေ ဒ နာ ခံ စား နေ ရ ပြီး နှစ် လ အ ထိ ဆက် လက် တည် ရှိ နေ မည် ဟု ယူ ဆ ရ ပါ သည် ။ (ye_2)
တုပ် ကွေး ရော ဂါ သည် ကု လ သ မဂ္ဂ အ တွင်း မှ လူ ၇၀၀ အ များ စု ကို ထိ ခိုက် စေ မည် ဟု မျှော် လ င့် ပါ သည် ။ (ye_3)

==> ./en-my/hyp.s2s-plus-transformer.my3.id <==
ဆစ် ဒ နီ တွင် စိတ် ထက် သန် သော မြင်း ရှစ် ကောင် သည် တုပ် ကွေး ရော ဂါ ခံ စား နေ ရ သည် ဟု အ တည် ပြု ပြော ကြား ထား ပါ သည် ။ (ye_1)
ဝေ ဒ နာ ခံ စား နေ ရ သူ သည် ပိတ် မိ နေ ပြီး နှစ် လ အ ထိ ဆက် လက် တည် ရှိ နေ မည် ဟု မျှော် လ င့် ရ သည် ။ (ye_2)
တုပ် ကွေး ရော ဂါ သည် ကု လ သ မဂ္ဂ အ တွင်း မှ လူ ၇၀၀ အ များ စု ကို ထိ ခိုက် စေ မည် ဟု မျှော် လ င့် ရ ပါ သည် ။ (ye_3)

==> ./en-my/s2s.en-my.hyp.id <==
ဆစ် ဒ နီ မြို့ တော် မှ စိတ် ထက် သန် သော လူ မျိုး ရှစ် မျိုး ကို ရော ဂါ ကူး စက် ခံ ထား ရ သည် ဟု အ တည် ပြု ပြော ကြား ထား ပါ သည် ။ (ye_1)
အ ရက် ဆိုင် ပိတ် ခံ ရ ပြီး နောက် ပိုင်း နှစ် လ အ ထိ ဆက် လက် တည် ရှိ နေ မည် ဟု မျှော် လ င့် ရ သည် ။ (ye_2)
သာ မန် အား ဖြ င့် အ မေ ရိ ကန် ဒေါ် လာ သန်း ပေါင်း ၇၀၀ အ ထိ ရှိ လာ မည် ဟု မျှော် လ င့် ရ ပါ သည် ။ (ye_3)

==> ./en-my/test.my.id <==
ဆစ် ဒ နီ က ရ န့် ဝစ်ခ် မြင်း ပြိုင် ကွင်း မှ မျိုး သ န့် ပြိုင် မြင်း ရှစ် ကောင် ဟာ မြင်း တုတ် ကွေး ရော ဂါ ကူး စက် ခံ ခဲ့ ရ တယ် ဆို တာ အ တည် ပြု ခဲ့ ပါ တယ် ။ (ye_1)
ရ န့် ဝစ်ခ် ကို ပိတ် ထား ခဲ့ ပြီး ၂ လ အ ထိ ကြာ ကြာ ဆက် လက် ထိန်း သိမ်း ထား ရန် မျှော် လ င့် ပါ တယ် ။ (ye_2)
အ လွန် ပြင်း ထန် သော တုတ် ကွေး ဟာ ရ န့် ဝစ်ခ် မှာ အ မြဲ ထား သော မြင်း ၇၀၀ ထဲ က အ များ စု ကို ကူး စက် လိ မ့် မည် လို့ ခ န့် မှန်း ထား ပါ တယ် ။ (ye_3)

==> ./en-my/transformer.en-my.hyp.id <==
ဆစ် ဒ နီ ရှိ မြင်း ရှစ် ကောင် သည် တုပ် ကွေး ရော ဂါ ခံ စား နေ ရ သော အ ခြေ အ နေ တွင် စိတ် ထက် မြက် သော မြင်း ရှစ် ကောင် သည် စိတ် ဝင် စား မှု ရှိ ကြောင်း အ တည် ပြု ပြော ကြား ထား ပါ သည် ။ (ye_1)
ကု လား ထိုင် ခုံ သည် သော့ ပိတ် ထား ပြီး နှစ် လ အ ထိ ဆက် လက် တည် ရှိ နေ မည် ဟု မျှော် လ င့် ရ ပါ သည် ။ (ye_2)
တုပ် ကွေး ဝေ ဒ နာ ခံ စား နေ ရ သော တုပ် ကွေး သည် ကင် ဆာ အ ခြေ အ နေ ရှိ မြင်း ၇၀၀ အ နက် အ များ စု ကို ထိ ခိုက် စေ မည် ဟု မျှော် လ င့် ပါ သည် ။ (ye_3)
```

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ head -n 3 ./my-en/*.id
==> ./my-en/2.hyp.s2s-plus-transformer.en1.id <==
Eight races from the Sydney Cricket court have confirmed that the horse had been infected with flu (ye_1)
It is expected to remain maintained for two months . (ye_2)
It is estimated that most of the 700 horses always will be infected in the garage . (ye_3)

==> ./my-en/2.hyp.s2s-plus-transformer.en2.id <==
Eight horses from the Sydney Cricket court have confirmed that the horse had been infected with flu (ye_1)
It is expected to remain closed for two months and keep it . (ye_2)
It is estimated that most of the 700 horses always will be infected in the garage . (ye_3)

==> ./my-en/2.hyp.s2s-plus-transformer.en3.id <==
Eight horses from the Sydney Cricket church have confirmed that the horse had been infected with flu (ye_1)
I hope it has been closed for two months to keep it . (ye_2)
It is estimated that most of the 700 horses always will be infected in a very severe stick . (ye_3)

==> ./my-en/s2s.my-en.hyp.id <==
Eight companies from the Sydney Cricket golf clubs have confirmed that the horse had been infected with influenza disease. (ye_1)
Train has been closed and hope for two months . (ye_2)
Most of the 700 horses always think most of the 700 horse is expected . (ye_3)

==> ./my-en/test.en.id <==
It has been confirmed that eight thoroughbred race horses at Randwick Racecourse in Sydney have been infected with equine influenza . (ye_1)
Randwick has been locked down , and is expected to remain so for up to two months . (ye_2)
It is expected that the virulent flu will affect the majority of the 700 horses stabled at Randwick . (ye_3)

==> ./my-en/transformer.my-en.hyp.id <==
Red Cross has confirmed that eight races from the Olympic Park were infected with flu (ye_1)
I hope to keep the cork for two months and keep it tight . (ye_2)
It is widely predicted that most of the 700 horse ever will be infected in Las Vegas . (ye_3)
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$
```

## Check sclite --help

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ sclite --help
sclite: <OPTIONS>
sclite Version: 2.10, SCTK Version: 1.3
Input Options:
    -r reffile [ <rfmt> ]
                Define the reference file, and it's format
    -h hypfile [ <hfmt> <title> ]
                Define the hypothesis file, it's format, and a 'title' used
                for reports.  The default title is 'hypfile'.  This option
                may be used more than once.
    -i <ids>    Set the utterance id type.   (for transcript mode only)
    -P          Accept the piped input from another utility.
    -e gb|euc|utf-8 [ case-conversion-localization ]
                Interpret characters as GB, EUC, utf-8, or the default, 8-bit ASCII.
                Optionally, case conversion localization can be set to either 'generic',
                'babel_turkish', or 'babel_vietnamese'
Alignment Options:
    -s          Do Case-sensitive alignments.
    -d          Use GNU diff for alignments.
    -c [ NOASCII DH ]
                Do the alignment on characters not on words as usual by split-
                ting words into chars. The optional argument NOASCII does not
                split ASCII words and the optional arg. DH deletes hyphens from
                both the ref and hyp before alingment.   Exclusive with -d.
    -L LM       CMU-Cambridge SLM Language model file to use in alignment and scoring.
    -S algo1 lexicon [ ASCIITOO ]
    -S algo2 lexicon [ ASCIITOO ]
                Instead of performing word alignments, infer the word segmenta-
                tion using algo1 or algo2.  See sclite(1) for algorithm details.
    -F          Score fragments as correct.  Options -F and -d are exclusive.
    -D          Score words marked optionally deletable as correct if deleted.
                Options -D and -d are exclusive.
    -T          Use time information, (if available), to calculated word-to-
                word distances based on times. Options -F and -d are exlc.
    -w wwl      Perform Word-Weight Mediated alignments, using the WWL file 'wwl'.
                IF wwl is 'unity' use weight 1.o for all words.
    -m [ ref | hyp ]
                Only used for scoring a hyp/ctm file, against a ref/stm file.
                When the 'ref' option is used, reduce the reference segments
                to time range of the hyp file's words.  When the 'hyp' option
                is used, reduce the hyp words to the time range of the ref
                segments.  The two may be used together.  The argument -m
                by itself defaults to '-m ref'.  Exclusive with -d.
Output Options:
    -O output_dir
                Writes all output files into output_dir. Defaults to the
                hypfile's directory.
    -f level    Defines feedback mode, default is 1
    -l width    Defines the line width.
    -p          Pipe the alignments to another sclite utility.  Sets -f to 0.
Scoring Report Options:
    -o [ sum | rsum | pralign | all | sgml | stdout | lur | snt | spk | 
         dtl | prf | wws | nl.sgml | none ]
                Defines the output reports. Default: 'sum stdout'
    -C [ det | bhist | sbhist | hist | none ] 
                Defines the output formats for analysis of confidence scores.
                Default: 'none'
    -n name     Writes all outputs using 'name' as a root filename instead of
                'hypfile'.  For multiple hypothesis files, the root filename
                is 'name'.'hypfile'
Illegal argument: --help
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$
```

## Prepare a Shell Script for WER Calculation

```
#!/bin/bash

# WER calculating with sclite command
# written by Ye Kyaw Thu, LST, NECTEC, Thailand
# 5 June 2021
# $ wer-calc.sh en-my my-en

for arg in "$@"
do
   # get last 2 characters of the folder name (i.e. target language)
   trg=${arg: -2};
   cd $arg;
   for idFILE in *.id;
   do
      if [ "$idFILE" != "test.$trg.id" ]; then
         # to see some SYSTEM SUMMARY PERCENTAGES on screen 
         sclite -r ./test.$trg.id -h ./$idFILE -i spu_id
         # running with pra option 
         sclite -r ./test.$trg.id -h ./$idFILE -i spu_id -o pra
         # running with dtl option
         sclite -r ./test.$trg.id -h ./$idFILE -i spu_id -o dtl
         
      echo -e " Finished WER calculations for $fidFILE !!! \n\n"
      fi
   done
   cd ..;
done
```

## WER Calculation for All Hyp

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ ./wer-calc.sh en-my my-en
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my1.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                 ./hyp.s2s-plus-transformer.my1.id                 |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   58895  | 33.2   30.4   36.4    7.4   74.2  100.0 |
     |===================================================================|
     | Sum/Avg|  1018   58895  | 33.2   30.4   36.4    7.4   74.2  100.0 |
     |===================================================================|
     |  Mean  |1018.0  58895.0 | 33.2   30.4   36.4    7.4   74.2  100.0 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  58895.0 | 33.2   30.4   36.4    7.4   74.2  100.0 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my1.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 'hyp.s2s-plus-transformer.my1.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my1.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 'hyp.s2s-plus-transformer.my1.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my2.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                 ./hyp.s2s-plus-transformer.my2.id                 |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   58895  | 33.5   29.9   36.6    7.4   73.9  100.0 |
     |===================================================================|
     | Sum/Avg|  1018   58895  | 33.5   29.9   36.6    7.4   73.9  100.0 |
     |===================================================================|
     |  Mean  |1018.0  58895.0 | 33.5   29.9   36.6    7.4   73.9  100.0 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  58895.0 | 33.5   29.9   36.6    7.4   73.9  100.0 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my2.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 'hyp.s2s-plus-transformer.my2.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my2.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 'hyp.s2s-plus-transformer.my2.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my3.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                 ./hyp.s2s-plus-transformer.my3.id                 |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   58895  | 33.4   30.0   36.7    7.4   74.1  100.0 |
     |===================================================================|
     | Sum/Avg|  1018   58895  | 33.4   30.0   36.7    7.4   74.1  100.0 |
     |===================================================================|
     |  Mean  |1018.0  58895.0 | 33.4   30.0   36.7    7.4   74.1  100.0 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  58895.0 | 33.4   30.0   36.7    7.4   74.1  100.0 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my3.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 'hyp.s2s-plus-transformer.my3.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './hyp.s2s-plus-transformer.my3.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 'hyp.s2s-plus-transformer.my3.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './s2s.en-my.hyp.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                        ./s2s.en-my.hyp.id                         |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   58895  | 30.3   36.2   33.5    7.6   77.3  100.0 |
     |===================================================================|
     | Sum/Avg|  1018   58895  | 30.3   36.2   33.5    7.6   77.3  100.0 |
     |===================================================================|
     |  Mean  |1018.0  58895.0 | 30.3   36.2   33.5    7.6   77.3  100.0 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  58895.0 | 30.3   36.2   33.5    7.6   77.3  100.0 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './s2s.en-my.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 's2s.en-my.hyp.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './s2s.en-my.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 's2s.en-my.hyp.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './transformer.en-my.hyp.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                    ./transformer.en-my.hyp.id                     |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   58895  | 31.2   34.8   34.0    8.1   76.8  100.0 |
     |===================================================================|
     | Sum/Avg|  1018   58895  | 31.2   34.8   34.0    8.1   76.8  100.0 |
     |===================================================================|
     |  Mean  |1018.0  58895.0 | 31.2   34.8   34.0    8.1   76.8  100.0 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  58895.0 | 31.2   34.8   34.0    8.1   76.8  100.0 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './transformer.en-my.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 'transformer.en-my.hyp.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.my.id' and Hyp File: './transformer.en-my.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 'transformer.en-my.hyp.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en1.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                ./2.hyp.s2s-plus-transformer.en1.id                |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   27929  | 28.9   38.7   32.4    8.7   79.8   99.9 |
     |===================================================================|
     | Sum/Avg|  1018   27929  | 28.9   38.7   32.4    8.7   79.8   99.9 |
     |===================================================================|
     |  Mean  |1018.0  27929.0 | 28.9   38.7   32.4    8.7   79.8   99.9 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  27929.0 | 28.9   38.7   32.4    8.7   79.8   99.9 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en1.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to '2.hyp.s2s-plus-transformer.en1.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en1.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report '2.hyp.s2s-plus-transformer.en1.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en2.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                ./2.hyp.s2s-plus-transformer.en2.id                |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   27929  | 29.2   39.1   31.6    9.0   79.7   99.9 |
     |===================================================================|
     | Sum/Avg|  1018   27929  | 29.2   39.1   31.6    9.0   79.7   99.9 |
     |===================================================================|
     |  Mean  |1018.0  27929.0 | 29.2   39.1   31.6    9.0   79.7   99.9 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  27929.0 | 29.2   39.1   31.6    9.0   79.7   99.9 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en2.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to '2.hyp.s2s-plus-transformer.en2.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en2.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report '2.hyp.s2s-plus-transformer.en2.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en3.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                ./2.hyp.s2s-plus-transformer.en3.id                |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   27929  | 29.2   39.1   31.7    9.5   80.2   99.9 |
     |===================================================================|
     | Sum/Avg|  1018   27929  | 29.2   39.1   31.7    9.5   80.2   99.9 |
     |===================================================================|
     |  Mean  |1018.0  27929.0 | 29.2   39.1   31.7    9.5   80.2   99.9 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  27929.0 | 29.2   39.1   31.7    9.5   80.2   99.9 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en3.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to '2.hyp.s2s-plus-transformer.en3.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './2.hyp.s2s-plus-transformer.en3.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report '2.hyp.s2s-plus-transformer.en3.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './s2s.my-en.hyp.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                        ./s2s.my-en.hyp.id                         |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   27929  | 27.9   42.5   29.6   10.2   82.3   99.9 |
     |===================================================================|
     | Sum/Avg|  1018   27929  | 27.9   42.5   29.6   10.2   82.3   99.9 |
     |===================================================================|
     |  Mean  |1018.0  27929.0 | 27.9   42.5   29.6   10.2   82.3   99.9 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  27929.0 | 27.9   42.5   29.6   10.2   82.3   99.9 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './s2s.my-en.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 's2s.my-en.hyp.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './s2s.my-en.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 's2s.my-en.hyp.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 


sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './transformer.my-en.hyp.id'
    Alignment# 1018 for speaker ye          




                     SYSTEM SUMMARY PERCENTAGES by SPEAKER                      

     ,-------------------------------------------------------------------.
     |                    ./transformer.my-en.hyp.id                     |
     |-------------------------------------------------------------------|
     | SPKR   | # Snt   # Wrd  | Corr    Sub    Del    Ins    Err  S.Err |
     |--------+----------------+-----------------------------------------|
     | ye     |  1018   27929  | 26.0   41.0   33.0    6.8   80.8   99.9 |
     |===================================================================|
     | Sum/Avg|  1018   27929  | 26.0   41.0   33.0    6.8   80.8   99.9 |
     |===================================================================|
     |  Mean  |1018.0  27929.0 | 26.0   41.0   33.0    6.8   80.8   99.9 |
     |  S.D.  |  0.0      0.0  |  0.0    0.0    0.0    0.0    0.0    0.0 |
     | Median |1018.0  27929.0 | 26.0   41.0   33.0    6.8   80.8   99.9 |
     `-------------------------------------------------------------------'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './transformer.my-en.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing string alignments to 'transformer.my-en.hyp.id.pra'

Successful Completion
sclite: 2.10 TK Version 1.3
Begin alignment of Ref File: './test.en.id' and Hyp File: './transformer.my-en.hyp.id'
    Alignment# 1018 for speaker ye          

    Writing overall detailed scoring report 'transformer.my-en.hyp.id.dtl'

Successful Completion
 Finished WER calculations for  !!! 
```

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ tree ./en-my
./en-my
├── hyp.s2s-plus-transformer.my1
├── hyp.s2s-plus-transformer.my1.id
├── hyp.s2s-plus-transformer.my1.id.dtl
├── hyp.s2s-plus-transformer.my1.id.pra
├── hyp.s2s-plus-transformer.my2
├── hyp.s2s-plus-transformer.my2.id
├── hyp.s2s-plus-transformer.my2.id.dtl
├── hyp.s2s-plus-transformer.my2.id.pra
├── hyp.s2s-plus-transformer.my3
├── hyp.s2s-plus-transformer.my3.id
├── hyp.s2s-plus-transformer.my3.id.dtl
├── hyp.s2s-plus-transformer.my3.id.pra
├── s2s.en-my.hyp
├── s2s.en-my.hyp.id
├── s2s.en-my.hyp.id.dtl
├── s2s.en-my.hyp.id.pra
├── test.my
├── test.my.id
├── transformer.en-my.hyp
├── transformer.en-my.hyp.id
├── transformer.en-my.hyp.id.dtl
└── transformer.en-my.hyp.id.pra

0 directories, 22 files
```

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$ tree ./my-en
./my-en
├── 2.hyp.s2s-plus-transformer.en1
├── 2.hyp.s2s-plus-transformer.en1.id
├── 2.hyp.s2s-plus-transformer.en1.id.dtl
├── 2.hyp.s2s-plus-transformer.en1.id.pra
├── 2.hyp.s2s-plus-transformer.en2
├── 2.hyp.s2s-plus-transformer.en2.id
├── 2.hyp.s2s-plus-transformer.en2.id.dtl
├── 2.hyp.s2s-plus-transformer.en2.id.pra
├── 2.hyp.s2s-plus-transformer.en3
├── 2.hyp.s2s-plus-transformer.en3.id
├── 2.hyp.s2s-plus-transformer.en3.id.dtl
├── 2.hyp.s2s-plus-transformer.en3.id.pra
├── s2s.my-en.hyp
├── s2s.my-en.hyp.id
├── s2s.my-en.hyp.id.dtl
├── s2s.my-en.hyp.id.pra
├── test.en
├── test.en.id
├── transformer.my-en.hyp
├── transformer.my-en.hyp.id
├── transformer.my-en.hyp.id.dtl
└── transformer.my-en.hyp.id.pra

0 directories, 22 files
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl$
```

## Let's Peek .dtl FILE

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ head -n 50 ./transformer.en-my.hyp.id.dtl 
DETAILED OVERALL REPORT FOR THE SYSTEM: ./transformer.en-my.hyp.id

SENTENCE RECOGNITION PERFORMANCE

 sentences                                        1018
 with errors                            100.0%   (1018)

   with substitions                     100.0%   (1018)
   with deletions                        99.7%   (1015)
   with insertions                       81.8%   ( 833)


WORD RECOGNITION PERFORMANCE

Percent Total Error       =   76.8%   (45253)

Percent Correct           =   31.2%   (18385)

Percent Substitution      =   34.8%   (20512)
Percent Deletions         =   34.0%   (19998)
Percent Insertions        =    8.1%   (4743)
Percent Word Accuracy     =   23.2%


Ref. words                =           (58895)
Hyp. words                =           (43640)
Aligned words             =           (63638)

CONFUSION PAIRS                  Total                 (15421)
                                 With >=  1 occurrences (15421)

   1:   98  ->  သည် ==> တယ်
   2:   69  ->  ခဲ့ ==> နေ
   3:   66  ->  တယ် ==> သည်
   4:   57  ->  ခဲ့ ==> ပါ
   5:   37  ->  ခဲ့ ==> ရှိ
   6:   30  ->  ခဲ့ ==> ကြား
   7:   23  ->  ကို ==> အ
   8:   23  ->  င့် ==> အ
   9:   23  ->  ၊ ==> အ
  10:   22  ->  ခဲ့ ==> ထား
  11:   22  ->  များ ==> တွေ
  12:   22  ->  များ ==> အ
  13:   21  ->  မည် ==> သည်
  14:   21  ->  ၊ ==> သည်
  15:   20  ->  က ==> သည်
  16:   18  ->  ခဲ့ ==> ဖြစ်
  17:   17  ->  တစ် ==> အ
  18:   17  ->  သည် ==> အ
  19:   16  ->  ကို ==> သို့
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$
```

## Let's Peek .pra FILE

```
(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$ head -n 52 ./transformer.en-my.hyp.id.pra


		DUMP OF SYSTEM ALIGNMENT STRUCTURE

System name:   ./transformer.en-my.hyp.id

Speakers: 
    0:  ye

Speaker sentences   0:  ye   #utts: 1018
id: (ye_1)
Scores: (#C #S #D #I) 16 9 14 20
REF:  ဆစ် ဒ နီ က ရ န့် ဝစ်ခ် မြင်း ပြိုင် ကွင်း မှ မျိုး သ န့် ပြိုင် မြင်း ရှစ် ကောင် ဟာ မြင်း တုတ် ကွေး ရော ဂါ ကူး စက် ခံ ********* ခဲ့ ရ ********* *** ********* *** ****** ************ ************ ********* ************ ********* *************** ************ *************** ********* ************ ********* ********* တယ် ဆို တာ                အ တည် ပြု ************ ************ ခဲ့ ပါ တယ် ။ 
HYP:  ဆစ် ဒ နီ *** *** ********* *************** *************** ****************** *************** ****** *************** *** ********* ရှိ          မြင်း ရှစ် ကောင် ****** သည်       တုပ် ကွေး ရော ဂါ ********* ********* ခံ စား နေ    ရ သော အ ခြေ အ နေ တွင် စိတ် ထက် မြက် သော မြင်း ရှစ် ကောင် သည် စိတ် ဝင် စား မှု ရှိ ကြောင်း အ တည် ပြု ပြော ကြား ထား ပါ သည် ။ 
Eval:                      D   D   D         D               D               D                  D               D      D               D   D         S                                                               D      S               S                                          D         D                I         S             I         I   I         I   I      I            I            I         I            I         I               I            I               I         I            I         I         S         S         S                                             I            I            S                S             

id: (ye_2)
Scores: (#C #S #D #I) 13 10 3 4
REF:  ****** ********* ရ             န့် ဝစ်ခ် ကို    ပိတ် ထား ခဲ့ ပြီး ၂          လ အ ထိ ကြာ ကြာ ဆက် လက် ********* ထိန်း သိမ်း ထား ရန် မျှော် လ င့် *** ပါ တယ် ။ 
HYP:  ကု လား ထိုင် ခုံ သည်       သော့ ပိတ် ထား ********* ပြီး နှစ် လ အ ထိ ********* ********* ဆက် လက် တည် ရှိ       နေ          မည် ဟု    မျှော် လ င့် ရ ပါ သည် ။ 
Eval: I      I         S               S         S               S                                   D                      S                           D         D                             I         S               S               S         S                                          I          S             

id: (ye_3)
Scores: (#C #S #D #I) 12 22 3 5
REF:  ************ ************ ****** *** ****** အ    လွန် ပြင်း ထန် သော တုတ် ကွေး ဟာ    ရ       န့် ဝစ်ခ် မှာ အ မြဲ ထား သော မြင်း ၇၀၀ ထဲ က       အ များ စု ကို ကူး စက် လိ          မ့် မည် လို့ ခ    န့်          မှန်း ထား ပါ တယ် ။ 
HYP:  တုပ် ကွေး ဝေ ဒ နာ ခံ စား    နေ          ရ       သော တုပ် ကွေး သည် ကင် ဆာ    အ             ခြေ အ ********* နေ    ရှိ မြင်း ၇၀၀ အ    နက် အ များ စု ကို ********* ထိ    ခိုက် စေ    မည် ************ ဟု မျှော် လ             င့် ပါ သည် ။ 
Eval: I            I            I      I   I      S      S            S               S                   S                         S         S         S         S               S             D         S         S                                   S      S                                           D         S         S               S                   D            S      S                  S               S                S             

id: (ye_4)
Scores: (#C #S #D #I) 13 10 23 20
REF:  *** ********* ****** ********* ********* ********* ************ ****** *** ********* ************ ********* ********* *** *** ********* *************** ****** *** တုတ် ကွေး ရဲ့ နောက် ဆုံး လက္ခ ဏာ       နောက် ရက် ****************** ၃၀ အ ထိ အ ထောက် အ ပံ့ တွေ ကို သီး သ န့် ထား လိ မ့်    မည် လို့ အ ဓိ က စက် မှု ဇုန် ရဲ့ အန် အက်စ် ဒ ဗ လျူ ဝန် ကြီး က    ပြော ခဲ့ ပါ       တယ် ။ 
HYP:  အ ခြေ ခံ စက် မှု ဝန် ကြီး ဌာ န ဝန် ကြီး အန် အက် ဒ ဗ လျူ အက်စ် ပီ က တုပ် ကွေး ရော ဂါ          ဖြစ် ပွား ပြီး နောက် ရက် ပေါင်း ၃၀ အ ထိ အ ထောက် အ ပံ့ ********* ********* ********* *** ********* ********* ****** ဖြစ် မည် ************ *** ****** *** ********* ********* ************ ********* ********* *************** *** *** ********* ********* ************ ဟု ပြော ********* ကြား သည် ။ 
Eval: I   I         I      I         I         I         I            I      I   I         I            I         I         I   I   I         I               I      I   S                         S         S               S            S            S                                      I                                                                      D         D         D         D   D         D         D      S                      D            D   D      D   D         D         D            D         D         D               D   D   D         D         D            S                   D         S            S             

id: (ye_5)
Scores: (#C #S #D #I) 23 9 18 12
REF:  *** ********* ****** ************ ********* ************ ********* အန် ********* *** *** ********* အက်စ် ဒ ဗ လျူ နှ င့် ကွင်းစ် လန်းဒ် တစ်    လျှောက် မှ အ ပန်း ဖြေ ရာ သုံး သော မြင်း များ ဒါ ဇင် များ စွာ ကူး စက် ခံ ရ သော် လည်း ဒီ ဖြစ် ရပ် ဟာ ပြိုင် မြင်း များ အ ************ တွက် ပ ထ မ ဆုံး ကူး စက် ခြင်း ဖြစ် ပါ သည် ။ 
HYP:  အ ဆို ပါ ဖြစ် ရပ် များ မှာ အန် အက် ဒ ဗ လျူ အက်       ဒ ဗ လျူ နှ င့် ကွင်း       စ                လန်း တို့          မှ အ ပန်း ဖြေ ****** နေ       သော မြင်း ************ ****** ********* ************ ********* ********* ********* ****** *** ************ ************ ****** ************ ********* ****** ****************** အ             များ အ ပြား သည်    ပ ထ မ ဆုံး ကူး စက် မှု       ဖြစ် ****** သည် ။ 
Eval: I   I         I      I            I         I            I                   I         I   I   I         S                                                  S                     S                  S            S                                                       D      S                                      D            D      D         D            D         D         D         D      D   D            D            D      D            D         D      D                  S                                I            S                                                         S                            D                    

id: (ye_6)
Scores: (#C #S #D #I) 11 11 2 1
REF:  တုတ် ကွေး သည် အ    လွန် အ လွယ် တ ကူ ကူး စက် ********* သော် လည်း လူ သား များ သို့ မ ထုတ် လွှ င့်    နိုင် ပါ    ။ 
HYP:  တုပ် ကွေး ရော ဂါ ဟာ       အ လွယ် တ ကူ ကူး စက် တတ် ပေ       မဲ့    လူ တွေ ဆီ       ကို    မ ************ ********* ပို့ နိုင် ဘူး ။ 
Eval: S                         S         S      S                                                            I         S            S                   S         S            S                D            D         S                            S             

id: (ye_7)
Scores: (#C #S #D #I) 17 3 12 0
REF:  အ မျိုး သား မြင်း    ပွဲ ပိတ် ထား ခြင်း သည် စက် မှု့ လုပ် ငန်း ကို နေ့ စဉ် ဒေါ် လာ များ သန်း ပေါင်း ဆယ် ဂ ဏန်း များ စွာ ကုန် ကျ စေ          ပါ       သည် ။ 
HYP:  အ မျိုး သား ပြိုင် ပွဲ ************ ********* *************** သည် ********* ************ ************ ************ ********* နေ့ စဉ် ဒေါ် လာ ************ သန်း ပေါင်း ********* *** ************ များ စွာ ကုန် ကျ ခြင်း ဖြစ် သည် ။ 
Eval:                               S                            D            D         D                         D         D            D            D            D                                                 D                                            D         D   D                                                       S               S                          

(base) ye@administrator-HP-Z2-Tower-G4-Workstation:~/exp/nmt/plus-alt/WER-calc/syl/en-my$
```
