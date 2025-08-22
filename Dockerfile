
FROM ubuntu:22.04

# Install basic tools
RUN apt-get update && \
    apt-get install -y wget bzip2 gzip && \
    apt-get clean

# Install Miniconda
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-py39_24.11.1-0-Linux-x86_64.sh" -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm -f /tmp/miniconda.sh

# Add Conda to PATH
ENV PATH=/opt/conda/bin:$PATH

# Initialize conda for bash
RUN conda init bash

# Install Apscale dependencies
RUN conda install -y python=3.11 \
    vsearch=2.29.2 \
    cutadapt=5.1 \
    swarm=3.1.5 \
    pytables \
    libzlib \
    -c defaults -c conda-forge -c bioconda && \
    pip install biopython==1.85 apscale==4.1.4 pyyaml==6.0.2 && \
    conda clean -a -y

# Copy the modified j_generate_read_table.py to replace
COPY modifications/j_generate_read_table.py /opt/conda/lib/python3.11/site-packages/apscale/j_generate_read_table.py

# Automatically use base environment
RUN echo "conda activate base" >> ~/.bashrc

# PATH points to Conda base binaries
ENV PATH=/opt/conda/bin:$PATH

# Set entrypoint
ENTRYPOINT ["apscale"]
