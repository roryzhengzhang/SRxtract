#!/bin/bash -ex

set -o pipefail

nj=1
cmd=/amr/bess/releases/brane/brane.current/tools-quasar/BESS/utils/run.pl

echo "$0 $@"  # Print the command line for logging

if [ -f path.sh ]; then . ./path.sh; fi
. $KALDI_UTILS/parse_options.sh || exit 1;

if [ $# != 4 ]; then
   echo "Usage: extract_sv.sh [options] <job-name> <log-dir> <source-wav-scp> <out-dir>"
   echo "options: "
   echo "  --nj <nj>                                        # number of parallel jobs"
   echo "  --cmd (run.pl|queue.pl <queue opts>)             # how to run jobs."
   exit 1;
fi

job_name=$1
log_dir=$2
wav_scp=$3
out_dir=$4

mkdir -p $log_dir
mkdir -p $out_dir

for n in $(seq $nj); do
    mkdir -p $log_dir/$job_name/$n
done

# Split the source wav.scp file
split_wav_scps=""
for n in $(seq $nj); do
    split_wav_scps="$split_wav_scps $log_dir/$job_name/$n/wav.scp"
done

$KALDI_UTILS/split_scp.pl $wav_scp $split_wav_scps

for n in $(seq $nj); do
    mkdir -p $out_dir/sv_arks/$n
done

# Extract speaker vectors
base_dir=$(dirname "$0")

. $base_dir/path.sh
. $base_dir/job_config.sh

$cmd JOB=1:$nj $log_dir/$job_name/extract_sv.JOB.log \
    bash -c "compute-mfcc-feats --config=$base_dir/conf/mfcc.conf scp:$log_dir/$job_name/JOB/wav.scp ark:- \
             | $preprocess | apply-cmvn --norm-vars $cmvn_file ark:- ark:- \
             | nnet-forward $lstm_mdl ark:- ark,t:- \
             | grep '[][]' | sed -e 'N;s/\n//g' \
             | copy-vector ark:- ark,scp,t:$out_dir/sv_arks/JOB/sv.ark,$log_dir/$job_name/JOB/sv.scp"

# Combine the sv.scp files
rm -f $out_dir/sv.scp

for n in $(seq $nj); do
    cat $log_dir/$job_name/$n/sv.scp >> $out_dir/sv.scp
done
