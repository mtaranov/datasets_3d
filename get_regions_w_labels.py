import sys
import numpy as np

w=int(sys.argv[1])
DATAJDIR=sys.argv[2]
OUTDIR=sys.argv[3]

y_train=np.load(DATAJDIR+'/y_train_thres_10.npy')
y_valid=np.load(DATAJDIR+'/y_valid_thres_10.npy')
y_test=np.load(DATAJDIR+'/y_test_thres_10.npy')
X_train=np.load(DATAJDIR+'/X_train_thres_10.npy')
X_valid=np.load(DATAJDIR+'/X_valid_thres_10.npy')
X_test=np.load(DATAJDIR+'/X_test_thres_10.npy')
indx_train=np.load(DATAJDIR+'/indx_train_thres_10.npy')
indx_valid=np.load(DATAJDIR+'/indx_valid_thres_10.npy')
indx_test=np.load(DATAJDIR+'/indx_test_thres_10.npy')

y_train=np.concatenate((y_train, y_valid), axis=0)
X_train=np.concatenate((X_train, X_valid), axis=0)
indx_train=np.concatenate((indx_train, indx_valid), axis=0)


site1_train=(np.vstack((indx_train[:,2].astype(int), X_train[:, 10, 0]-w/2, X_train[:, 10, 0]+w/2)).astype(int).astype(str)).T
site2_train=(np.vstack((indx_train[:,2].astype(int), X_train[:, 10, 1]-w/2, X_train[:, 10, 1]+w/2)).astype(int).astype(str)).T
site1_test=(np.vstack((indx_test[:,2].astype(int), X_test[:, 10, 0]-w/2, X_test[:, 10, 0]+w/2)).astype(int).astype(str)).T
site2_test=(np.vstack((indx_test[:,2].astype(int), X_test[:, 10, 1]-w/2, X_test[:, 10, 1]+w/2)).astype(int).astype(str)).T

for site in [site1_train, site2_train, site1_test, site2_test]:
    for i in range(site.shape[0]):
        if site[i,0]=='23':
            site[i,0]='chrX'
        else:
            site[i,0]='chr'+site[i,0]

np.savetxt(OUTDIR+'/site1_train_dist_matched_'+str(w/1000)+'kb_thres10.bed', site1_train, delimiter="\t", fmt="%s")
np.savetxt(OUTDIR+'/site1_test_dist_matched_'+str(w/1000)+'kb_thres10.bed', site1_test, delimiter="\t", fmt="%s")
np.savetxt(OUTDIR+'/site2_train_dist_matched_'+str(w/1000)+'kb_thres10.bed', site2_train, delimiter="\t", fmt="%s")
np.savetxt(OUTDIR+'/site2_test_dist_matched_'+str(w/1000)+'kb_thres10.bed', site2_test, delimiter="\t", fmt="%s") 

np.save(OUTDIR+'/labels_train_dist_matched_thres10.npy', y_train)
np.save(OUTDIR+'/labels_test_dist_matched_thres10.npy', y_test) 
