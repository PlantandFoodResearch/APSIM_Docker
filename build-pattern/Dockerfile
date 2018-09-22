## NOTE: this uses the legacy build pattern as in "What was the builder pattern?" https://blog.alexellis.io/mutli-stage-docker-builds/

## TODO: use ENV to specify a different Apsim release

# Runtime Container

FROM ubuntu:xenial
MAINTAINER eric.burgueno@plantandfood.co.nz

## Install and configure packages in the common layer
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/ubuntu wheezy/snapshots/4.8.0 main" | tee /etc/apt/sources.list.d/mono-official.list && \
  apt-get update && \
  apt-get -y install tzdata mono-runtime libboost-all-dev libxml2 tcl8.5 r-recommended && \
  ln -fs /usr/share/zoneinfo/Pacific/Auckland /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
  Rscript -e 'install.packages(c("Rcpp", "RInside", "inline"),repos = "http://cran.us.r-project.org")'

## Get built artifact and extract
### /apsim needs to have 755 permissions so that non-privileged users can use the container
COPY Apsim.binaries.LINUX.X86_64.exe /tmp/apsim-release.exe
RUN /tmp/apsim-release.exe -y -o/apsim && \
  rm -f /tmp/apsim-release.exe && \
  chmod 755 apsim

WORKDIR /apsim/Temp/Model

## This allows users to call the container directly with the name of the .exe file they want to run (Apsim.exe, ApsimToSim.exe, etc)
ENTRYPOINT ["/usr/bin/mono"]
