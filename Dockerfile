FROM ubuntu:22.04 AS builder

RUN sed -i 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    tree

WORKDIR /app

COPY deps.txt Makefile ./

RUN mkdir -p libs && \
    git clone https://github.com/CrowCpp/Crow.git libs/Crow && \
    git clone https://github.com/chriskohlhoff/asio.git libs/asio && \
    ln -s /app/libs/asio/asio/include /app/libs/asio/include

COPY . .

RUN make CROW_INC="-I/app/libs/Crow/include" ASIO_INC="-I/app/libs/asio/include" compile

FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libboost-system1.74 \
    libboost-thread1.74 \
    libatomic1

COPY --from=builder /app/build/enrtypoint /app/entrypoint
COPY --from=builder /app/public /app/public

WORKDIR /app
EXPOSE 8086
CMD ["./entrypoint"]
