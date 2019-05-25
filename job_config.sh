#!/bin/bash

lstm_mdl=/amr/projects/General/emarchi/spkvector/model/8555_kaldi.8bit.nnet

cmvn_file=/amr/projects/General/emarchi/spkvector/model/global-cmvn-stat_pre-0.5s_post-0.0s.bin

preprocess="apply-cmvn-sliding --cmn-window=1000 --min-cmn-window=1000 ark:- ark:- "
