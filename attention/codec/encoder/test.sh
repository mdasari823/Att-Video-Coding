if (( $# != 1 )); then
    echo "Usage: ./train.sh [0-2], e.g. ./train.sh 2"
    exit
fi
hier=$1

modeldir=model

train="../../../data/train"
eval="../../../data/eval1"
train_mv="../../../data/train_mv"
eval_mv="../../../data/eval1_mv"

if [[ ${hier} == "0" ]]; then
  distance1=6
  distance2=6
  bits=8
  encoder_fuse_level=1
  decoder_fuse_level=1
elif [[ ${hier} == "1" ]]; then
  distance1=3
  distance2=3
  bits=8
  encoder_fuse_level=1
  decoder_fuse_level=1
elif [[ ${hier} == "2" ]]; then
  distance1=1
  distance2=2
  bits=4
  encoder_fuse_level=1
  decoder_fuse_level=1
else
  echo "Usage: ./train.sh [0-2], e.g. ./train.sh 2"
  exit
fi

# Warning: with --save-out-img, output images are stored
# each time we run evaluation. This can take a lot of space
# when using a big evaluation dataset.
# (for the demo data it's okay.)


python3 -u test.py \
  --train ${train} \
  --eval ${eval} \
  --train-mv ${train_mv} \
  --eval-mv ${eval_mv} \
  --encoder-fuse-level ${encoder_fuse_level} \
  --decoder-fuse-level ${decoder_fuse_level} \
  --v-compress --warp --stack --fuse-encoder \
  --bits ${bits} \
  --distance1 ${distance1} --distance2 ${distance2} \
  --max-train-iters 100000 \
  --save-model-name "gaze_model" \
  --load-model-name "gaze_model" \
  --load-iter 100000 \
  --save-codes \
  --save-out-img
