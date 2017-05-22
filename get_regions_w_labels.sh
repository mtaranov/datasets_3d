PROJDIR=`pwd`

w=1000
OUTDIR=$DATAJDIR/regions
mkdir -p $OUTDIR

for contacts in PP_PE PE PP;
do

DATAJDIR=$PROJDIR/dist_matched_$contacts
run_file=${PROJDIR}/run_get_regions_$contacts.sh

echo "/users/mtaranov/local/anaconda2/bin/python $PROJDIR/get_regions_w_labels.py $w $DATAJDIR $OUTDIR" > $run_file
chmod 777 $run_file
qsub -o $PROJDIR/o.run_get_regions_$contacts -e $PROJDIR/e.run_get_regions_$contacts $run_file

done
