PROJDIR=`pwd`

InteractionsFileCaptureC_PP='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/D0_D2D8_merge_BaitToBait_intra.bed.gz'
InteractionsFileCaptureC_PE='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/D0_D2D8_merge_BaitToE_intra.bed.gz'
InteractionsFileCaptureC='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/D0_D2D8_merge_BaitToBait_and_BaitToE_intra.bed'
InteractionsFileCaptureC_zipped='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/D0_D2D8_merge_BaitToBait_and_BaitToE_intra.bed.gz'

zcat $InteractionsFileCaptureC_PP > $InteractionsFileCaptureC
zcat $InteractionsFileCaptureC_PE >> $InteractionsFileCaptureC
gzip $InteractionsFileCaptureC

pe_hindIII_file='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID.bed'
features_path='/mnt/lab_data/kundaje/mtaranov/peaks_at_pe/output_thres5_max/'

output_dir=${PROJDIR}'/dist_matched_PP_PE'
mkdir -p $output_dir

run_file=${PROJDIR}'/run_get_data_labels-w_indx_PP_PE.sh'

echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_data_labels-w_indx.py $InteractionsFileCaptureC_zipped $pe_hindIII_file $output_dir $features_path" > $run_file

chmod 777 $run_file

qsub -o $PROJDIR/o.run_get_data_labels-w_indx_PP_PE -e $PROJDIR/e.run_get_data_labels-w_indx_PP_PE $run_file
