FROM  nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04
#FROM bit:5000/ubuntu18.04_cuda10.1_devel_cudnn7
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH
ENV LC_ALL=C
ENV TZ=Asia/Shanghai

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN APT_INSTALL="apt-get install -y --no-install-recommends"
RUN PIP_INSTALL="python -m pip --no-cache-dir install -i https://pypi.tuna.tsinghua.edu.cn/simple " && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list
RUN     apt-get update && apt-get install -y --no-install-recommends \
                build-essential \
                cmake \
                git \
                wget \
                libatlas-base-dev \
                libboost-all-dev \
                libgflags-dev \
                libgoogle-glog-dev \
                libhdf5-serial-dev \
                libleveldb-dev \
                liblmdb-dev \
                libopencv-dev \
                libprotobuf-dev \
                libsnappy-dev \
                protobuf-compiler \
                nano \
                libopenblas-dev \
                liblapack-dev \
                python-tk \
                openssh-client \
                openssh-server \
                zip \
                unzip \
        autossh \
        expect && \
        apt-get install --no-install-recommends -y libboost-all-dev && \
        apt-get install --no-install-recommends -y libopenblas-dev \
                liblapack-dev \
                libatlas-base-dev \
                libgflags-dev \
                libgoogle-glog-dev \
                liblmdb-dev \
                gfortran && \
        apt-get install -y build-essential git \
                libprotobuf-dev \
                libleveldb-dev \
                libsnappy-dev \
                libopencv-dev \
                libboost-all-dev \
                libhdf5-serial-dev \
                libgflags-dev \
                libgoogle-glog-dev \
                liblmdb-dev \
                protobuf-compiler \
                protobuf-c-compiler \
                libyaml-dev \
                libffi-dev \
                libssl-dev \
                python-dev \
                python-pip \
                python3-pip \
                liblmdb-dev \
                time \
                vim \
                screen \
                tmux
                

RUN apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.6 python3.6-dev && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        pip

RUN     mkdir ~/.pip && echo "[global]" > ~/.pip/pip.conf && \
        echo "index-url=https://pypi.tuna.tsinghua.edu.cn/simple" >> ~/.pip/pip.conf && \
        echo "format = columns" >> ~/.pip/pip.conf
RUN pip --no-cache-dir --default-timeout=10000 install tensorboardX
RUN cd /tmp && wget torch-1.3.0-cp36-cp36m-manylinux1_x86_64.whl && pip --no-cache-dir install torch-1.3.0-cp36-cp36m-manylinux1_x86_64.whl && \ rm -rf torch-1.3.0-cp36-cp36m-manylinux1_x86_64.whl && \
    pip --no-cache-dir install torchvision==0.4.1


RUN pip install -i https://pypi.mirrors.ustc.edu.cn/simple/ --default-timeout=1000 --no-cache-dir wheel  setuptools scikit-learn  Cython  easydict   hickle  pyyaml  matplotlib \
        lxml  opencv-python tqdm  threadpool  tensorboardX    \
        nibabel  numpy  pandas  pillow  scikit-image  scikit-learn  scipy  pynrrd  tensorboardx  lmdb  editdistance  natsort  nltk  colour


#RUN pip install git+https://github.com/mapillary/inplace_abn.git@v1.0.8

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && unzip ninja-linux.zip -d /usr/local/bin/ && update-alternatives --install /usr/bin/ninja ninja /usr/local/bin/ninja 1 --force  && rm -rf ninja-linux.zip

WORKDIR /tmp/
RUN git clone https://github.com/NVIDIA/apex.git && \
    cd apex && \
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./ && \
    cd .. && rm -rf apex

RUN     ldconfig && \
        apt-get -y clean && \
        apt-get -y autoremove && \
        rm -rf /var/lib/apt/lists/* /tmp/* ~/*

EXPOSE 6006
EXPOSE 22
