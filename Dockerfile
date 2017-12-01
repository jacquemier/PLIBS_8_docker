FROM fedora:latest
MAINTAINER Jean Jacquemier LAPP <jacquem@lapp.in2p3.fr>

ARG PLIBS_8_CLONE_URL=https://gitlab.in2p3.fr/CTA-LAPP/PLIBS_8.git

ARG PLIBS_8_VERSION=master

# Install PLIBS_8 dependencies
RUN echo "install depedencies" \
 && dnf install gcc -y \
 && dnf install gcc-c++ -y \
 && dnf install git -y \
 && dnf install cmake -y \
 && dnf install doxygen -y \
 && dnf install graphviz -y



# Clone PLIBS_* GIT repository
RUN git clone $PLIBS_8_CLONE_URL /opt/PLIBS_8 \
 && cd /opt/PLIBS_8 \
 && git checkout $PLIBS_8_VERSION

# Build and install PLIBS_8
RUN cd /opt/PLIBS_8 \
 && mkdir build \
 && cd build \
 && cmake .. -DCMAKE_INSTALL \
 && make -j`grep -c '^processor' /proc/cpuinfo` all install \
 && ldconfig
