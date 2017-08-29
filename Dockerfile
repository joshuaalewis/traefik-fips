FROM alpine:edge as builder
RUN apk --update upgrade && apk add ca-certificates && update-ca-certificates
WORKDIR /dist/
ADD https://github.com/containous/traefik/releases/download/v1.4.0-rc1/traefik /dist/
RUN chmod +x /dist/traefik

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /dist/traefik .
EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="v1.4.0-rc1" \
      org.label-schema.docker.schema-version="1.0"
