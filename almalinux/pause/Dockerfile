FROM almalinux as pause-build
RUN mkdir -p /mnt/rootfs; yum install --installroot /mnt/rootfs --releasever 8 --setopt install_weak_deps=false --nodocs -y gcc glibc-minimal-langpack
ADD pause.c /mnt/rootfs/pause.c
RUN chroot /mnt/rootfs gcc -s -O2 -Wall /pause.c -o /pause

FROM scratch AS pause
LABEL maintainer="Bala Raman<srbala@gmail.com>"

#labels for container catalog
LABEL summary="Simple pause container"
LABEL description="The pause container provides a way to run a container indefinitely. It will wait for interruption signals which terminate its execution."
LABEL io.k8s.display-name="Pause"
LABEL io.openshift.expose-services=""

# https://raw.githubusercontent.com/kubernetes/kubernetes/master/build/pause/linux/pause.c
COPY --from=pause-build /mnt/rootfs/pause /pause
COPY --from=pause-build /mnt/rootfs/lib64/libc.*so.* /lib64/
COPY --from=pause-build /mnt/rootfs/lib64/libc-*so /lib64/
COPY --from=pause-build /mnt/rootfs/lib64/ld-*.so* /lib64/

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["/pause"]