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

