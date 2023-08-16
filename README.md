# Proteomics

For our task we needed to check whether peptides from a proteomic experimental inpit in a fasta file crossed with the fasta file of the annoptated peptides transcribed from the coding sequence (CDS) were different from those generated when we crossed this proteomic experiment with ALL the posible peptides (6ORF). If we found a difference, then those peptides in the annotated CDS should be modified by expanding the CDS or new peptides could appear.

After crossing proteomic with genomic files (CDS and 6ORF), peptides detected were put into a list and if these peptides are not in the CDS file but they are in the 6ORF file, then they should be analyzed closely.

## find_non_matching_sequences.sh

The tool `find_non_matching_sequences.sh` allows you from a list of peptides (query) to cross it with the peptide fasta file (subject) and tell you whether these peptides are or not in the subject file.

As output, it exports a list of FOUND peptides - `peptides-found.txt` - and a list of peptides NOT FOUND - `peptides-notfound.txt` - (the interesting file in this case).

This tool should also work with DNA or RNA files, but it has the name 'peptide' since it was made for this purpose.


### Usage

This shell script uses bash.

`bash /path/to/find_non_matching_sequences.sh -q /path/to/query.csv -s /path/to/subject.fasta -o /path/to/output/folder`

The options are mandatory, and mean:

`-q`: path to query file

`-s`: path to subject file

`-o`: output folder

#### Example of usage:

I try to find if the peptides in my list (list.csv) are in the proteome of Leishmania infantum (LINF_proteome.fasta), and I want the output in a folder I named 'output':

`bash find_non_matching_sequences.sh -q path/to/input/list.csv -s path/to/input/LINF_proteome.fasta -o path/to/output`

The output will be 2 files:

- peptides found in both files will be in the file `peptides-found.txt`
- peptides in the query file not found in the subject file will be in `peptides-notfound.txt`

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

CAREFUL! If there are ANY files in the output folder named "NoReps.txt", "peptides-found.txt" and/or "peptides-notfound.txt" they will be REMOVED at the beginning of the process.

## remove_repeated_peptides.sh

The tool `remove_repeated_peptides.sh` is intended to remove peptides that could be contained inside other bigger peptides in the same file, therefore simplifying the task of manually exploring the peptide files. The tool will first eliminate repetitions (exact same peptide). Then, it will look for each sequence inside the same file and export them in the determined output_folder: 

- the not repeated sequences will be exported in the `peptides-notrepeated.txt` file
- the repeated sequences will be in the `peptides-repeated.txt` file

### Usage

The script is based on the previous tool, so the usage is very similar:

`bash /path/to/find_non_matching_sequences.sh -q /path/to/input/list.csv -o /path/to/output`

In this case, since we only need one file which needs to be modified, we only need the query option. These options are mandatory for the tool to function.

`-q`: path to query file

`-o`: output folder

The output file example will be the same as in the previous tool, and it will also generate an intermediate file called ´NoReps.txt´. 

CAREFUL! If there are ANY files in the output folder named "NoReps.txt", "peptides-repeated.txt" and/or "peptides-notrepeated.txt" they will be REMOVED at the beginning of the process.

## clean_fasta_proteomics.sh

The tool `clean_fasta_proteomics.sh` was designed for manipulating proteomics data extracted with peaks. This kind of data has some modificatios because the peptides appear with some modifications. The program also adds an aminoacid at the beginning and the end of the detected sequence, which matches with the database, but since they're NOT really detected, we eliminate them. We treat them with this script in order to elliminate these issues so that they match with the other peptide files obtained with the same program. The modifications of the peptide sequences from Peaks and the transformations made are the following:

- `X.SEQUENCE.Y`: The aminoacids X and Y are not directly detected, so we remove the dots and these 2 aminoacids.

E.g: H.ABCDEFGHI.P > ABCDEFGHI

- `X(sub Y)`: The aminoacid X is substituted with the aminoacid Y. 

E.g: ABCDE **Z(sub F)** GHI > ABCDEFGHI

- `(del Y)`: The aminoacid 'Y' is not in the detected sequence, but if added it matches with the genomic sequence. Therefore, we add it again.

E.g: ABC **(del D)** EFGHI > ABCDEFGHI

- `Y(ins)`: The aminoacid Y is detected, but not in the genomic sequence. Therefore, we remove it to match the fasta sequence.

E.g: ABCDEF **R(ins)** GHI > ABCDEFGHI

- `(+NUM.BER)`: The aminoacid has some post-traductional modification, we just remove them. Sa

E.g: AB **(+101.03)** CDEF **(-12.01)** GHI > ABCDEFGHI

There will be 2 output files:

- repeated peptides, found in bigger peptidic sequences, will be in `peptides-repeated.txt`
- unique peptides will be exported into the `peptides-notrepeated.txt` file

### Usage

`bash /path/to/clean_fasta_proteomics.sh -s /path/to/sequences.csv -o /path/to/output -n name_of_the_species`

`-q`: path to sequences file

`-o`: output folder

`-n`: name of the species that appears in the sequences names of the fasta file

The output file example will be the same as in the previous tools. It will also generate some intermediate files (0-5) with the extension `_clean(number).fasta`, which will be removed after the process finishes.

The usage of the option -n is optional, and it's only for avoiding the removal of characters in the fasta names. For example, if we have a fasta file with the format:

```
>LdHU3:126327..237520
A.AKLDFKVSBKSAHS.F
```

If we want the script to act only in lines without the 'LdHU3' name, we use the option -n LdHU3. However, if we don't specify the specific characters that distinguish the fasta file, it might end up like this:

```
LdHU3:1263723752
AKLDFKVSBKSAHS
```

CAREFUL! If there are ANY files in the output folder with the extension "clean.fasta" (*clean.fasta) they will be REMOVED at the beginning of the process. 
