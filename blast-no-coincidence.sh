#!bin/bash

export BLASTP_HOME=/usr/bin

while getopts 'q:s:o:' flag; do
  case "${flag}" in
    q)
      QUERY="${OPTARG}"
      ;;
    s)
      SUBJECT="${OPTARG}"
      ;;
    o)
      OUTPUT_FOLDER="${OPTARG}"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-q query_seq.fasta] [-s subject_seq.fasta] [-o /output_folder]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

###BlastP for extracting %coverage (qcovs) and %identity (pident) - only 1st result

##BlastP

$BLASTP_HOME/blastp -query $QUERY -subject $SUBJECT -outfmt "6 qseqid sseqid qcovs" -max_target_seqs 1 > $OUTPUT_FOLDER/Query-Qcovs.txt
echo 'blastp for qcovs done'

$BLASTP_HOME/blastp -query $QUERY -subject $SUBJECT -outfmt "6 qseqid sseqid pident" -max_target_seqs 1 > $OUTPUT_FOLDER/Query-Pident.txt
echo 'blastp for pident done'

##Localizing results that do NOT contain 100%

grep -v '100' $OUTPUT_FOLDER/Query-Qcovs.txt > $OUTPUT_FOLDER/Qcovs-not100.csv
grep -v '100' $OUTPUT_FOLDER/Query-Pident.txt > $OUTPUT_FOLDER/Pident-not100.csv
echo 'proteins with less than 100% localized'

##Extracting ONLY protein sequences 

awk -F '\t' ' !seen[$1]++{print $1}' $OUTPUT_FOLDER/Qcovs-not100.csv > $OUTPUT_FOLDER/NoReps-Not100Qcovs.txt
awk -F '\t' ' !seen[$1]++{print $1}' $OUTPUT_FOLDER/Pident-not100.csv > $OUTPUT_FOLDER/NoReps-Not100ident.txt
echo 'repetitions eliminated'

##Counting number of sequences without a 100% match

wc $OUTPUT_FOLDER/NoReps-Not100Qcovs.txt | awk {'print $1'} > $OUTPUT_FOLDER/number1
num1=$(cat $OUTPUT_FOLDER/number1)
echo 'number of qcovs less than 100%:' 
echo $num1 

wc $OUTPUT_FOLDER/NoReps-Not100ident.txt | awk {'print $1'} > $OUTPUT_FOLDER/number2
num2=$(cat $OUTPUT_FOLDER/number2)
echo 'number of pident less than 100%:'
echo $num2

##Loop for modifying sequences with wild cards
echo 'checking the presence of these sequences in the original file...'
echo 'checking sequences with <100% coverage...'

rm Qcovs-found.txt
rm Qcovs-notfound.txt

readarray -t array1 < $OUTPUT_FOLDER/NoReps-Not100Qcovs.txt
for SEQ in "${array1[@]}"
do
	if grep -q $SEQ $SUBJECT; then
		echo $SEQ >> Qcovs-found.txt
	else
    		echo $SEQ >> Qcovs-notfound.txt
	fi
done
echo 'Qcovs search finished.'
echo 'checking sequences with <100% identity...'

rm Pident-found.txt
rm Pident-notfound.txt

readarray -t array < $OUTPUT_FOLDER/NoReps-Not100ident.txt
for SEQ in "${array[@]}"
do
        if grep -q $SEQ $SUBJECT; then
                echo $SEQ >> Pident-found.txt
        else
                echo $SEQ >> Pident-notfound.txt 
        fi
done
echo 'Pident search finished'

