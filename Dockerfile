FROM ubuntu:22.04

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Install wget
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda on x86
RUN arch=$(uname -m) \
    && if [ "$arch" = "x86_64" ]; then \
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py39_24.11.1-0-Linux-x86_64.sh"; \
      else \
        echo "Unsupported architecture: $arch"; \
      exit 1; \
      fi \
    && wget $MINICONDA_URL -O miniconda.sh \
    && mkdir -p /root/.conda \
    && bash miniconda.sh -b -p /root/miniconda3 \
    && rm -f miniconda.sh

# create conda environment
RUN conda init bash \
    && . ~/.bashrc \
    && conda create --name apscale python=3.7 \
    && conda install -n apscale vsearch=2.29.2 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale libzlib=1.3.1 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale cutadapt=4.1 -c defaults -c conda-forge -c bioconda \
    && conda activate apscale \
    && conda clean -a -y \
    && pip install apscale

RUN echo "source activate apscale" > ~/.bashrc
ENV PATH=/root/miniconda3/envs/apscale/bin:$PATH

CMD ["source ~/.bashrc"]
