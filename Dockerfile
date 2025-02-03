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
ENV PATH /opt/conda/bin:$PATH

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

# entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set the entry point to the script
ENTRYPOINT ["/bin/bash", "-l", "-c", "/usr/local/bin/entrypoint.sh"]

#RUN echo ". ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
RUN echo "conda activate apscale" >> ~/.bashrc

CMD ['conda', 'activate', 'apscale']
#CMD ["/bin/bash"]
