FROM homebrew/brew:latest

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y default-jre default-jdk android-sdk

RUN brew install cmake zlib boost jsoncpp fmt re2 git

ENV CMAKE_PREFIX_PATH "/home/linuxbrew/.linuxbrew/opt/jsoncpp:/home/linuxbrew/.linuxbrew/opt/zlib"

RUN git clone https://github.com/facebook/redex.git /redex \
  && cd /redex && mkdir install &&  mkdir build && cd build \
  && cmake -DCMAKE_INSTALL_PREFIX="/redex/install" .. \
  && make -j6 && make install

ENV ANDROID_SDK_PATH "/usr/lib/android-sdk"
ENV LD_LIBRARY_PATH "/home/linuxbrew/.linuxbrew/Cellar/boost/1.76.0/lib:/home/linuxbrew/.linuxbrew/opt/jsoncpp/lib:/home/linuxbrew/.linuxbrew/opt/zlib/lib"
WORKDIR /root