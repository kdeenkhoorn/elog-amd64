FROM ghcr.io/kdeenkhoorn/debian-stable-amd64:latest AS build

# Upgrade base OS image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y wget imagemagick ckeditor libssl-dev make gcc g++ \
    && mkdir /opt/build /opt/sbin /opt/bin /opt/elog /opt/man \
    && cd /opt/build \
    && wget https://elog.psi.ch/elog/download/tar/elog-latest.tar.gz \
    && tar -xvf elog-latest.tar.gz --strip-components=1 \
    && make SDESTDIR=/opt/sbin DESTDIR=/opt/bin ELOGDIR=/opt/elog MANDIR=/opt/man install \
    && cd /opt \
    && rm -rf /opt/build

# Start with new base
FROM ghcr.io/kdeenkhoorn/debian-stable:latest

# Upgrade base OS image
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install specific software we need for this image
# imagemagick and mailutils and add user
RUN groupadd -g 2001 elog \
    && useradd -u 2001 -g 2001 -c "elog useraccount" -d /opt/elog -s /bin/bash elog \
    && apt-get update \
    && apt-get --no-install-recommends -y install openssl imagemagick ckeditor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build --chmod=0770 --chown=elog:elog /opt /opt

VOLUME ["/opt/elog"]
EXPOSE 8080
USER elog
ENTRYPOINT ["/opt/sbin/elogd"]
CMD ["-p", "8080", "-c", "/opt/elog/elogd.cfg"]
