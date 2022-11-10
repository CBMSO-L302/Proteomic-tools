#!bin/bash

### Script for finding selected partial sequences MATCHING and NOT MATCHING to other sequence list

### Input format: 

# query (-q): as a list in a csv or txt file (or similar) with ONLY the sequences you're looking for
# subject (-s): as a list or a fasta file, with sequences
# output folder (-o): 

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
      echo "script usage: $(basename \$0) [-q path/to/query_seq.csv or query_seq.csv if same folder] [-s subject_seq.fasta] [-o /output_folder]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

##Removing repetitions

awk -F '\t' ' !seen[$1]++{print $1}' $QUERY > $OUTPUT_FOLDER/NoReps.txt
echo 'repetitions eliminated'

##Loop for sequences search

echo 'checking the presence of these sequences in the original file...'

#Removing possible previous files
rm -rf $OUTPUT_FOLDER/peptides-found.txt 2> /dev/null
rm -rf $OUTPUT_FOLDER/peptides-notfound.txt 2> /dev/null

readarray -t array1 < $OUTPUT_FOLDER/NoReps.txt
for SEQ in "${array1[@]}"
do
  	if grep -q $SEQ $SUBJECT; then
                echo $SEQ >> $OUTPUT_FOLDER/peptides-found.txt
        else
            	echo $SEQ >> $OUTPUT_FOLDER/peptides-notfound.txt
        fi
done

echo 'Search finished.'
echo 'number of peptides found:'
wc $OUTPUT_FOLDER/peptides-found.txt |  awk {'print $1'}

echo 'number of peptides NOT found:'               
wc $OUTPUT_FOLDER/peptides-notfound.txt |  awk {'print $1'}

