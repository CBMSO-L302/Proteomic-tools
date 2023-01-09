#!bin/bash

while getopts 's:o:n:' flag; do
  case "${flag}" in
    s)
      SEQUENCES="${OPTARG}"
      ;;
    o)
      OUTPUT_FOLDER="${OPTARG}"
      ;;
    n)
      SPECIES_NAME="${OPTARG}"
      ;;
    ?)
      echo "script usage: $(basename \$0) [-s /path/to/sequences.fasta] [-o /path/to/output_folder] [-n Name_of_Species_in_Sequence]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

name=$(echo $SEQUENCES | awk -F'.' '{print $1}')

output=$(echo $OUTPUT_FOLDER)
output+='/'
output+=${name}

species=$SPECIES_NAME

#removing previous clean.fasta files
rm -f $OUTPUT_FOLDER/*clean.fasta

#removing modifications:
sed 's/.(sub //g' ${name}.fasta > ${output}_clean0.fasta  #Removing X(sub
sed 's/(del //g' ${output}_clean0.fasta > ${output}_clean1.fasta  #Removing (del
sed 's/([^)]*)//g' ${output}_clean1.fasta > ${output}_clean2.fasta  #Removing content between parentheses
sed 's/)//g' ${output}_clean2.fasta > ${output}_clean3.fasta  #Removing closing parentheses
sed 's/,/\n/g' ${output}_clean3.fasta > ${output}_clean4.fasta  #Substituting commas with break (in csv)

#removing dots from lines that are not the ones containing the species name

sed "/${species}/! s/[.]//g" ${output}_clean4.fasta > ${output}_clean5.fasta

#removing first and last aminoacid from lines that are not the ones containing the species name

sed "/${species}/! s/^.\(.*\).$/\1/" ${output}_clean5.fasta > ${output}_clean.fasta

#removing intermediate fasta files
rm -f ${output}_clean?.fasta 

a='clean of '
a+=${name}
a+='.fasta finished.'

echo $a

