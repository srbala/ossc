# Prepare the JRE:
JDK_URL="$(curl -s --head https://api.adoptium.net/v3/binary/latest/11/ga/linux/x64/jdk/hotspot/normal/adoptium | grep 'Location:' | sed 's/Location: //g'| tr -d '\r')"
SHA_SUM_URL="$JDK_URL.sha256.txt"
TMP_DIR=$(mktemp -d)
pushd $TMP_DIR
SHA_FILE=jdk.tar.gz.sha256sum
wget $JDK_URL $SHA_SUM_URL
sha256sum -c *.sha256.txt
mkdir jdk-11
BUILD_JDK="$TMP_DIR/jdk-11"
pushd $BUILD_JDK
tar --strip-components=1 -xf ../*.tar.gz
popd
# Choices are:
# - Specific module, like 'java.base'
# - Java SE, via module 'java.se'
# - All modules, via token 'ALL-MODULE-PATH'
# Run the jlink command
$BUILD_JDK/bin/jlink \
  --add-modules ALL-MODULE-PATH \
  --strip-debug \
  --no-man-pages \
  --no-header-files \
  --compress=2 \
  --output jre-11
JRE=$(pwd)/jre-11
du -sh $JRE
$JRE/bin/java -version
popd

# Build the runtime container based on UBI8 micro

microcontainer=$(buildah from docker.io/almalinux/8-micro)
buildah run --tty $microcontainer mkdir -p /opt/java
buildah add $microcontainer $JRE /opt/java/openjdk
buildah config --env 'JAVA_HOME=/opt/java/openjdk' $microcontainer
buildah config --env 'PATH=$JAVA_HOME/bin:$PATH' $microcontainer
micromount=$(buildah mount $microcontainer)
dnf --nogpgcheck --repoid=AppStream --repoid=BaseOS \
    --repofrompath='BaseOS,https://repo.almalinux.org/almalinux/8/BaseOS/x86_64/os/' \
    --repofrompath='AppStream,https://repo.almalinux.org/almalinux/8/AppStream/x86_64/os/' \
    install \
    --installroot $micromount \
    --releasever 8 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    zlib
dnf clean all \
    --installroot $micromount
buildah umount $microcontainer
buildah run --tty $microcontainer java -version
buildah commit $microcontainer alma-micro-java-11

# Cleanup
rm -rf $TMP_DIR
