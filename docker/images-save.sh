#!/bin/bash
for images in $(sudo docker images | awk '{print $1":"$2}' | grep -v TAG);
        do
        echo $images
        images_tar=${images////_}
        images_tar=${images_tar//:/_}
        images_tar=$images_tar.tar
        images_tar_gz=$images_tar.gz
        docker save $images > $images_tar
        tar -czvf $images_tar_gz $images_tar
        rm -rf ./$images_tar
done
