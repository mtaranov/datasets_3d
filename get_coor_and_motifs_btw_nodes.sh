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
out_file=$motifDir/${contacts}_coor_btw_nodes_${set}'.bed'

out_prefix=$motifDir/${set}_${contacts}_out_btw_nodes

run_file=${PROJDIR}/run_get_motifs_btw_nodes_$contacts.sh

echo "echo $set" >>  $run_file
echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_coor_for_motifs_btw_nodes.py $indx_file $data_file $pe_hindIII_wMids_file $out_file" >> $run_file

echo "/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir $DATADIR/pwm --reference $DATADIR/hg19/hg19.genome.fa --out_prefix $out_prefix  --chrom_sizes $DATADIR/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed $out_file" >> $run_file

done

chmod 777 $run_file
qsub -o $PROJDIR/o.run_get_motifs_btw_nodes_$contacts -e $PROJDIR/e.run_get_motifs_btw_nodes_$contacts $run_file


done
