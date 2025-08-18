FROM ubuntu:22.04

ARG apscale

# Install wget
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Install Miniconda on x86
RUN wget "https://repo.anaconda.com/miniconda/Miniconda3-py39_24.11.1-0-Linux-x86_64.sh" -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm -f /tmp/miniconda.sh

# Add /opt/conda/bin to the PATH environment variable
ENV PATH=/opt/conda/bin:$PATH

# create conda environment
RUN conda init bash \
    && . ~/.bashrc \
    && conda create --name apscale python=3.11 \
    && conda install -n apscale vsearch=2.29.2 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale libzlib=1.3.1 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale xlsxwriter=3.2.5 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale cutadapt=5.1 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale swarm=3.1.5 -c defaults -c conda-forge -c bioconda \
    && conda install -n apscale pytables -c conda-forge \
    && conda activate apscale \
    && conda clean -a -y \
    && conda run -n apscale pip install biopython==1.85 apscale==4.1.3 pyyaml==6.0.2 xlsxwriter==3.2.5

RUN conda run -n apscale pip install xlsxwriter==3.2.5
RUN conda install -y -c conda-forge -c bioconda xlsxwriter
    
#RUN echo ". ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
RUN echo "conda activate apscale" >> ~/.bashrc

# Set the entry point to the script
ENV PATH=/opt/conda/envs/apscale/bin:$PATH
ENTRYPOINT ["apscale"]

