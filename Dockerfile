FROM alpine:latest AS base
LABEL maintainer="UmkaDK <umka.dk@icloud.com>"
RUN apk --no-cache upgrade

FROM base AS build
RUN apk --no-cache add \
        build-base \
        git \
        cmake \
        libuv-dev \
        libmicrohttpd-dev
WORKDIR /tmp/build
RUN git clone https://github.com/xmrig/xmrig .
RUN sed -i -E 's/(k(Minimum|Default)DonateLevel) = [[:digit:]];$/\1 = 0;/' ./src/donate.h
RUN cmake -DCMAKE_BUILD_TYPE=Release \
    && make

FROM base AS xmrig
RUN addgroup xmrig && adduser -S -D -H -s /bin/false -g xmrig xmrig
RUN apk --no-cache add libmicrohttpd
COPY --from=build --chown=xmrig /tmp/build/xmrig /usr/local/bin/xmrig
COPY --chown=xmrig ./config.json /usr/local/etc/xmrig.json

EXPOSE 80
USER xmrig
ENTRYPOINT ["xmrig"]
CMD ["--config=/usr/local/etc/xmrig.json"]
