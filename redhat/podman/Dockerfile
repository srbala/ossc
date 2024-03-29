FROM redhat/ubi8:8.5
LABEL maintainer="Red Hat, Inc." \
      com.redhat.component="podman-container" \
      name="rhel8/podman" \
      version="8.5"\
      License="ASL 2.0" \
#labels for container catalog
      summary="Manage Pods, Containers and Container Images" \
      description="podman (Pod Manager) is a fully featured container engine that is a simple daemonless tool. podman provides a Docker-CLI comparable command line that eases the transition from other container engines and allows the management of pods, containers and images.  Simply put: alias docker=podman.  Most podman commands can be run as a regular user, without requiring additional privileges. podman uses Buildah(1) internally to create container images. Both tools share image (not container) storage, hence each can use or manipulate images (but not containers) created by the other." \
      io.k8s.display-name="Podman" \
      io.openshift.expose-services=""

RUN useradd build; dnf -y module enable container-tools:rhel8; dnf -y update; dnf -y reinstall shadow-utils; \
    dnf -y install podman fuse-overlayfs /etc/containers/storage.conf; rm -rf /var/cache /var/log/dnf* /var/log/yum.* && \
# Adjust storage.conf to enable Fuse storage.
    sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf \
    mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; \
    touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; \
# Use cgroups cgroup_manager by default (#1908567)
    sed -i -e '/^cgroup_manager.*/d' -e '/\#\ cgroup_manager\ =/a cgroup_manager = "cgroupfs"' /usr/share/containers/containers.conf; \
# workaround for rhbz#1918554
    sed -i -e 's|"/var/lib/shared",|#"/var/lib/shared",|' /etc/containers/storage.conf
ENV STORAGE_DRIVER=vfs \
# Set up environment variables to note that this is
# not starting with usernamespace and default to
# isolate the filesystem with chroot.
    _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot
