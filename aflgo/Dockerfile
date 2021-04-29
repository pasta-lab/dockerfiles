# Based on https://github.com/pato-research/aflgo/blob/master/scripts/build/aflgo-build.sh
FROM ubuntu:20.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive &&\
  apt-get install -y wget curl build-essential make cmake ninja-build git subversion binutils-gold binutils-dev python3-distutils python2.7 \
        python-dev python3 python3-dev python3-pip autoconf automake libtool-bin python-bs4 gawk libboost-all-dev gnuplot libclang-11-dev &&\
  apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
  python3 -m pip install --upgrade pip && python3 -m pip install networkx pydot pydotplus

ENV CXX=g++
ENV CC=gcc
ENV CFLAGS=""
ENV CXXFLAGS=""

ARG BUILD_DIR=/build/llvm_tools

RUN mkdir -p $BUILD_DIR && cd $BUILD_DIR &&\
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-11.0.0.src.tar.xz &&\
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang-11.0.0.src.tar.xz &&\
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/compiler-rt-11.0.0.src.tar.xz &&\
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/libcxx-11.0.0.src.tar.xz &&\
  wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/libcxxabi-11.0.0.src.tar.xz &&\
  tar xf llvm-11.0.0.src.tar.xz --no-same-owner &&\
  tar xf clang-11.0.0.src.tar.xz --no-same-owner &&\
  tar xf compiler-rt-11.0.0.src.tar.xz --no-same-owner &&\
  tar xf libcxx-11.0.0.src.tar.xz --no-same-owner &&\
  tar xf libcxxabi-11.0.0.src.tar.xz --no-same-owner &&\
  mv clang-11.0.0.src $BUILD_DIR/llvm-11.0.0.src/tools/clang &&\
  mv compiler-rt-11.0.0.src $BUILD_DIR/llvm-11.0.0.src/projects/compiler-rt &&\
  mv libcxx-11.0.0.src $BUILD_DIR/llvm-11.0.0.src/projects/libcxx &&\
  mv libcxxabi-11.0.0.src $BUILD_DIR/llvm-11.0.0.src/projects/libcxxabi &&\
  mkdir -p build-llvm/llvm; cd build-llvm/llvm &&\
  cmake -G "Ninja" \
        -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
        -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_BINUTILS_INCDIR=/usr/include $BUILD_DIR/llvm-11.0.0.src &&\
  ninja && ninja install &&\
  mkdir -p /usr/lib/bfd-plugins &&\
  cp /usr/local/lib/libLTO.so /usr/lib/bfd-plugins &&\
  cp /usr/local/lib/LLVMgold.so /usr/lib/bfd-plugins


RUN mkdir -p $BUILD_DIR/build-llvm/msan && cd $BUILD_DIR/build-llvm/msan &&\
  cmake -G "Ninja" \
        -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
        -DLLVM_USE_SANITIZER=Memory -DCMAKE_INSTALL_PREFIX=/usr/msan/ \
        -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
        -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" \
        $BUILD_DIR/llvm-11.0.0.src &&\
  ninja cxx && ninja install-cxx

RUN rm -rf /build

ENV LC_ALL=C
ENV CXX=clang++
ENV CC=clang

ENV AFLGO=/aflgo
RUN git clone https://github.com/pato-research/aflgo.git $AFLGO &&\
  cd $AFLGO && make clean all && cd llvm_mode && make clean all && cd .. &&\
  cd distance_calculator && cmake -G Ninja ./ && cmake --build ./

WORKDIR $AFLGO

