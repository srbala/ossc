# Prepare the JRE:
CUR_DIR=$(pwd)
JDK_URL="$(curl -s --head https://api.adoptium.net/v3/binary/latest/8/ga/linux/x64/jdk/hotspot/normal/adoptium | grep 'Location:' | sed 's/Location: //g'| tr -d '\r')"
SHA_SUM_URL="$JDK_URL.sha256.txt"
TMP_DIR=$(mktemp -d)
pushd $TMP_DIR
SHA_FILE=jdk.tar.gz.sha256sum
wget $JDK_URL $SHA_SUM_URL
sha256sum -c *.sha256.txt
mkdir jdk-8
BUILD_JDK="$TMP_DIR/jdk-8"
pushd $BUILD_JDK
tar --strip-components=1 -xf ../*.tar.gz
pushd
JRE=$"$TMP_DIR/jdk-8"
$CUR_DIR/slim-java.sh $JRE
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
buildah commit $microcontainer alma-slim-java-8

# Cleanup
rm -rf $TMP_DIR
