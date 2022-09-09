#! /usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --time=12:00:00
#SBATCH --constraint=cal
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out
source ~soft_bio_267/initializes/init_fln_dev

export BLASTDB=$SCRATCH/fln/databases/

cd $BLASTDB
current=`pwd`

existenSymlinks=$(find ./ -type l -ls)

if [ -z "$existenSymlinks" ]
then
ln -s ~blast_db/20220406/trembl/uniprot_trembl_mammals.dat.gz uniprot_trembl_mammals.dat.gz
ln -s ~blast_db/20220406/trembl/uniprot_trembl_vertebrates.dat.gz uniprot_trembl_vertebrates.dat.gz
ln -s ~blast_db/20220406/trembl/uniprot_trembl_invertebrates.dat.gz uniprot_trembl_invertebrates.dat.gz
ln -s ~blast_db/20220406/trembl/uniprot_trembl_plants.dat.gz uniprot_trembl_plants.dat.gz

ln -s ~blast_db/20220406/sprot/uniprot_sprot_mammals.dat.gz uniprot_sprot_mammals.dat.gz
ln -s ~blast_db/20220406/sprot/uniprot_sprot_vertebrates.dat.gz uniprot_sprot_vertebrates.dat.gz
ln -s ~blast_db/20220406/sprot/uniprot_sprot_invertebrates.dat.gz uniprot_sprot_invertebrates.dat.gz
ln -s ~blast_db/20220406/sprot/uniprot_sprot_plants.dat.gz uniprot_sprot_plants.dat.gz
ln -s ~blast_db/20220406/sprot/uniprot_sprot_varsplic.fasta.gz uniprot_sprot_varsplic.fasta.gz
fi

cd $current

download_fln_dbs.rb -u 'mammals,vertebrates,invertebrates,plants' -d -n

make_user_db.rb -u plants -t 'Brassicaceae'
make_user_db.rb -u invertebrates -t 'Diptera'
make_user_db.rb -u vertebrates -t 'Galliformes'
make_user_db.rb -u vertebrates -t 'Actinopterygii'
make_user_db.rb -u mammals -t 'Laurasiatheria'
