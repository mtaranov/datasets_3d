import numpy as np
import sys

indx_file=sys.argv[1]
data_file=sys.argv[2]
pe_hindIII_wMids_file=sys.argv[3]
out_file=sys.argv[4]

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
f_num=X.shape[1]-1
mids1=X[:,f_num,0].reshape((X.shape[0], 1))
mids2=X[:,f_num,1].reshape((X.shape[0], 1))
indx_new=indx[:,2].reshape((indx.shape[0], 1))

mids12=np.concatenate((mids1,mids2), axis=1)
indx_mids=np.concatenate((indx_new,mids12), axis=1)
print "writing site ..."
for i in indx_mids:
    if i[0]==float(23):
        chr="chrX"
    else:
        chr="chr"+str(int(i[0]))
    with open(out_file, 'a') as f1:
        f1.write(chr+'\t'+str(int(REFrag_dict[(chr,str(int(i[1])))][1])+1)+'\t'+str(int(REFrag_dict[(chr,str(int(i[2])))][0])-1)+'\n')

