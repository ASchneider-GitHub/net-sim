FROM ubuntu:24.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y \
        iproute2 \
        netcat-traditional \
        bash \
        coreutils \
        snmpd \
        softflowd \
        hping3 && \
    rm -rf /var/lib/apt/lists/*