#!/bin/bash
i=0
for images in $(sudo docker images | awk '{print $1":"$2}' | grep -v TAG);
        do
        j=$((i+1))
        echo "==============================正在处理第 $j 个镜像=============================="
        images_tar=${images//\//_}
        images_tar=${images_tar//:/_}
        images_tar=$images_tar.tar
        images_tar_gz=$images_tar.gz
        echo "正在打包镜像 $images >>>"
        docker save $images > $images_tar  > /dev/null 2>&1
        echo "正在压缩镜像 $images_tar >>>"
        tar -czvf $images_tar_gz $images_tar > /dev/null 2>&1
        echo "正在删除临时tar包 $images_tar >>>"
        rm -rf ./$images_tar
        i=$((i+1))
        echo "==============================第 $j 个镜像打包完成=============================="
        echo 
done
echo 共 $i 个镜像打包完成
