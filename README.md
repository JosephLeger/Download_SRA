# Download_SRA
### Description
Short script used to download and rename properly SRA files from Accession List.  
It requires a comma-delimited table containing SRR numbers in the first column, and desired corresponding filename in the second column (See [Example_SRR_List.csv](https://github.com/JosephLeger/Download_SRA/blob/main/data/Example_SRR_List.csv)).  

### Requirments
```
Name                     Version
sra-tools                2.11.0
```
*Note : sra-tools is loaded as an installed module in the provided script. If you use a custom environment you need to change it in the SETUP section of DL_SRA.sh*

### Syntax 
sh DL_SRA.sh <sheet_sample.csv>
