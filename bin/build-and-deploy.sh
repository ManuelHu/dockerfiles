#!/bin/bash

function docker_cmd() {
    docker build --pull --rm "$@"
}

prefix="g4edge/"
tag=$(date +%Y%m%d)

images=(manylinux2014 manylinux_2_28)
archs=(x86_64)

for img in ${images[@]}; do
    cd $img
    for arch in ${archs[@]}; do
        docker_cmd --build-arg IMAGE=$img --build-arg ARCH=$arch -f ../manylinux_common/Dockerfile -t ${prefix}${img}_${arch}:$tag .
        docker tag ${prefix}${img}_${arch}:{$tag,latest}
        docker push ${prefix}${img}_${arch}:$tag && docker push ${prefix}${img}_${arch}:latest
    done
    cd ..
done
