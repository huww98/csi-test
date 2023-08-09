# syntax=docker/dockerfile:1.4
FROM golang:1.20.7-bookworm as builder

WORKDIR /usr/src/app
RUN --mount=type=bind,target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    make BINARY=/out/csi-sanity

FROM debian:bookworm-20230725-slim
COPY --link --from=builder /out/csi-sanity /usr/local/bin/csi-sanity

ENTRYPOINT ["/usr/local/bin/csi-sanity"]
CMD ["-csi.endpoint", "/tmp/test-csi.sock", "-csi.testvolumesize", "21474836480"]
