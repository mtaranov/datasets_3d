import sys
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors
from scipy.stats.mstats import mquantiles
import scipy.stats as ss
import math
import scipy.linalg
import itertools
import copy
import random
import gzip
from sets import Set
#reload(rcca)
from sklearn.metrics import roc_auc_score, f1_score, precision_recall_curve, auc, roc_curve
from sklearn import preprocessing
from scipy.spatial.distance import pdist, squareform
import networkx as nx

from utils_data_process import printMatrix, set_diag_to_value, binarize, binarize_w_unlabeled, demean, zscore
from utils_data_process import shuffle_nodes, train_vali_test, build_distance_for_node, BuildMatrix, get_features
from utils_data_process import get_data_labels, remove_unlabeled, concatenate_chrs, get_pairs_distance_matched, impose_dist_constrains, count_nodes_and_contacts

InteractionsFileCaptureC=sys.argv[1]
hindIII_file=sys.argv[2]
output_dir=sys.argv[3]
features_path=sys.argv[4]
day=sys.argv[5]
thres=sys.argv[6]
#atac
atac=features_path+'atac'
#TFs
ctcf=features_path+'CTCF'
pol3=features_path+'PolII'
TP63=features_path+'TP63'
LSD1=features_path+'LSD1'
#histone
H3K27ac=features_path+'H3K27ac'
H3K27me3=features_path+'H3K27me3'
H3K4me1=features_path+'H3K4me1'
H3K4me3=features_path+'H3K4me3'
H3K9ac=features_path+'H3K9ac'

labels_score = BuildMatrix(hindIII_file, InteractionsFileCaptureC)

VectorATAC=get_features(hindIII_file, atac, 'atac')

VectorCTCF=get_features(hindIII_file, ctcf, 'ctcf')
VectorPOL3=get_features(hindIII_file, pol3, 'pol3')
VectorTP63=get_features(hindIII_file, TP63, 'TP63')
#VectorLSD1=get_features(hindIII_file, LSD1, 'LSD1') # not available for d6

VectorH3K27ac=get_features(hindIII_file, H3K27ac, 'H3K27ac')
VectorH3K27me3=get_features(hindIII_file, H3K27me3, 'H3K27me3')
VectorH3K4me1=get_features(hindIII_file, H3K4me1, 'H3K4me1')
VectorH3K4me3=get_features(hindIII_file, H3K4me3, 'H3K4me3')
VectorH3K9ac=get_features(hindIII_file, H3K9ac, 'H3K9ac')


distance_for_node = build_distance_for_node(hindIII_file)

FeatureVector_wo_dist = {}
FeatureVector = {}
for chr in VectorATAC:
    if chr != 'chrY':
        #FeatureVector_wo_dist[chr] = demean(np.vstack((VectorATAC[chr], VectorCTCF[chr], VectorPOL3[chr], VectorTP63[chr], VectorLSD1[chr], VectorH3K27ac[chr], VectorH3K27me3[chr], VectorH3K4me1[chr], VectorH3K4me3[chr], VectorH3K9ac[chr])).T) # LSD1 is not available for d6
        FeatureVector_wo_dist[chr] = demean(np.vstack((VectorATAC[chr], VectorCTCF[chr], VectorPOL3[chr], VectorTP63[chr], VectorH3K27ac[chr], VectorH3K27me3[chr], VectorH3K4me1[chr], VectorH3K4me3[chr], VectorH3K9ac[chr])).T)
        FeatureVector[chr] = np.concatenate((FeatureVector_wo_dist[chr], distance_for_node[chr]), axis=1)

data, labels, indx  = get_data_labels(FeatureVector, labels_score)
data_all_chrs, labels_all_chrs, indx_all_chr = concatenate_chrs(data, labels, indx)
data_all_wo_unlbd_at_thres, labels_all_wo_unlbd_at_thres, indx_all_wo_unlbd_at_thres = remove_unlabeled(data_all_chrs, binarize_w_unlabeled(labels_all_chrs, int(thres)), indx_all_chr)
train_set_thres, vali_set_thres, test_set_thres, labels_train_thres, labels_vali_thres, labels_test_thres, indx_train_thres, indx_vali_thres, indx_test_thres =train_vali_test(data_all_wo_unlbd_at_thres, labels_all_wo_unlbd_at_thres, indx_all_wo_unlbd_at_thres, 0.5, 0.3)

min_dist=10000
max_dist=2000000
dist_step=10000
class_imbalance=1
X_test_distance_matched_at_thres, y_test_distance_matched_at_thres, indx_test_distance_matched_at_thres = get_pairs_distance_matched(test_set_thres, labels_test_thres, indx_test_thres, min_dist, max_dist, dist_step, class_imbalance)
X_train_distance_matched_at_thres, y_train_distance_matched_at_thres, indx_train_distance_matched_at_thres = get_pairs_distance_matched(train_set_thres, labels_train_thres, indx_train_thres, min_dist, max_dist, dist_step, class_imbalance)
X_valid_distance_matched_at_thres, y_valid_distance_matched_at_thres, indx_valid_distance_matched_at_thres = get_pairs_distance_matched(vali_set_thres, labels_vali_thres, indx_vali_thres, min_dist, max_dist, dist_step, class_imbalance)


print "in all chrs:"
y_at_thres=np.concatenate((y_train_distance_matched_at_thres, y_valid_distance_matched_at_thres, y_test_distance_matched_at_thres), axis=0)
print "pos at thres="+thres+": ", np.where(y_at_thres > 0)[0].shape[0], " | train: ", np.where(y_train_distance_matched_at_thres > 0)[0].shape[0], "vali:",np.where(y_valid_distance_matched_at_thres > 0)[0].shape[0], "test:",np.where(y_test_distance_matched_at_thres > 0)[0].shape[0] 
print "neg at thres="+thres+": ", np.where(y_at_thres == 0)[0].shape[0], " | train: ", np.where(y_train_distance_matched_at_thres == 0)[0].shape[0], "vali:",np.where(y_valid_distance_matched_at_thres == 0)[0].shape[0], "test:",np.where(y_test_distance_matched_at_thres == 0)[0].shape[0]
print "total: ", y_at_thres.shape[0]

count_nodes_and_contacts(indx_train_distance_matched_at_thres, indx_valid_distance_matched_at_thres, indx_test_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_X_train_thres_'+thres+'.npy', X_train_distance_matched_at_thres) 
np.save(output_dir+'/'+day+'_X_valid_thres_'+thres+'.npy', X_valid_distance_matched_at_thres) 
np.save(output_dir+'/'+day+'_X_test_thres_'+thres+'.npy', X_test_distance_matched_at_thres) 
np.save(output_dir+'/'+day+'_y_train_thres_'+thres+'.npy', y_train_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_y_valid_thres_'+thres+'.npy', y_valid_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_y_test_thres_'+thres+'.npy', y_test_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_indx_train_thres_'+thres+'.npy', indx_train_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_indx_valid_thres_'+thres+'.npy', indx_valid_distance_matched_at_thres)
np.save(output_dir+'/'+day+'_indx_test_thres_'+thres+'.npy', indx_test_distance_matched_at_thres)
