#!/usr/bin/env python3
​
# Usage: can handle a directory with a bunch of .wav files in the correct format
# producing a SV for each
​
import argparse
import subprocess
import os
import tempfile
import json
​
## ASSUMPTIONS: 16kHz, 16bit input 1 channel, ffmpeg available
## Do this prep in the breeze module
#     ffmpeg -i input_file -ac 1 -ar 16000   # assume 16bit
​
class SRxtract(object):
    def __init__(self, srx_dir, kaldi_dir, log_dir):
​
        # The model info
        self.lstm_mdl = f'{srx_dir}/model/8555_kaldi.8bit.nnet'
        self.cmvn_file = f'{srx_dir}/model/global-cmvn-stat_pre-0.5s_post-0.0s.bin'
        self.conf = f'{srx_dir}/conf/mfcc.conf'
        self.kaldi_dir = kaldi_dir
        self.log_dir = log_dir
        self.KALDI = self.kaldi_dir
        self.FEATBIN = self.KALDI + "/src/featbin/"
        self.NNETBIN   = self.KALDI + "/src/nnetbin/"
        self.BIN = self.KALDI + "/src/bin/"
​
​
    def run(self, wavfile):
        '''Takes a wav file and produces a vector, basically'''
​
        wavfileshort = os.path.split(wavfile)[-1]
        # wav.scp is implied right now
        # this is a bit wacky, towards the end. It takes the first and last lines and essentially concatenates them. That's all.
        # Making a bit of a hash of logging
        os.makedirs(self.log_dir, exist_ok=True)
        tmptxt1 = tempfile.NamedTemporaryFile(delete=False).name
        with open(tmptxt1, 'w') as wfd:
            wfd.write(f'test1 {wavfile}\n')
        cmd = f'{self.FEATBIN}/compute-mfcc-feats --config={self.conf} scp:{tmptxt1} ark:- |' + \
            f'{self.FEATBIN}/apply-cmvn-sliding --cmn-window=1000 --min-cmn-window=1000 ark:- ark:- |' + \
            f'{self.FEATBIN}/apply-cmvn --norm-vars {self.cmvn_file} ark:- ark:- |' + \
            f'{self.NNETBIN}/nnet-forward {self.lstm_mdl} ark:- ark,t:-' + \
            f' 2>{self.log_dir}/{wavfileshort}.log'
​
        alldata = subprocess.check_output(cmd, shell=True)
​
        alldatalines = alldata.decode().split('\n')
        vec = alldatalines[-2]
        vector = vec.split()[:-1]
        vector = [float(el) for el in vector]
​
        os.unlink(tmptxt1)
        return vector
​

# Combine the sv.scp files
# $out_dir/sv.scp
​
if __name__ ==  '__main__':
​
    parser = argparse.ArgumentParser(description='Make speaker vectors')
    parser.add_argument('-i', '--input', help='input wav file', required=True)
    parser.add_argument('-l', '--log', help='log dir', required=True)
    parser.add_argument('-o', '--output', help='output file', required=True)
    parser.add_argument('-s', '--srx_dir', help='sr extract directory', default='/Users/test/Documents/GitHub/SRxtract')                 ### Make sure it's the right branch!!
    parser.add_argument('-k', '--kaldi_dir', help='kaldi directory', default='/home/adc/git/brane/libquasar/libkaldi')
    args = parser.parse_args()
​
    # try to make input either a file or a scp or a directory and process accordingly
​
    srx = SRxtract('.', args.kaldi_dir, 'log')
    #    vec = srx.run('1445087749.1003550.1530.wav')
    #    print(vec)
​
    with open(args.output, 'w') as outfd:
​
        inp = args.input
        if os.path.isdir(inp):
            files = os.listdir(inp)
            for f in files:
                fullf = os.path.join(inp, f)
                vector = srx.run(fullf)
                outfd.write(json.dumps({fullf: vector}))
​
        elif os.path.isfile(args.input):
            vector = srx.run(args.input)
            outfd.write(json.dumps({inp: vector}))