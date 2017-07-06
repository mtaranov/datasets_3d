PROJDIR=`pwd`
FeatureDir=/users/mtaranov/get_peaks
#for day in d0 d3 d6; do
for day in d0 d6; do
DAY=`echo "${day}" | tr '[a-z]' '[A-Z]'`

#for contacts in pe pp pp_pe; do
for contacts in pe; do
echo $day $contacts

if [[ $contacts == "pp" ]]; then
InteractionsFileCaptureC_zipped='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToBait_intra.bed.gz'
features_path=$FeatureDir'/peaks_at_pp/output_thres5_max/'${day}_
elif [[ $contacts == "pe" ]]; then
InteractionsFileCaptureC_zipped='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToE_intra.bed.gz'
features_path=$FeatureDir'/peaks_at_pe/output_thres5_max/'${day}_
else
InteractionsFileCaptureC_PP='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToBait_intra.bed.gz'
InteractionsFileCaptureC_PE='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToE_intra.bed.gz'
InteractionsFileCaptureC='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToBait_and_BaitToE_intra.bed'
InteractionsFileCaptureC_zipped='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/'${DAY}'_D2D8_merge_BaitToBait_and_BaitToE_intra.bed.gz'
features_path=$FeatureDir'/peaks_at_pe/output_thres5_max/'${day}_
zcat $InteractionsFileCaptureC_PP > $InteractionsFileCaptureC
zcat $InteractionsFileCaptureC_PE >> $InteractionsFileCaptureC
gzip $InteractionsFileCaptureC
fi

pe_hindIII_file='/mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID.bed'
output_dir=${PROJDIR}'/dist_matched_'${contacts}
mkdir -p $output_dir

#for thres in 10 0; do
for thres in 10; do
run_file=${PROJDIR}'/run_get_data_labels-w_indx_'$day'_'${contacts}'_'$thres'.sh'

echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_data_labels-w_indx.py $InteractionsFileCaptureC_zipped $pe_hindIII_file $output_dir $features_path $day $thres" > $run_file

chmod 777 $run_file

qsub -o $PROJDIR/o.run_get_data_labels-w_indx_$day'_'${contacts}'_'$thres -e $PROJDIR/e.run_get_data_labels-w_indx_$day'_'${contacts}'_'$thres $run_file

done
done
done

#PROJDIR=`pwd`
#for day in d0; do 
#for contacts in pe; do 
#for thres in 10; do
#run_file=${PROJDIR}'/run_get_data_labels-w_indx_'$day'_'${contacts}'_'$thres'.sh'
#
#qsub -o $PROJDIR/o.run_get_data_labels-w_indx_$day'_'${contacts}'_'$thres -e $PROJDIR/e.run_get_data_labels-w_indx_$day'_'${contacts}'_'$thres $run_file
#done
#done
#done
