FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
		autoconf \
		build-essential \
		imagemagick \
		libbz2-dev \
		libcurl4-openssl-dev \
		libevent-dev \
		libffi-dev \
		libglib2.0-dev \
		libjpeg-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libncurses-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		zlib1g-dev \
    git \
    curl


# libvibs requirements
RUN apt-get install -y automake \
    build-essential \
    git \
    gobject-introspection \
    libglib2.0-dev \
    libjpeg-turbo8-dev \
    libpng12-dev \
    gtk-doc-tools
RUN cd /tmp && git clone --depth 1 https://github.com/jcupitt/libvips.git \
    && cd libvips \
    && ./bootstrap.sh \
    && ./configure --enable-debug=no --without-python --without-fftw \
      --without-libexif --without-libgf --without-little-cms --without-orc \
      --without-pango --prefix=/usr
    && make \
    && sudo make install \
    && sudo ldconfig

# Go
ENV GOLANG_VERSION 1.4.2
RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
		| tar -v -C /usr/src -xz
RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1
ENV PATH /usr/src/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN go get github.com/tools/godep

# clean up
RUN rm -rf /var/lib/apt/lists/*
