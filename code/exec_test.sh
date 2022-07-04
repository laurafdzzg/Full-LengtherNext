#! /usr/bin/env bash


export BLASTDB=$SCRATCH/fln/databases
# Download DBs
if [ "$1" == "database" ]; then
	if [ ! -d "$BLASTDB" ]; then
	mkdir $BLASTDB
	fi
	sbatch make_db.sh
fi

# Download unigenes
export UNIGEN_FOLDER=$SCRATCH/fln/raw_sequences
if [ "$1" == "unigen" ]; then
	if [ ! -d "$UNIGEN_FOLDER" ]; then
	mkdir $UNIGEN_FOLDER
	fi
	wget -q ftp://ftp.ncbi.nlm.nih.gov/repository/UniGene/Drosophila_melanogaster/Dm.seq.all.gz -O $UNIGEN_FOLDER/Dm.seq.all.gz
	wget -q ftp://ftp.ncbi.nlm.nih.gov/repository/UniGene/Gallus_gallus/Gga.seq.all.gz -O $UNIGEN_FOLDER/Gga.seq.all.gz
	wget -q ftp://ftp.ncbi.nlm.nih.gov/repository/UniGene/Arabidopsis_thaliana/At.seq.all.gz -O $UNIGEN_FOLDER/At.seq.all.gz
	wget -q ftp://ftp.ncbi.nlm.nih.gov/repository/UniGene/Sus_scrofa/Ssc.seq.all.gz -O $UNIGEN_FOLDER/Ssc.seq.all.gz
	gunzip -d $UNIGEN_FOLDER/*.gz
	sed 's, [^ ]*,,g' $UNIGEN_FOLDER/At.seq.all |sed 's/#//g'|sed 's/gnl|UG|//g'| tr [:lower:] [:upper:] > $UNIGEN_FOLDER/Arabidopsis_thaliana_cln.fasta
	sed 's, [^ ]*,,g' $UNIGEN_FOLDER/Dm.seq.all |sed 's/#//g'|sed 's/gnl|UG|//g'| tr [:lower:] [:upper:] > $UNIGEN_FOLDER/Drosophila_melanogaster_cln.fasta
	sed 's, [^ ]*,,g' $UNIGEN_FOLDER/Gga.seq.all |sed 's/#//g'|sed 's/gnl|UG|//g'| tr [:lower:] [:upper:] > $UNIGEN_FOLDER/Gallus_gallus_cln.fasta
	sed 's, [^ ]*,,g' $UNIGEN_FOLDER/Ssc.seq.all |sed 's/#//g'|sed 's/gnl|UG|//g'| tr [:lower:] [:upper:] > $UNIGEN_FOLDER/Sus_scrofa_cln.fasta
	rm $UNIGEN_FOLDER/*.seq.all
fi


export FULL_LENGTH_FOLDER=$SCRATCH/fln/seqs_full_length
if [ "$1" == "get_sequences" ]; then
	if [ ! -d "$FULL_LENGTH_FOLDER" ]; then
        mkdir $FULL_LENGTH_FOLDER
	fi
	# Select full length sequences
	source ~soft_bio_267/initializes/init_autoflow
	AutoFlow -w template/tests_template -s -c 10  -o $FULL_LENGTH_FOLDER -m 40gb 
fi



export TEST_FOLDER=$SCRATCH/fln/testingR
# Check full-length module
if [ "$1" == "test" ]; then
       if [ ! -d "$TEST_FOLDER" ]; then
       mkdir $TEST_FOLDER
       fi
       source ~soft_bio_267/initializes/init_autoflow
       AutoFlow -w template/check_fl_analysis_module_template -n 'cal' -c 16 -s -u 1 -o $TEST_FOLDER/fl_analisys -V '$FASTAS='$FULL_LENGTH_FOLDER'/mv_0000,$DB='$BLASTDB',$RES =../../results' -m 40gb -t '2-00:00:00'

fi

#Check USER-DB
#export REAL_TRANSCRIPTOME=transcriptome
#mkdir $REAL_TRANSCRIPTOME
#wget -q http://www.juntadeandalucia.es/agriculturaypesca/ifapa/soleadb_ifapa/assemblies/download_unigenes/42 -O $REAL_TRANSCRIPTOME/solea_v4.0_unigenes.fasta
 
# Check chimeras module
#AutoFlow -w check_chimeras_module_template -n 'cal' -c 16 -o $TEST_FOLDER/chimeras -V '$FASTAS=~/fln/def_test/'$TEST_FOLDER'/fl_analisys/make_test_dataset.rb_0000,$DB='$BLASTDB',$INIT_FILE=~pedro/fln/def_test/init'

