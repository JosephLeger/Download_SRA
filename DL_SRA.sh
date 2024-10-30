#!/bin/env bash

################################################################################################################
### HELP -------------------------------------------------------------------------------------------------------
################################################################################################################
script_name='DL_SRA.sh'

# Get user id for custom manual pathways
usr=`id | sed -e 's@).*@@g' | sed -e 's@.*(@@g'`

# Text font variabes
END='\033[0m'
BOLD='\033[1m'
UDL='\033[4m'

# Show command manual
Help()
{
echo -e "${BOLD}####### DL_SRA MANUAL #######${END}\n\n\
${BOLD}SYNTHAX${END}\n\
	sh DL_SRA.sh <sheet_sample.csv>\n\n\

${BOLD}DESCRIPTION${END}\n\
	Download SRA files from a provided sample information list.\n\n\
    
${BOLD}ARGUMENTS${END}\n\
	${BOLD}<sheet_sample.csv>${END}\n\
		Path to .csv sample information sheet.\n\
		Provided sheet must be structured in 2 columns : \n\
				1)SRR_ID to download\n\
				2)Filename\n\n\

${BOLD}EXAMPLE USAGE${END}\n\
	sh ${script_name} ${BOLD}./SRR_List.csv${END}\n"
}

################################################################################################################
### ERRORS -----------------------------------------------------------------------------------------------------
################################################################################################################

# Check presence of .csv file in provided directory
files=$(shopt -s nullglob dotglob; echo $1)

if [ $# -eq 1 ] && [ $1 == "help" ]; then
        Help
        exit
elif [ $# -ne 1 ]; then
		# Error if no CSV file is provided
		echo 'Error synthax : please use following synthax'
		echo '      sh DL_SRA.sh <sheet_sample.csv>'
		exit
elif [ $(ls $1 2>/dev/null | wc -l) -lt 1 ]; then
		# Error if provided CSV file does not exists
		echo 'Error : can not find files in provided directory. Please make sure the provided directory exists, and contains .fastq.gz or .fq.gz files.'
		exit
fi

################################################################################################################
### SCRIPT -----------------------------------------------------------------------------------------------------
################################################################################################################

## SETUP - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module load sra-tools/3.1.0

# Generate REPORT
echo '#' >> ./0K_REPORT.txt
date >> ./0K_REPORT.txt

Launch()
{
# Launch COMMAND and save report
echo -e "#$ -V \n#$ -cwd \n#$ -S /bin/bash \n"${COMMAND} | qsub -N ${JOBNAME} ${WAIT}
echo -e ${JOBNAME} >> ./0K_REPORT.txt
echo -e ${COMMAND} |  sed 's@^@   \| @' >> ./0K_REPORT.txt
}
WAIT=''

## DOWNLOAD SRA - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create outpur directory
outdir=Raw
mkdir -p ${outdir}

cat $1 | while IFS=',' read -r sra filename; do
	sra=$(echo $sra | tr -d '\r')
	filename=$(echo $filename | tr -d '\r')

	JOBNAME="DL_${sra}"
	
	COMMAND="fasterq-dump --split-files ${sra} --outdir ${outdir} \n\
	\n\
	nfiles=\`find ${outdir} \( -name "${sra}*.fastq" \) | wc -l\` \n\
	if [ \${nfiles} == 2 ] && [ -f ${outdir}/${sra}_1.fastq ] && [ -f ${outdir}/${sra}_2.fastq ]; then \n\
		echo 'Paired-End detected' \n\
		mv -v "${outdir}"/"${sra}"_1.fastq "${outdir}"/"${filename}"_R1.fastq \n\
		mv -v "${outdir}"/"${sra}"_2.fastq "${outdir}"/"${filename}"_R2.fastq \n\
		gzip -r ${outdir}/${filename}_R1.fastq \n\
		gzip -r ${outdir}/${filename}_R2.fastq \n\
	else \n\
		echo 'Single-End detected' \n\
		sra_match=\`find ${outdir} \( -name "${sra}*.fastq" \)\` \n\
		for f in \${sra_match}; do \n\
			f_renamed=\`echo \${f} | sed -e "s@${sra}@${filename}@g" \` \n\
			mv -v \${f} \${f_renamed} \n\
			gzip -r \${f_renamed} \n\
		done \n\
	fi"
	Launch
	
	# If SRR*.fastq match exaclty two files that are named SRRXXX_1.fastq and SRRXXX_2.fastq then consider them as paired-end
	# Gzipped files will be so renamed with '_R1|R2.fastq.gz' suffix
	# Otherwise, it will rename and gzip all matching files considering them as single-end

done
	
