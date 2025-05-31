# Базовый образ с C++ инструментами
FROM ubuntu:22.04 AS builder

# Установка зависимостей
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Рабочая директория
WORKDIR /app

# Копирование только необходимых файлов для установки зависимостей
COPY deps.txt Makefile ./

# Установка зависимостей из deps.txt
RUN mkdir -p libs && \
    while IFS= read -r repo; do \
        repo_name="$$(basename "$$repo" .git)"; \
        echo "Cloning $$repo_name..."; \
        git clone --depth 1 "$$repo" "libs/$$repo_name"; \
    done < deps.txt

# Копирование остальных исходников
COPY . .

# Сборка проекта
RUN make compile

# Финальный образ
FROM ubuntu:22.04

# Установка runtime зависимостей
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libboost-system1.74 \
    libboost-thread1.74 \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Копирование бинарника из стадии сборки
COPY --from=builder /app/build/entrypoint /app/entrypoint

# Копирование статических файлов
COPY --from=builder /app/public /app/public

# Рабочая директория
WORKDIR /app

# Порт сервера
EXPOSE 8080

# Команда запуска
CMD ["./entrypoint"]
