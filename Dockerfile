FROM python:3.13.6-alpine3.22

ARG TARGETPLATFORM
ENV TZ=Asia/Shanghai

RUN apk add --no-cache \
    ca-certificates \
    curl \
    unzip \
    tzdata \
    gcompat \
    libstdc++ \
 && cp /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo "$TZ" > /etc/timezone \
 && apk del tzdata \
 && rm -rf \
        /var/cache/apk/* \
        /etc/apk/cache/* \
        /tmp/* \
        /var/tmp/*

RUN set -ex; \
    case ${TARGETPLATFORM} in \
        "linux/386") FILE="v2ray-linux-32.zip" ;; \
        "linux/amd64") FILE="v2ray-linux-64.zip" ;; \
        "linux/arm/v7") FILE="v2ray-linux-arm32-v7a.zip" ;; \
        "linux/arm64/v8") FILE="v2ray-linux-arm64-v8a.zip" ;; \
        # "linux/ppc64le") FILE="v2ray-linux-ppc64le.zip" ;; \
        # "linux/s390x") FILE="v2ray-linux-s390x.zip" ;; \
        "linux/riscv64") FILE="v2ray-linux-riscv64.zip" ;; \
        *) echo "Unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac; \
    curl -L -o v2ray.zip "https://github.com/v2fly/v2ray-core/releases/latest/download/$FILE"; \
    unzip v2ray.zip -d /usr/local/bin/; \
    chmod +x /usr/local/bin/v2ray; \
    rm v2ray.zip; \
    mkdir -p /etc/v2ray

RUN pip install --no-cache-dir flask

WORKDIR /app
COPY templates/ /app/templates/
COPY ./app.py /app/app.py
RUN chmod +x /app/app.py

EXPOSE 5000 1080 8080

CMD ["python", "app.py"]