PROJDIR=`pwd`

InteractionsFileCaptureC_zipped='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/D0_D2D8_merge_BaitToE_intra.bed.gz'

pe_hindIII_file='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID.bed'
features_path='/mnt/lab_data/kundaje/mtaranov/peaks_at_pe/output_thres5_max/'

output_dir=${PROJDIR}'/dist_matched_PE'
mkdir -p $output_dir

run_file=${PROJDIR}'/run_get_data_labels-w_indx_PE.sh'

echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_data_labels-w_indx.py $InteractionsFileCaptureC_zipped $pe_hindIII_file $output_dir $features_path" > $run_file

chmod 777 $run_file

qsub -o $PROJDIR/o.run_get_data_labels-w_indx_PE -e $PROJDIR/e.run_get_data_labels-w_indx_PE $run_file
