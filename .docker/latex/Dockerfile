FROM debian:stretch-slim
# See https://github.com/blang/latex-docker for reference
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q \
    && apt-get install -qy python-pygments build-essential wget libfontconfig1 git \
    && rm -rf /var/lib/apt/lists/*

# Install TexLive with scheme-basic
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
	mkdir /install-tl-unx; \
	tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    echo "selected_scheme scheme-basic" >> /install-tl-unx/texlive.profile; \
	/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile; \
    rm -r /install-tl-unx; \
	rm install-tl-unx.tar.gz

ENV PATH="/usr/local/texlive/2019/bin/x86_64-linux:${PATH}"

RUN mkdir -p /img

ENV HOME /data
WORKDIR /data

RUN ls -ail /usr/local/texlive
# Install latex packages
RUN tlmgr install scheme-full

RUN luaotfload-tool --update

VOLUME ["/data"]
