# The base IRIS image. Modify the build script argument to use a different version.
ARG IMAGE=containers.intersystems.com/intersystems/iris:2022.2.0.368.0
FROM $IMAGE

# REFERENCE: https://httpd.apache.org/docs/2.4/install.html

# Get some dependencies with root power
USER root
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
   apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  zlib1g \
  curl \
  wget \
  vim \
  libkrb5-dev \
  libapr1-dev \
  libaprutil1-dev \
  libpcre3-dev

# Install apache as the same non-root user who owns the IRIS instance
# and is the default user for this container, so that default user
# can start and stop Apache, modify config files, etc.
USER ${ISC_PACKAGE_MGRUSER}

# Arguments for retrieving Apache and Web Gateway. Ensure these are up to date.
# For Web Gateway, ensure you're using the correct version for your host machine.
# If on ARM, change this to an ARM-based kit.
# NB: This Dockerfile assumes you already downloaded the Web Gateway and placed
# the tarball locally on your host.
ARG APACHE_URL="https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.gz" \
    APACHE_FOLDER="httpd-2.4.54" \
    WEB_GATEWAY_FOLDER="WebGateway-2022.2.0.368.0-lnxubuntu2204x64" \
    PLATFORM="lnxubuntu2204x64"


COPY --chown=irisowner ${WEB_GATEWAY_FOLDER}.tar.gz /home/irisowner/

# Apache installation. Since apt install would require root or sudo access and
# we want a non-root user to control this, we install from source.
RUN cd ${HOME} \
  && wget ${APACHE_URL} \
  && gunzip ${APACHE_FOLDER}.tar.gz \
  && tar -xf ${APACHE_FOLDER}.tar \
  && cd ${APACHE_FOLDER} \
  && ./configure --prefix=${HOME}/apache2/ --with-port=8080 \
  && make \
  && make install \
  && cd ${HOME} \
  && rm -rf ${APACHE_FOLDER} \
  && rm -rf ${APACHE_FOLDER}.tar \
  && rm -rf ${APACHE_FOLDER}.tar.gz

# Install the Web Gateway after installing Apache.
RUN cd ${HOME} \
    && export WEB_GATEWAY_INSTALLDIR=${HOME}/webgateway/ \
    && gunzip ${WEB_GATEWAY_FOLDER}.tar.gz \
    && tar -xf ${WEB_GATEWAY_FOLDER}.tar \
    && mkdir -p ${WEB_GATEWAY_INSTALLDIR}/bin  \
    && mkdir -p ${WEB_GATEWAY_INSTALLDIR}/bin/temp \
    && chmod 770 ${WEB_GATEWAY_INSTALLDIR}/bin/temp \
    && mkdir -p ${WEB_GATEWAY_INSTALLDIR}/apache  \
    && mkdir -p ${WEB_GATEWAY_INSTALLDIR}/docs  \
    && cp -p ${WEB_GATEWAY_FOLDER}/${PLATFORM}/bin/*CSP* ${WEB_GATEWAY_INSTALLDIR}/bin \
    && cp -p ${WEB_GATEWAY_FOLDER}/${PLATFORM}/bin/*csp* ${WEB_GATEWAY_INSTALLDIR}/bin \
    && cp -p ${WEB_GATEWAY_FOLDER}/${PLATFORM}/bin/shared/cvtcfg ${WEB_GATEWAY_INSTALLDIR}/bin \
    && cp -p ${WEB_GATEWAY_FOLDER}/${PLATFORM}/bin/shared/irisconnect.so ${WEB_GATEWAY_INSTALLDIR}/bin \
    && cp -p ${WEB_GATEWAY_FOLDER}/install/apache/mod_csp.c ${WEB_GATEWAY_INSTALLDIR}/apache \
    && cp -p ${WEB_GATEWAY_FOLDER}/install/buildver ${WEB_GATEWAY_INSTALLDIR}/ \
    && rm -rf ${WEB_GATEWAY_FOLDER} \
    && rm -rf ${WEB_GATEWAY_FOLDER}.tar \
    && rm -rf ${WEB_GATEWAY_FOLDER}.tar.gz

COPY --chown=irisowner CSP.conf /home/irisowner/apache2/conf
COPY --chown=irisowner CSP.ini /home/irisowner/webgateway/bin

RUN echo "Include /home/irisowner/apache2/conf/CSP.conf" >> ${HOME}/apache2/conf/httpd.conf

