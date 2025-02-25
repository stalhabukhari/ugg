# This Dockerfile sets up a UGG environment with PyTorch (GPU)
FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y \
        wget git net-tools vim curl build-essential x11vnc zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
        libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev freeglut3-dev && \
        # following is for opencv-python (uncomment if not needed)
        apt install -y --no-install-recommends libglib2.0-0 libxrender1 libxext6 libsm6 libgl1-mesa-glx && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# install miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    mkdir /root/.conda && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm -f Miniconda3-latest-Linux-x86_64.sh && \
    echo "Running $(conda --version)"

# install python packages
COPY environment/environment.yml /env-setup/environment.yml
RUN conda init bash && . /root/.bashrc && \
    conda env create -f /env-setup/environment.yml && \
    source activate ugg && \
    pip install --upgrade pip && \
    conda install -y pytorch==2.0.1 torchvision==0.15.2 pytorch-cuda=11.7 -c pytorch -c nvidia && \
    conda install -y pytorch3d -c pytorch3d && \
    conda install -y pyg pytorch-sparse pytorch-spline-conv pytorch-scatter pytorch-cluster -c pyg

COPY thirdparty /code-dir/thirdparty
COPY LION /code-dir/LION
ENV TORCH_CUDA_ARCH_LIST="8.0+PTX"
RUN source activate ugg && \
    cd /code-dir/thirdparty/pytorch_kinematics && pip install -e . && \
    cd /code-dir/thirdparty/TorchSDF && pip install -e . && \
    cd /code-dir/LION && python build_pkg.py

WORKDIR /code-dir
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "ugg", "/bin/bash", "-c"]
