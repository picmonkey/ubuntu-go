FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
		autoconf \
		automake \
		build-essential \
		curl \
		git \
		gobject-introspection \
		gtk-doc-tools \
		imagemagick \
		libbz2-dev \
		libcurl4-openssl-dev \
		libevent-dev \
		libffi-dev \
		libgif-dev \
		libglib2.0-dev \
		libjpeg-turbo8-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libncurses-dev \
		libpng12-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		zlib1g-dev

RUN cd /tmp && git clone --depth 1 https://github.com/jcupitt/libvips.git \
    && cd libvips \
    && ./autogen.sh \
    && ./configure --enable-debug=no --without-python --without-fftw \
      --without-libgf --without-little-cms --without-orc \
      --without-pango --prefix=/usr \
    && make \
    && make install \
    && ldconfig

# Go
ENV GOLANG_VERSION 1.7
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

# clean up
RUN rm -rf /var/lib/apt/lists/*
