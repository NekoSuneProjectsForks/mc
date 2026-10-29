# syntax=docker/dockerfile:1.7
FROM --platform=$BUILDPLATFORM golang:1.24-alpine AS builder
ARG TARGETOS=linux
ARG TARGETARCH
WORKDIR /src
RUN apk add --no-cache ca-certificates
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod go mod download
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -trimpath -tags kqueue -ldflags="-s -w" -o /out/mc .

FROM alpine:3.22
RUN apk add --no-cache ca-certificates && mkdir -p /config
COPY --from=builder /out/mc /usr/local/bin/mc
COPY LICENSE CREDITS /licenses/
ENV MC_CONFIG_DIR=/config
VOLUME ["/config"]
ENTRYPOINT ["/usr/local/bin/mc"]
CMD ["--help"]
