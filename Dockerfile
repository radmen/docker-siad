FROM debian:latest

ARG SIA_VERSION="1.2.2"

WORKDIR /root

RUN apt-get update
RUN apt-get install -y wget ca-certificates unzip
RUN wget "https://github.com/NebulousLabs/Sia/releases/download/v${SIA_VERSION}/Sia-v${SIA_VERSION}-linux-amd64.zip" \
    && unzip "Sia-v${SIA_VERSION}-linux-amd64.zip" \
    && mv "Sia-v${SIA_VERSION}-linux-amd64" "Sia"

FROM node:8.1-wheezy

WORKDIR /usr/src/app

COPY --from=0 /root/Sia/siad /usr/bin/siad

RUN mkdir -p /usr/src/app /siad/data
COPY ["node-proxy/package.json", "node-proxy/package-lock.json", "/usr/src/app/"]
RUN npm i

COPY node-proxy /usr/src/app

EXPOSE 80
VOLUME "/siad/data"

ENTRYPOINT ["node", "/usr/src/app/index.js"]
