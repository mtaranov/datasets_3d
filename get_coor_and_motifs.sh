PROJDIR=`pwd`

pe_hindIII_wMids_file='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID_wMids.bed'
DATADIR=$PROJDIR/data

for contacts in PP_PE PE PP;
do


ContactsDIR=$PROJDIR/dist_matched_$contacts
motifDir=$ContactsDIR/motifs
mkdir -p $motifDir

for set in test valid train;
do
indx_file=$ContactsDIR'/indx_'${set}'_thres_10.npy'
data_file=$ContactsDIR'/X_'${set}'_thres_10.npy'
out_file_site1=$motifDir'/coor_site1_'${set}'.bed'
out_file_site2=$motifDir'/coor_site2_'${set}'.bed'

out_prefix1=$motifDir/${set}_${contacts}_out_node1
out_prefix2=$motifDir/${set}_${contacts}_out_node2

run_file=${PROJDIR}/run_get_motifs_$contacts.sh

echo "echo $set" >>  $run_file
echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_coor_for_motifs.py $indx_file $data_file $pe_hindIII_wMids_file $out_file_site1 $out_file_site2" >> $run_file

echo "/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir $DATADIR/pwm --reference $DATADIR/hg19/hg19.genome.fa --out_prefix $out_prefix1  --chrom_sizes $DATADIR/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed $out_file_site1" >> $run_file
echo "/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir $DATADIR/pwm --reference $DATADIR/hg19/hg19.genome.fa --out_prefix $out_prefix2  --chrom_sizes $DATADIR/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed $out_file_site2" >> $run_file

done

chmod 777 $run_file
qsub -o $PROJDIR/o.run_get_motifs_$contacts -e $PROJDIR/e.run_get_motifs_$contacts $run_file


done
