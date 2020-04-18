FROM golang:latest

ENV GO111MODULE on

RUN go get github.com/reviewdog/reviewdog/cmd/reviewdog

COPY scripts/reviewdog-entrypoint.sh /app/reviewdog-entrypoint.sh

ENTRYPOINT ["/app/reviewdog-entrypoint.sh"]