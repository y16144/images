FROM ubuntu:22.04 as base

LABEL org.opencontainers.image.ref.name=ubuntu
LABEL org.opencontainers.image.version=22.04

ENV TZ=UTC

RUN export DEBIAN_FRONTEND=noninteractive \
 && echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend \
 && apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install -y wget vim curl lsb-release gnupg2 \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8 \
 && apt-get autoremove -y \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* /root/.cache

RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee /etc/apt/trusted.gpg.d/pgdg.asc \
 && apt-get update -y \
 && cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d \
 && apt-get install -y postgresql-client-15

RUN wget -O /tmp/pgcenter.deb https://github.com/lesovsky/pgcenter/releases/download/v0.9.2/pgcenter_0.9.2_linux_amd64.deb --no-check-certificate \
 && apt-get install /tmp/pgcenter.deb \
 && rm /tmp/pgcenter.deb
 ## Make sure we have a en_US.UTF-8 locale available
 ## && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 ## Clean up

RUN wget -O /tmp/wal-g.linux-amd64.tar.gz https://github.com/wal-g/wal-g/releases/download/v2.0.1/wal-g-gp-ubuntu-20.04-amd64.tar.gz --no-check-certificate \
 && tar xf /tmp/wal-g.linux-amd64.tar.gz -C /usr/bin \
 && rm /tmp/wal-g.linux-amd64.tar.gz

CMD ["/usr/bin/bash"]
