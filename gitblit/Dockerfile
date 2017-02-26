# Basics
#
from ubuntu:latest
label maintainer James Moger <james.moger@gitblit.com>
run DEBIAN_FRONTEND=noninteractive echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get update && apt-get install -q -y --no-install-recommends curl git-core oracle-java8-installer && \
    rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true && \
    rm -rf /var/lib/apt/lists/* 

# Install Gitblit
# Move the data files to a separate directory
# Adjust the default Gitblit settings to bind to 80, 443, 9418, 29418, and allow RPC administration.
#
# Note: we are writing to a different file here because sed doesn't like to the same file it
# is streaming.  This is why the original properties file was renamed earlier.

run curl -Lks http://dl.bintray.com/gitblit/releases/gitblit-1.8.0.tar.gz -o /root/gitblit.tar.gz && \
    mkdir -p /opt/gitblit-tmp && \
    tar zxf /root/gitblit.tar.gz -C /opt/gitblit-tmp && \
    mv /opt/gitblit-tmp/gitblit-1.8.0 /opt/gitblit && \
    rm -rf /opt/gitblit-tmp && \
    rm -f /root/gitblit.tar.gz && \
    mkdir -p /opt/gitblit-data && \
    mv /opt/gitblit/data/* /opt/gitblit-data && \
    echo "server.httpPort=80" >> /opt/gitblit-data/gitblit.properties && \
    echo "server.httpsPort=443" >> /opt/gitblit-data/gitblit.properties && \
    echo "server.redirectToHttpsPort=true" >> /opt/gitblit-data/gitblit.properties && \
    echo "web.enableRpcManagement=true" >> /opt/gitblit-data/gitblit.properties && \
    echo "web.enableRpcAdministration=true" >> /opt/gitblit-data/gitblit.properties

# Setup the Docker container environment and run Gitblit
workdir /opt/gitblit
expose 80 443 9418 29418
cmd ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit-data"]
