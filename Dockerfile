FROM alpine:3.13

ARG BUILDIFIER_VERSION="4.0.1"

COPY buildifier.sh /buildifier.sh

RUN apk --no-cache add bash curl \
  && curl -f -L -o /usr/bin/buildifier \
    "https://github.com/bazelbuild/buildtools/releases/download/${BUILDIFIER_VERSION}/buildifier" \
  && chmod +x /usr/bin/buildifier \
  && apk del curl

ENTRYPOINT ["/buildifier.sh"]
