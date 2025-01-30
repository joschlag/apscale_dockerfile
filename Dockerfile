FROM continuumio/continuumio/miniconda3:24.11.1-0

ENV PATH /opt/conda/bin:$PATH

RUN conda config --append channels conda-forge && \
  conda config --append channels bioconda && \
  conda config --append channels anaconda && \
  conda install python=3.7 vsearch=2.29.2 libzlib=1.3.1 cutadapt=4.1 && \
  conda clean -a -y

RUN pip install apscale

CMD ["apscale"]
