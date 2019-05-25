#wav_path=/gpfs/static/tts/users/qhu2/corpus/p255/ori/erik_p225/
#out_path=./erik_p255/
wav_path=$1
out_path=$2

for i in $wav_path/*.wav
do
  sox $i -r 16000 -c 1 -b 16 $out_path/$(basename $i)
done