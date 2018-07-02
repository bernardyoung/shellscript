#!/bin/bash
for images_tar_gz in $(ls | grep tar.gz);
        do
        tar -zxvf $images_tar_gz
        images_tar=${images_tar_gz%.gz}
        docker load < $images_tar
        rm -rf $images_tar_gz
done
