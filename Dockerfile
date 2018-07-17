FROM r-base:latest

#
# Sophie Comp Lancy Dashboard
#
MAINTAINER Fred Moser "fred@mos.re"

#
# R shiny launcher
#
ENV R_BASE_VERSION 3.5.0
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV SHINY_PORT=3838
ENV DEBIAN_FRONTEND noninteractive

ARG r_deps_dev="r-base-dev="${R_BASE_VERSION}-*
ARG r_deps_sys="libgeos-dev libgdal-dev libgeo-proj4-perl libssl-dev"
ARG r_deps_shiny_server="sudo gdebi-core pandoc pandoc-citeproc libcairo2-dev/unstable libxt-dev"
ARG r_packages_date="2018-05-02"
ARG r_packages="c('shiny','rmarkdown','plotly','shinydashboard','httr','sp','leaflet','raster','rgdal','rgeos')"

WORKDIR /build
#
# Install SHINY SERVER
#

RUN apt-get update \
      && set -e \
      && apt install -y -t unstable $r_deps_shiny_server \
      && wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" \
      && VERSION=$(cat version.txt)  \
      && wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb \
      && gdebi -n ss-latest.deb \
      && rm -f version.txt ss-latest.deb \
      && rm -rf /srv/shiny-server \
      && mkdir -p /srv/shiny-server \
      && rm -rf /var/lib/apt/lists/* 

#
# Install packages
#
RUN apt-get update \
    && apt install -y -t unstable $r_deps_sys \
    && apt install -y -t unstable $r_deps_dev \
    && echo "\
    rep <- getOption('repos'); \
    rep['CRAN'] <- 'https://mran.microsoft.com/snapshot/"$r_packages_date"'; \
    options(repos = rep); \
    install.packages("$r_packages")" > install.R \
    && Rscript install.R \ 
    && apt-get purge -y --auto-remove $r_deps_dev \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove 

RUN echo "\
    #!/bin/sh \n
    exec shiny-server 2>&1 " > /usr/bin/shiny-server.sh \
    && cat /usr/bin/shiny-server.sh \
    && chmod +x /usr/bin/shiny-server.sh

COPY . /srv/shiny-server/lancy-dashboard

CMD ["sh","/usr/bin/shiny-server.sh"]

