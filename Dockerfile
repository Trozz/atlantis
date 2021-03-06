FROM golang:alpine
RUN apk --no-cache add git make
RUN go get github.com/runatlantis/atlantis/

# The runatlantis/atlantis-base is created by docker-base/Dockerfile.
FROM runatlantis/atlantis-base:v2.0
LABEL authors="Anubhav Mishra, Luke Kysow"


# In the official Atlantis image we only have the latest of each Terrafrom version.
RUN AVAILABLE_TERRAFORM_VERSIONS="0.8.8 0.9.11 0.10.8 $(curl -s https://releases.hashicorp.com/terraform/ | cut -d '/' -f 3 | grep '^[0-9]' | grep -v '-' | head -n 1)" && \
    for VERSION in ${AVAILABLE_TERRAFORM_VERSIONS}; do \
        curl -LOks https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip && \
        curl -LOks https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_SHA256SUMS && \
        sed -n "/terraform_${VERSION}_linux_amd64.zip/p" terraform_${VERSION}_SHA256SUMS | sha256sum -c && \
        mkdir -p /usr/local/bin/tf/versions/${VERSION} && \
        unzip terraform_${VERSION}_linux_amd64.zip -d /usr/local/bin/tf/versions/${VERSION} && \
        ln -s /usr/local/bin/tf/versions/${VERSION}/terraform /usr/local/bin/terraform${VERSION} && \
        rm terraform_${VERSION}_linux_amd64.zip && \
        rm terraform_${VERSION}_SHA256SUMS; \
    done && \
    ln -s /usr/local/bin/tf/versions/$(curl -s https://releases.hashicorp.com/terraform/ | cut -d '/' -f 3 | grep '^[0-9]' | grep -v '-' | head -n 1)/terraform /usr/local/bin/terraform

# copy binary
COPY --from=0 /go/bin/atlantis /usr/local/bin/atlantis

# copy docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["server"]
