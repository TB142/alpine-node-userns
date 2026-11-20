# Name: alpine-node-userns, a generic node jam-box. Buils by GH Actions (weekly + manual).
# Minimal opinionated with no baked users. Persistence to live in ./<data>:/home bind-mount.
# Privileges and capabilities may be handled in compose.

FROM alpine:3.22

RUN apk add --no-cache \
      nodejs \
      npm \
      bash \
      curl \
      unzip \
      jq \
      git \
      openssh-client \
      openssh-server \
      ca-certificates \
      tini

# The only two dirs this image promises. Owned by the runtime uid;
# no passwd entry is created — uid 1000 exists only numerically.
RUN mkdir -p /home/service/space && chown -R 1000:1000 /home/service

# No /etc/passwd entry means node/npm need HOME spelled out.
# PATH expansion inside ENV is legal Containerfile syntax
ENV HOME=/home
ENV NPM_CONFIG_PREFIX=/home/service/.npm-global
ENV PATH=/home/service/.npm-global/bin:$PATH

WORKDIR /home/service/space

# Container idles; the operator execs in.
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["sleep", "infinity"]
