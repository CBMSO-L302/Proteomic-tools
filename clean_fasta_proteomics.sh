#!bin/bash

while getopts 's:o:' flag; do
  case "${flag}" in
    s)
      SEQUENCES="${OPTARG}"
      ;;
    o)
      OUTPUT_FOLDER="${OPTARG}"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-s /path/to/sequences.fasta] [-o /path/to/output_folder]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

name=$(echo $SEQUENCES | awk -F'.' '{print $1}')

rm -f $OUTPUT_FOLDER/*clean.fasta

readarray fasta_file < "${SEQUENCES}"
while read seq ; do

	echo $seq | if grep -q ">" ; then
		echo $seq >> ${name}_clean.fasta
		
	else
		echo $seq |
		sed 's/.(sub //g'  |
		sed 's/(del //g' |
		sed 's/.(ins //g' |
		sed 's/([^)]*)//g' | 
		sed 's/)//g' |
		sed 's/,/\n/g' | 
		sed '/>/! s/[.]//g' | 
		sed '/>/! s/^.\(.*\).$/\1/' > ${name}_clean.fasta
	fi
done < $SEQUENCES
rm -f ${name}_clean?.fasta 

a='cleaning of '
a+=${name}
a+='.fasta finished.'

echo $a

