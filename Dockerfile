FROM ubuntu:22.04 AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mkdir -p libs && \
    while read repo; do \
        repo_name=$$(basename "$$repo" .git); \
        echo "Cloning $$repo_name..."; \
        git clone --depth 1 "$$repo" "libs/$$repo_name"; \
    done < deps.txt

RUN make compile

FROM ubuntu:22.04

# Установка runtime зависимостей
RUN apt-get update && \
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
