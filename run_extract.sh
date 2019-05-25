
#sh run_extract.sh erik_p255.scp

scps=$1

for scp in $scps; do
  tag=$(basename "$scp" .scp)
  echo "Extracting speaker embeddings from $tag"
  sh extract_sv.sh $tag log_$tag  $tag.scp output/$tag
done


