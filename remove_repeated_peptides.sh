#!bin/bash

### Script for removing repeated peptides that could be contained inside other peptide sequences

### Input format: 

# query (-q): as a list in a csv or txt file or similar with ONLY the sequences of interest
# output folder (-o): folder where the files will be exported. Careful! Previous files with the same names in this folder will be removed!

while getopts 'q:s:' flag; do
  case "${flag}" in
    q)
      QUERY="${OPTARG}"
      ;;
    o)
      OUTPUT_FOLDER="${OPTARG}"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-q path/to/query_seq.csv] [-o /output_folder]" >&2
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
rm -rf $OUTPUT_FOLDER/peptides-notrepeated.txt 2> /dev/null
rm -rf $OUTPUT_FOLDER/peptides-repeated.txt 2> /dev/null

readarray -t array1 < $OUTPUT_FOLDER/NoReps.txt

for SEQ in "${array1[@]}"
do
	if [ "$(grep -c $SEQ $QUERY)" == 1 ]; then
		echo $SEQ >> $OUTPUT_FOLDER/peptides-notrepeated.txt
	else
		echo $SEQ >> $OUTPUT_FOLDER/peptides-repeated.txt
	fi
done

echo 'Search finished.'
echo 'number of unique peptides:'
wc $OUTPUT_FOLDER/peptides-notrepeated.txt |  awk {'print $1'}

echo 'number of peptides repeated:'               
wc $OUTPUT_FOLDER/peptides-repeated.txt |  awk {'print $1'}

