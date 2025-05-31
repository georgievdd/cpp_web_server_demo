FROM ubuntu:22.04 AS builder

RUN sed -i 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    tree \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY deps.txt Makefile ./

RUN mkdir -p libs && \
    git clone https://github.com/CrowCpp/Crow.git libs/Crow && \
    git clone https://github.com/chriskohlhoff/asio.git libs/asio && \
    # Создаем символическую ссылку для правильного пути
    ln -s /app/libs/asio/asio/include /app/libs/asio/include

COPY . .

# Проверяем структуру
RUN echo "Проверка структуры:" && \
    ls -la /app/libs/Crow/include/crow.h && \
    ls -la /app/libs/asio/include/asio.hpp

# Собираем с явным указанием путей
RUN make CROW_INC="-I/app/libs/Crow/include" ASIO_INC="-I/app/libs/asio/include" compile

FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirror.yandex.ru/g' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libboost-system1.74 \
    libboost-thread1.74 \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/entrypoint /app/entrypoint
COPY --from=builder /app/public /app/public

WORKDIR /app
EXPOSE 8086
CMD ["./entrypoint"]
