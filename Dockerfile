FROM ubuntu:18.04

RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

RUN apt-get update && apt-get install -y \
  make \
  wget \
  curl \
  sqlite3 \
  libsqlite3-dev \
  flex \
  ruby-full \
  libssl-dev \
  libssh2-1-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q https://colebrokamp-dropbox.s3.amazonaws.com/geocoder.db -P /opt

RUN wget -q https://colebrokamp-dropbox.s3.amazonaws.com/NHGIS_US_census_tracts_5072_simplefeatures.rds -P /opt

RUN wget -q https://github.com/cole-brokamp/dep_index/raw/master/ACS_deprivation_index_by_census_tracts.rds -P /opt

 RUN apt-get update && apt-get install -y apt-file \
   && apt-file update \
   && apt-get install software-properties-common -y \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install sqlite3

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt-get update \
   && export DEBIAN_FRONTEND=noninteractive \
   && apt-get install r-base-core --no-install-recommends -y --force-yes \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'options(repos=c(CRAN = "https://cran.rstudio.com/"), download.file.method="wget")' >> /etc/R/Rprofile.site

RUN R -e "install.packages(c('tidyverse', 'stringr'))"

RUN R -e "install.packages(c('jsonlite', 'argparser'))"

RUN R -e "install.packages('remotes'); remotes::install_github('cole-brokamp/CB')"

RUN apt-get update && apt-get install -y \
  bison \
  byacc \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  liblwgeom-dev \
  libudunits2-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  gfortran \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN R -e "install.packages('sf')"

RUN mkdir /root/geocoder

COPY . /root/geocoder
RUN chmod +x /root/geocoder/geocode.rb

RUN cd /root/geocoder \
  && make install \
  && gem install Geocoder-US-2.0.4.gem

RUN chmod +x /root/geocoder/geocode.R

ENTRYPOINT ["root/geocoder/geocode.R"]
