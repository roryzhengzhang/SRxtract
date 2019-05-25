#!/bin/bash

#wav_path=gpfs/static/tts/users/qhu2/projects/neural_data/VCTK/submit/wavenet/unseen/wavs/
#out_scp=test.scp

wav_path=$1
out_scp=$2

find ${wav_path} -name "*.wav" | awk 'function basename(file) {sub(".*/", "", file); sub(".wav", "", file); return file} {print basename($1), $1}' > ${out_scp}
