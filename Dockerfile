# ==============================================================================
# AuraOS ISO Builder Container
# Cho phép build file ISO AuraOS trên mọi hệ thống (Windows, Linux, macOS qua Docker)
# ==============================================================================
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    curl \
    wget \
    ca-certificates \
    dosfstools \
    bash \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /auraos

COPY . /auraos

RUN chmod +x /auraos/build.sh /auraos/scripts/*.sh

VOLUME ["/output"]

CMD ["/bin/bash", "-c", "/auraos/build.sh && cp -r /auraos/output/* /output/"]
