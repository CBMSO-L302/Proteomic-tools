# Proteomics

For our task we needed to check whether peptides from a proteomic experimental inpit in a fasta file crossed with the fasta file of the annoptated peptides transcribed from the coding sequence (CDS) were different from those generated when we crossed this proteomic experiment with ALL the posible peptides (6ORF). If we found a difference, then those peptides in the annotated CDS should be modified by expanding the CDS or new peptides could appear.

After crossing proteomic with genomic files (CDS and 6ORF), peptides detected were put into a list and if these peptides are not in the CDS file but they are in the 6ORF file, then they should be analyzed closely.

`find_non_matching_sequences.sh`

The tool `find_non_matching_sequences.sh` allows you from a list of peptides (query) to cross it with the peptide fasta file (subject) and tell you whether these peptides are or not in the subject file.

As output, it exports a list of FOUND peptides - `peptides-found.txt` - and a list of peptides NOT FOUND - `peptides-notfound.txt` - (the interesting file in this case).

This tool should also work with DNA or RNA files, but it has the name 'peptide' since it was made for this purpose.

## Usage

This shell script uses bash.

`bash path/to/find_non_matching_sequences.sh -q /path/to/query.csv -s /path/to/subject.fasta -o /path/to/output/folder`

The options are mandatory, and mean:

`-q`: path to query file

`-s`: path to subject file

`-o`: output folder

### Example of usage:

I try to find if the peptides in my list (list.csv) are in the proteome of Leishmania infantum (LINF_proteome.fasta), and I want the output in a folder I named 'output':

`bash find_non_matching_sequences.sh -q path/to/input/list.csv -s path/to/input/LINF_proteome.fasta -o path/to/output`

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
VADSVHSKS
KDDTVMLNGGGDAAAVKER
```

`remove_repeated_peptides.sh`

The tool `remove_repeated_peptides.sh` is intended to remove peptides that could be contained inside other bigger peptides in the same file, therefore simplifying the task of manually exploring the peptide files. The tool will first eliminate repetitions (exact same peptide). Then, it will look for each sequence inside the same file and export them in the determined output_folder: 

- the not repeated sequences will be exported in the `peptides-notrepeated.txt` file
- the repeated sequences will be in the `peptides-repeated.txt` file

## Usage

The script is based on the previous tool, so the usage is very similar:

`bash find_non_matching_sequences.sh -q path/to/input/list.csv -o path/to/output`

In this case, since we only need one file which needs to be modified, we only need the query option. These options are mandatory for the tool to function.

`-q`: path to query file

`-o`: output folder

The output file example will be the same as in the previous tool, and it will also generate an intermediate file called ´NoReps.txt´. 
