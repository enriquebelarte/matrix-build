FROM registry.distributed-ci.io/dtk/driver-toolkit:5.14.0-284.57.1.el9_2 as builder

ARG ARCH='x86_64'
ARG DRIVER_VERSION='535.161.08'
ARG DRIVER_EPOCH='1'
ARG KERNEL_VERSION='5.14.0-284.57.1.el9_2'
ARG RHEL_VERSION='9.2'
ARG KERNEL_SOURCES='/usr/src/kernels/${KERNEL_VERSION}.${ARCH}'
ARG KERNEL_OUTPUT='/usr/src/kernels/${KERNEL_VERSION}.${ARCH}'

WORKDIR /home/builder

RUN export KVER=$(echo ${KERNEL_VERSION} | cut -d '-' -f 1) \
        KREL=$(echo ${KERNEL_VERSION} | cut -d '-' -f 2 | sed 's/\.el._.$//') \
        KDIST=$(echo ${KERNEL_VERSION} | cut -d '-' -f 2 | sed 's/^.*\(\.el._.\)$/\1/') \
        DRIVER_STREAM=$(echo ${DRIVER_VERSION} | cut -d '.' -f 1) \
        KSOURCES=$(echo ${KERNEL_VERSION}.${ARCH}) && \
        git clone -b ${DRIVER_VERSION}  https://github.com/NVIDIA/open-gpu-kernel-modules.git && \
        cd open-gpu-kernel-modules && \
        make SYSSRC=${KERNEL_SOURCES} SYSOUT=${KERNEL_OUTPUT} modules

FROM scratch
COPY --from=builder /home/builder/open-gpu-kernel-modules/kernel-open/*.ko /drivers/
