#!/bin/bash

set -eu


if [ $# -lt 1 ]; then
  echo "Usage: $0 <path to firmware file or dir>"
  exit 1
fi

IN_PATH=$(readlink -f "$1")
IN_DIR=$(dirname "$IN_PATH")
IN_FILE=$(basename "$IN_PATH")

if [ -d "${IN_PATH}" ]; then
    # Process the whole dir
    IN_FILE=""
fi


SCRATCH_DIR=$(realpath scratch)/${IN_DIR}/${IN_FILE}
mkdir -p $SCRATCH_DIR
docker run --rm -v /dev:/dev \
    -v ${IN_DIR}:/work/firmwares \
    --privileged \
    -v ${SCRATCH_DIR}:/work/FirmAE/scratch \
    firmae_isolated \
        bash -c "\
            cd /work/FirmAE && \
            sudo service postgresql start && \
            sleep 10 && \
            ./run.sh -c brand /work/firmwares/${IN_FILE} \
            "
