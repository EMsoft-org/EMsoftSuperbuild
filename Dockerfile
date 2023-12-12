FROM ubuntu:jammy

ARG TARGETARCH 
ARG DEBIAN_FRONTEND=noninteractive

RUN if [ "$TARGETARCH" = "arm64" ]; then \
 apt-get update && apt-get -y upgrade \
 && apt-get install -y \
 git \
 vim \
 wget \
 cmake \
 gcc \
 gfortran \
 ninja-build \
 build-essential \
 libopenblas-dev \
 apt-utils \
 opencl-headers \
 ocl-icd-opencl-dev \
 ocl-icd-libopencl1 \
 clinfo ; \
 elif [ "$TARGETARCH" = "amd64" ]; then \
 apt-get update && apt-get -y upgrade \
 && apt-get install -y \
 git \
 vim \
 wget \
 cmake \
 gcc \
 gfortran \
 ninja-build \
 build-essential \
 libopenblas-dev \
 apt-utils \
 opencl-headers \
 ocl-icd-opencl-dev \
 ocl-icd-libopencl1 \
 libpocl-dev \ 
 intel-opencl-icd \
 clinfo \
; fi

# intel-opencl-icd makes iGPUs work from Intel (tested on i5-8400)
# libpocl-dev is for CPU on both Intel and AMD

# set some environmental variables for the Nvidia container
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# set up OpenCL for Nvidia
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# clone EMsoft and set up SDK Debug/Release
RUN mkdir ~/EMs \
 && cd ~/EMs \
 && git clone --branch developOO https://github.com/EMsoft-org/EMsoftSuperbuild.git \
 && mv EMsoftSuperbuild EMsoftOOSuperbuild \
 && cd EMsoftOOSuperbuild && mkdir Debug Release

# EMsoftSuperbuild
RUN cd ~/EMs/EMsoftOOSuperbuild/Debug/ \
 && cmake -DEMsoftOO_SDK=/opt/EMsoftOO_SDK -DCMAKE_BUILD_TYPE=Debug ../ -G Ninja && ninja \
 && cd ../Release \
 && cmake -DEMsoftOO_SDK=/opt/EMsoftOO_SDK -DCMAKE_BUILD_TYPE=Release ../ -G Ninja && ninja
