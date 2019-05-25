#!/bin/bash

# General Settings
export LC_ALL=C

# Executable path
EXPT=`pwd`
OUTPUT=$EXPT/output
LOGS=$EXPT/logs
CKPTS=$EXPT/ckpts
LOCAL_SCRIPTS=$EXPT/scripts
LOCAL_BIN=$EXPT/bin
DATA=$EXPT/data
export CONF=$EXPT/conf

#export KALDI_ROOT=/amr/bess/releases/brane/brane.current/libquasar/libkaldi/
#export KALDI_STEPS=/amr/bess/releases/brane/brane.current/tools-quasar/BESS/steps
export KALDI_UTILS=/amr/bess/releases/brane/brane.current/tools-quasar/BESS/utils

#export PATH=$KALDI_UTILS:$KALDI_ROOT/src/bin:$KALDI_ROOT/tools/openfst/src/bin:$KALDI_ROOT/src/fstbin/:$KALDI_ROOT/src/gmmbin/:$KALDI_ROOT/src/featbin/:$KALDI_ROOT/src/lm/:$KALDI_ROOT/src/sgmmbin/:$KALDI_ROOT/src/sgmm2bin/:$KALDI_ROOT/src/fgmmbin/:$KALDI_ROOT/src/latbin/:$KALDI_ROOT/src/nnetbin:$KALDI_ROOT/src/nnet-cpubin/:$KALDI_ROOT/src/kwsbin:$SRIBIN:$KALDI_ROOT/src/ivectorbin/:$PATH

#this sets almost all we need
source /amr/users/emarchi/src/spkverid_kit/helpers/pyT_env.sh

# add logistic regression to the path as well!
#export PATH=$PATH:/amr/users/stephen_shum/src/brane/build-logistic-regression/libquasar/libkaldi/src/ivectorbin


# CUDA 7.5
#export PATH=/usr/local/cuda-7.5/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-7.5/lib64:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/local/lib64/cudnn-4.0/:$LD_LIBRARY_PATH

# CUDA 8.0
export PATH=/usr/local/cuda-8.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib64/cudnn-8.0-6.0.20/:$LD_LIBRARY_PATH
