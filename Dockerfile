FROM fedora:25
MAINTAINER Jean Jacquemier LAPP <jacquem@lapp.in2p3.fr>

ARG PLIBS_8_CLONE_URL=https://gitlab.in2p3.fr/CTA-LAPP/PLIBS_8.git
ARG PLIBS_8_VERSION=master


RUN echo 'check-update' ; dnf check-update -yv \
 && echo 'distro-sync' ; dnf distro-sync -yv \
 && echo 'install C Dev' ; dnf group install -yv 'C Development Tools and Libraries' \
 && echo 'install dDev tools'; dnf group install -yv 'Development Tools' \
 && dnf install -y wget bzip2 bzip2-devel libXext libSM libXrender cmake \
                   graphviz hdf5 hdf5-devel fftw-libs fftw-devel \
		   ncurses ncurses-libs ncurses-devel readline readline-devel \
		   hostname libgomp

ARG MINICONDA_VERSION=4.3.11

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH
ENV LANG en_US.utf8

# Install PLIBS_8 dependencies
RUN echo "install depedencies" \
 && dnf install gcc -y \
 && dnf install gcc-c++ -y \
 && dnf install git -y \
 && dnf install cmake -y \
 && dnf install doxygen -y \
 && dnf install graphviz -y



# Clone PLIBS_* GIT repository
RUN source activate ${CONDA_ENV} \
 && git clone $PLIBS_8_CLONE_URL /opt/PLIBS_8 \
 && cd /opt/PLIBS_8 \
 && git checkout $PLIBS_8_VERSION \
 && mkdir build
