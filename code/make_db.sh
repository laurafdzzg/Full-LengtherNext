#! /usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --time=12:00:00
#SBATCH --constraint=cal
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
source ~soft_bio_267/initializes/init_fln_dev

BLASTDB=$SCRATCH/fln/databases/

mkdir $BLASTDB
cd $BLASTDB
# Cambiar lo siguiente a simbolicos por cada uno delos archivos dat en las carpetas sprot y trembl. Los .dat deben estar en $SCRATCH/fln/databases/
ln -s ~blast_db/20220406/trembl/uniprot_trembl_plants.dat.gz
#ln -s ~blast_db/20220406/sprot
#ln -s ~blast_db/20220406/trembl

download_fln_dbs.rb -u 'mammals,vertebrates,invertebrates,plants' -d -n
make_user_db.rb -u plants -t 'Brassicaceae'
#~pedro/dev_gems/full_dev/bin/make_user_db.rb -u invertebrates -t 'Diptera'
#~pedro/dev_gems/full_dev/bin/make_user_db.rb -u vertebrates -t 'Galliformes'
#~pedro/dev_gems/full_dev/bin/make_user_db.rb -u vertebrates -t 'Actinopterygii'
#~pedro/dev_gems/full_dev/bin/make_user_db.rb -u mammals -t 'Laurasiatheria'
