FROM frolvlad/alpine-glibc:latest
MAINTAINER Radek Ševčík <zcsevcik@gmail.com>

RUN apk --update add make
RUN apk --update add --virtual build-dependencies w3m openssl ca-certificates unzip
RUN apk --update add stlink --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

RUN GCCARM_LINK="$(w3m -o display_link_number=1 -dump 'https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads' | \
  grep -m1 '^\[[0-9]\+\].*downloads.*gcc-arm-none-eabi.*linux\.tar\.bz2' | \
  sed -e 's/^\[[0-9]\+\] //')" && \
  wget -O /tmp/gcc-arm-none-eabi.tar.bz2 ${GCCARM_LINK} && \
  tar xvf /tmp/gcc-arm-none-eabi.tar.bz2 --strip-components=1 -C /usr && \
  rm -rf /tmp/gcc-arm-none-eabi.tar.bz2

RUN FW_F0="stm32cube_fw_f0_v170.zip" && \
  wget -O /tmp/${FW_F0} "https://sourceforge.net/projects/micro-os-plus/files/Vendor%20Archives/STM32/${FW_F0}/download" && \
  unzip /tmp/${FW_F0} -d /opt && \
  rm -fr /tmp/${FW_F0}

RUN FW_F1="stm32cube_fw_f1_v140.zip" && \
  wget -O /tmp/${FW_F1} "https://sourceforge.net/projects/micro-os-plus/files/Vendor%20Archives/STM32/${FW_F1}/download" && \
  unzip /tmp/${FW_F1} -d /opt && \
  rm -fr /tmp/${FW_F1}

RUN apk del build-dependencies
