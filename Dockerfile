FROM nvidia/cuda:11.7.0-cudnn8-runtime-ubuntu20.04
RUN apt-get update && apt install --no-install-recommends -y build-essential

FROM yubaoliu/dynaslam

#Update cuda driver
WORKDIR /home
RUN apt install -y gnupg-curl
RUN rm /etc/apt/sources.list.d/cuda.list
#RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub


ARG DEBIAN_FRONTEND=noninteractive

#uninstall opencv
WORKDIR /root
RUN find / -name "*opencv*" -exec rm -rf -i {} \;

#install opencv
# graphcuts.cpp needed for 2.4.11
WORKDIR /root
COPY install_opencv24.sh /root/
COPY FindCUDA.cmake /root/
COPY graphcuts.cpp /root/    
RUN ./install_opencv24.sh

# #download DynaSLAM
WORKDIR /root
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y nano gawk git libcanberra-gtk-module libcanberra-gtk3-module libatlas3-base \
    libgtkglext1 libgtkglext1-dev && \
    git clone https://github.com/BertaBescos/DynaSLAM.git

#Correcting CMakeLists.txt
WORKDIR /root/DynaSLAM
RUN head -n -4 CMakeLists.txt > temp.txt ; mv temp.txt CMakeLists.txt && \
    awk 'NR==86{print "/usr/local/lib/python2.7/dist-packages/numpy/core/include/numpy"}1' CMakeLists.txt > temp.txt && mv temp.txt CMakeLists.txt && \
    cd Thirdparty/DBoW2 && \
    awk 'NR==7{print "find_package(Qt5Widgets REQUIRED)"}1' CMakeLists.txt > temp.txt && mv temp.txt CMakeLists.txt && \
    awk 'NR==8{print "find_package(Qt5Concurrent REQUIRED)"}1' CMakeLists.txt > temp.txt && mv temp.txt CMakeLists.txt && \
    awk 'NR==9{print "find_package(Qt5OpenGL REQUIRED)"}1' CMakeLists.txt > temp.txt && mv temp.txt CMakeLists.txt && \
    awk 'NR==10{print "find_package(Qt5Test REQUIRED)"}1' CMakeLists.txt > temp.txt && mv temp.txt CMakeLists.txt && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppial.so /usr/local/lib/libopencv_dep_nppial.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppicc.so /usr/local/lib/libopencv_dep_nppicc.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppicom.so /usr/local/lib/libopencv_dep_nppicom.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppidei.so /usr/local/lib/libopencv_dep_nppidei.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppif.so /usr/local/lib/libopencv_dep_nppif.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppig.so /usr/local/lib/libopencv_dep_nppig.so && \ 
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppim.so /usr/local/lib/libopencv_dep_nppim.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppist.so /usr/local/lib/libopencv_dep_nppist.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppisu.so /usr/local/lib/libopencv_dep_nppisu.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libnppitc.so /usr/local/lib/libopencv_dep_nppitc.so && \
    ln -s /usr/local/cuda-9.0/targets/x86_64-linux/lib/libcudart.so /usr/local/lib/libopencv_dep_cudart.so && \
    cd ../.. && \
    ./build.sh

#download MaskRCNN
WORKDIR /root/DynaSLAM/src/python
RUN wget https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5

WORKDIR /root/DynaSLAM
RUN apt-get update  && \
    export TF_CPP_MIN_LOG_LEVEL=2
