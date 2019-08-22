FROM golang:1.12

RUN go get -u -v gitlab.com/NebulousLabs/Sia/...

FROM node:8.1-slim

WORKDIR /usr/src/app

COPY --from=0 /go/bin/siad /usr/bin/siad
COPY --from=0 /go/bin/siac /usr/bin/siac

RUN mkdir -p /usr/src/app /siad/data
COPY ["node-proxy/package.json", "node-proxy/package-lock.json", "/usr/src/app/"]
RUN npm i && npm cache clean --force

COPY node-proxy /usr/src/app

EXPOSE 9980
EXPOSE 9981
EXPOSE 9982

VOLUME "/siad/data"

ENTRYPOINT ["node", "/usr/src/app/index.js"]
