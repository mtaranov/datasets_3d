import numpy as np
import sys

indx_file=sys.argv[1]
data_file=sys.argv[2]
pe_hindIII_wMids_file=sys.argv[3]
out_file_site1=sys.argv[4]
out_file_site2=sys.argv[5]

REFrag_dict={}
for line in open(pe_hindIII_wMids_file,'r'):
    words=line.rstrip().split()
    chr=words[0]
    mid=words[5]
    start=words[1]
    end=words[2]
    if (chr,mid) in REFrag_dict:
        print (chr,mid)
    REFrag_dict[(chr,mid)]=(start,end)

X=np.load(data_file)
indx=np.load(indx_file)
mids1=X[:,10,0].reshape((X.shape[0], 1))
mids2=X[:,10,1].reshape((X.shape[0], 1))
indx_new=indx[:,2].reshape((indx.shape[0], 1))

indx_mids1=np.concatenate((indx_new,mids1), axis=1)
print "writing site1 ..."
for i in indx_mids1:
    if i[0]==float(23):
        chr="chrX"
    else:
        chr="chr"+str(int(i[0]))
    with open(out_file_site1, 'a') as f1:
        f1.write(chr+'\t'+REFrag_dict[(chr,str(int(i[1])))][0]+'\t'+REFrag_dict[(chr,str(int(i[1])))][1]+'\n')


indx_mids2=np.concatenate((indx_new,mids2), axis=1)
print "writing site2 ..."
for i in indx_mids2:
    if i[0]==float(23):
        chr="chrX"
    else:
        chr="chr"+str(int(i[0]))
    with open(out_file_site2, 'a') as f2:
        f2.write(chr+'\t'+REFrag_dict[(chr,str(int(i[1])))][0]+'\t'+REFrag_dict[(chr,str(int(i[1])))][1]+'\n')



     
