FROM golang:1.18.9-bullseye

RUN apt update && \
    apt upgrade && \
    apt install -y \
        build-essential

RUN mkdir /lbm
RUN useradd -ms /bin/bash -U lbm
USER lbm:lbm
WORKDIR /lbm

ENV APP ${APP:-simd}
ENV DEBUG ${DEBUG}
ENV VERSION unknown
ENV COMMIT unknown
ENV LEDGER_ENABLED true
ENV TARGET_PLATFORMS ${TARGET_PLATFORMS:-linux/amd64}

VOLUME [ "/lbm" ]
ENTRYPOINT [ "/bin/bash" ]
