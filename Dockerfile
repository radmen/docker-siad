FROM golang:1.8

RUN go get -u -v github.com/NebulousLabs/Sia/...

FROM node:8.1-wheezy

WORKDIR /usr/src/app

COPY --from=0 /go/bin/siad /usr/bin/siad
COPY --from=0 /go/bin/siac /usr/bin/siac

RUN mkdir -p /usr/src/app /siad/data
COPY ["node-proxy/package.json", "node-proxy/package-lock.json", "/usr/src/app/"]
RUN npm i

COPY node-proxy /usr/src/app

EXPOSE 80
VOLUME "/siad/data"

ENTRYPOINT ["node", "/usr/src/app/index.js"]
