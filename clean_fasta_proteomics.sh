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
sed 's/.(sub //g' ${name}.fasta > ${name}_clean0.fasta
sed 's/(del //g' ${name}_clean0.fasta > ${name}_clean1.fasta
sed 's/([^)]*)//g' ${name}_clean1.fasta > ${name}_clean2.fasta
sed 's/)//g' ${name}_clean2.fasta > ${name}_clean3.fasta
sed 's/,/\n/g' ${name}_clean3.fasta > ${name}_clean4.fasta
sed '/3/! s/[.]//g' ${name}_clean4.fasta > ${name}_clean5.fasta
sed '/3/! s/^.\(.*\).$/\1/' ${name}_clean5.fasta > ${name}_clean.fasta
rm -f ${name}_clean?.fasta 

a='clean of '
a+=${name}
a+='.fasta finished.'

echo $a

