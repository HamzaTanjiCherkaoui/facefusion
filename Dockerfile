FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Install dependencies
RUN apt update && apt install -y \
    git-all \
    curl \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/opt/miniconda/bin:$PATH"

# Initialize and create FaceFusion Conda environment
RUN conda init --all && \
    conda create --name facefusion python=3.12 -y && \
    conda activate facefusion && \
    conda install -y -c conda-forge cuda-runtime=12.4 cudnn=9.3.0.75 && \
    git clone https://github.com/facefusion/facefusion && \
    cd facefusion && \
    python install.py --onnxruntime cuda

# Activate environment by default
SHELL ["/bin/bash", "-c"]
RUN echo "conda activate facefusion" >> ~/.bashrc

CMD ["/bin/bash"]
