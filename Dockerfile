FROM debian:latest

WORKDIR /root
ARG SIA_VERSION="1.2.2"

RUN apt-get update
RUN apt-get install -y wget ca-certificates unzip
RUN wget "https://github.com/NebulousLabs/Sia/releases/download/v${SIA_VERSION}/Sia-v${SIA_VERSION}-linux-amd64.zip" \
    && unzip "Sia-v${SIA_VERSION}-linux-amd64.zip"

FROM debian:latest

ARG SIA_VERSION="1.2.2"
COPY --from=0 /root/Sia-v${SIA_VERSION}-linux-amd64/siad /usr/bin/siad
