echo train
/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/datasets_3d/get_coor_for_motifs_at_nodes.py /users/mtaranov/datasets_3d/dist_matched_pe/d0_indx_train_thres_0.npy /users/mtaranov/datasets_3d/dist_matched_pe/d0_X_train_thres_0.npy /mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID_wMids.bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_pe_thres_0_coor_node1_train.bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_pe_thres_0_coor_node2_train.bed
/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir /users/mtaranov/datasets_3d/data/pwm --reference /users/mtaranov/datasets_3d/data/hg19/hg19.genome.fa --out_prefix /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_thres_0_train_pe_out_node1  --chrom_sizes /users/mtaranov/datasets_3d/data/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_pe_thres_0_coor_node1_train.bed
/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir /users/mtaranov/datasets_3d/data/pwm --reference /users/mtaranov/datasets_3d/data/hg19/hg19.genome.fa --out_prefix /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_thres_0_train_pe_out_node2  --chrom_sizes /users/mtaranov/datasets_3d/data/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d0_pe_thres_0_coor_node2_train.bed
