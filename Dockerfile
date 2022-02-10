FROM alpine:3.13
RUN apk add --no-cache bash curl
COPY buildifier.sh /buildifier.sh
ENTRYPOINT ["/buildifier.sh"]
