echo valid
/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/datasets_3d/get_coor_for_motifs_btw_nodes.py /users/mtaranov/datasets_3d/dist_matched_pe/d6_indx_valid_thres_0.npy /users/mtaranov/datasets_3d/dist_matched_pe/d6_X_valid_thres_0.npy /mnt/lab_data/kundaje/mtaranov/ChicagoCalls/PE_Digest_Human_HindIII_ID_wMids.bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d6_pe_thres_0_coor_btw_nodes_valid.bed
/users/mtaranov/local/anaconda2/bin/python /users/mtaranov/sequence_to_motif/scan_motifs.py --pwm_dir /users/mtaranov/datasets_3d/data/pwm --reference /users/mtaranov/datasets_3d/data/hg19/hg19.genome.fa --out_prefix /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d6_thres_0_valid_pe_out_btw_nodes  --chrom_sizes /users/mtaranov/datasets_3d/data/hg19/hg19.chrom.sizes  --num_hits_per_motif 3 --p_val 0.0001 --positions_bed /users/mtaranov/datasets_3d/dist_matched_pe/motifs/d6_pe_thres_0_coor_btw_nodes_valid.bed
