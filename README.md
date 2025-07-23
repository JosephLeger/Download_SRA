# Download_SRA
### Description
Short script used to download, rename and gzip SRA FASTQ files from Accession List.  
It requires a comma-delimited table containing SRR numbers in the first column, and desired corresponding filename in the second column without header, special caracter or white space. (See [Example_SRR_List.csv](https://github.com/JosephLeger/Download_SRA/blob/main/data/Example_SRR_List.csv)).  

### Environment
The workflow is encoded in Shell language and is supposed to be launched under a Linux environment.
Moreover, it was written to be used on a computing cluster using **Simple Linux Utility for Resource Management (SLURM)** Workload Manager.
All script files launch tasks as **sbatch** task submission. To successfully complete the workflow, wait for all the jobs in a step to be completed before launching the next one.
You have to install all required tools in a conda environment using provided provided [sra-tools.yaml](https://github.com/JosephLeger/Download_SRA/blob/main/sra-tools.yaml) reciept file.  

### Requirments
```
Name                     Version
sra-tools                3.1.0
```

### Syntax 
sh DL_SRA.sh <sheet_sample.csv>
