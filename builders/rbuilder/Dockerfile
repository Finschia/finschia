FROM golang:1.18.5-bullseye

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get --no-install-recommends -y install \
    pciutils build-essential git wget \
    lsb-release dpkg-dev curl bsdmainutils fakeroot
RUN mkdir -p /usr/local/share/lbm/

# Deploy the shell functions library.
COPY buildlib.sh /usr/local/share/lbm/

# Create the 'builder' user.
RUN useradd -ms /bin/bash -U builder
ARG APP
ARG DEBUG
ARG TARGET_PLATFORMS
ENV APP ${APP:-app}
ENV DEBUG ${DEBUG}
ENV VERSION unknown
ENV COMMIT unknown
ENV LEDGER_ENABLED true
ENV TARGET_PLATFORMS ${TARGET_PLATFORMS:-linux/amd64}
ENV BUILD_SCRIPT ${BUILD_SCRIPT:-/sources/.release-build.sh}

# Drop root privileges.
USER builder:builder
WORKDIR /sources

# Mount the application's sources.
VOLUME [ "/sources" ]

# Run the application's build.sh.
ENTRYPOINT [ "/bin/bash", "-c", "${BUILD_SCRIPT}" ]
