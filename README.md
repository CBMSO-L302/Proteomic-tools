# Proteomics

For our task we needed to check whether peptides from a proteomic experimental inpit in a fasta file crossed with the fasta file of the annoptated peptides transcribed from the coding sequence (CDS) were different from those generated when we crossed this proteomic experiment with ALL the posible peptides (6ORF). If we found a difference, then those peptides in the annotated CDS should be modified by expanding the CDS or new peptides could appear.

After crossing proteomic with genomic files (CDS and 6ORF), peptides detected were put into a list and if these peptides are not in the CDS file but they are in the 6ORF file, then they should be analyzed closely.

This tool allows you from a list of peptides (query) to cross it with the peptide fasta file (subject) and tell you whether these peptides are or not in the subject file.

As output, it exports a list of FOUND peptides - peptides-found.txt - and a list of peptides NOT FOUND - peptides-notfound.txt - (the interesting file in this case).

This tool should also work with DNA or RNA files, but it has the name 'peptide' since it was made for this purpose.

## Usage

This shell script uses bash.

`bash path/to/find_non_matching_sequences.sh -q [1] -s [2] -o [3]`

The options are mandatory, and mean:

-q: path to query file
-s: path to subject file
-o: output folder

### Example of usage:

I try to find if the peptides in my list (list.csv) are in the proteome of Leishmania infantum (LINF_proteome.fasta), and I want the output in a folder I named 'output':

`bash find_non_matching_sequences.sh -q ./input/list.csv -s ./input/LINF_proteome.fasta -o ./output`

The output will be 2 files:

`peptides-found.txt`
`peptides-notfound.txt`

And there will be an intermediate file, which will eliminate the repetitions in the original file which will be `NoReps.txt`.

Example of output file:

```
RGSQQYRGLSVAELTQQMFDAKN

ELTQQMFDAKN

RSVLMMGRY

KEEYAAFYKA

KKCLEMFDEVAENKEDYK

KESALVEMRA

KALSMANVKP

RVCGSAAASAARLARH

WVQDGNGKQYS

NVINGGKHAGNVLPFQ

VADSVHVSKS

KDDTVMLNGGGDAAAVKER
```



