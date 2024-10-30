# Download_SRA
### Description
Short script used to download, rename and gzip SRA FASTQ files from Accession List.  
It requires a comma-delimited table containing SRR numbers in the first column, and desired corresponding filename in the second column without special caracter or white space. (See [Example_SRR_List.csv](https://github.com/JosephLeger/Download_SRA/blob/main/data/Example_SRR_List.csv)).  

### Environment
The workflow is encoded in Shell language and is supposed to be launched under a Linux environment. Moreover, it was written to be used on a computing cluster with tools already pre-installed in the form of modules. Modules are so loaded using module load <tool_name> command. If you use manually installed environments, simply replace module loading in the script section by the environment activation command.  
The provided script launch downloading tasks as qsub task submission.

### Requirments
```
Name                     Version
sra-tools                2.11.0
```

### Syntax 
sh DL_SRA.sh <sheet_sample.csv>
