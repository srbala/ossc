FROM registry.access.redhat.com/ubi8/ubi:8.3
LABEL maintainer="Red Hat, Inc." \
      com.redhat.component="skopeo-container" \
      name="rhel8/skopeo" \
      version="8.3" \
      License="ASL 2.0" \
#labels for container catalog
      summary="Inspect container images and repositories on registries" \
      description="Command line utility to inspect images and repositories directly on registries without the need to pull them" \
      io.k8s.display-name="Skopeo" \
      io.openshift.expose-services=""

RUN useradd build; dnf -y module enable container-tools:rhel8; dnf -y update; dnf -y reinstall shadow-utils; \
    dnf -y install skopeo fuse-overlayfs; rm -rf /var/cache /var/log/dnf* /var/log/yum.* \

# Adjust storage.conf to enable Fuse storage.
    && sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' /etc/containers/storage.conf \
    && mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers; \
    touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock \
# workaround for rhbz#1918554
    && sed -i -e 's|"/var/lib/shared",|#"/var/lib/shared",|' /etc/containers/storage.conf
ENV STORAGE_DRIVER=vfs \
# Set up environment variables to note that this is
# not starting with usernamespace and default to
# isolate the filesystem with chroot.
    _BUILDAH_STARTED_IN_USERNS="" BUILDAH_ISOLATION=chroot
