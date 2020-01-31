# Base Jboss EAP image
# Use latest jboss/base-jdk:8 image as the base
FROM jboss/base-jdk:8

# Set the JN_VERSION env variable
ENV JBOSSEAP_VERSION 7.2.0
ENV JBOSSEAP_SHA1 ef0372589a0f08c36b15360fe7291721a7e3f7d9
ENV JBOSS_HOME /opt/jboss/eap

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
# Need fix to URL for local build
RUN cd $HOME \
    && curl -O https://localhost/srbala/docker-images/releases/download/v0.1.0/jboss-eap-$JBOSSEAP_VERSION.zip \
    && sha1sum jboss-eap-$JBOSSEAP_VERSION.zip | grep $JBOSSEAP_SHA1 \
    && tar xf jboss-eap-$JBOSSEAP_VERSION.zip \
    && mv $HOME/jboss-eap-$JBOSSEAP_VERSION $JBOSS_HOME \
    && rm jboss-eap-$JBOSSEAP_VERSION.zip \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/eap/bin/standalone.sh", "-b", "0.0.0.0"]
