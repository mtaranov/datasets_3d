PROJDIR=`pwd`

pe_hindIII_wMids_file='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID_wMids.bed'
DATADIR=$PROJDIR/data

for day in d0; do
#for day in d0 ; do
for thres in 10; do
#for thres in 10; do
for contacts in pe; do
for set in test valid train; do
#for set in test; do


ContactsDIR=$PROJDIR/by_chr_dist_matched_$contacts
motifDir=$ContactsDIR/motifs
mkdir -p $motifDir

indx_file=$ContactsDIR'/'$day'_indx_'${set}'_thres_'$thres'.npy'
data_file=$ContactsDIR'/'$day'_X_'${set}'_thres_'$thres'.npy'
out_file=$motifDir/${day}_${contacts}_thres_${thres}_coor_btw_nodes_${set}'.bed'

out_prefix=$motifDir/${day}_thres_${thres}_${set}_${contacts}_out_btw_nodes

run_file=${PROJDIR}/run_by_chr_get_motifs_btw_nodes_${day}_thres_${thres}_${set}_${contacts}.sh

echo "echo $set" >>  $run_file
echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_coor_for_motifs_btw_nodes.py $indx_file $data_file $pe_hindIII_wMids_file $out_file" >> $run_file

echo "/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir $DATADIR/pwm --reference $DATADIR/hg19/hg19.genome.fa --out_prefix $out_prefix  --chrom_sizes $DATADIR/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed $out_file" >> $run_file


chmod 777 $run_file
qsub -o $PROJDIR/o.get_by_chr_motifs_btw_nodes_${day}_thres_${thres}_${set}_${contacts} -e $PROJDIR/e.run_by_chr_get_motifs_btw_nodes_${day}_thres_${thres}_${set}_${contacts} $run_file

done
done
done
done
