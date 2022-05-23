FROM golang:1.18-alpine AS builder

RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/oauth2/

COPY . .

ENV GOSUMDB=off
COPY go.mod .
COPY go.sum .
RUN go mod download

RUN GOOS=linux GOARCH=amd64 go build -o /go/bin/oauth2

FROM alpine:3.13

RUN apk add --no-cache tzdata

COPY --from=builder /go/bin/oauth2 /go/bin/oauth2

ENTRYPOINT ["/go/bin/oauth2"]
