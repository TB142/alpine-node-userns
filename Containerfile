# alpine-node-userns — generic node jam-box, image-built system, ephemeral apk.
# Built by GH Actions (weekly + manual). Minimal tooling, no baked users,
# no entrypoint. Persistence lives in bind-mounted /home/service.

FROM alpine:3.22
# TODO: pin by digest (@sha256:…) for reproducibility; note a pinned digest
# does NOT float the base on weekly rebuilds — that takes a bump bot
# (renovate/dependabot). As-is, the minor tag floats within 3.22.x.

# nodejs on alpine is the LTS line of that release; check what the pinned
# release actually ships (apk policy nodejs) — if you need newer, there's
# nodejs-current. Decide deliberately, then it stays stable per release.
RUN apk add --no-cache \
      nodejs \
      npm \
      bash \
      git \
      openssh-client \
      ca-certificates

# The only two dirs this image promises. Owned by the runtime uid;
# no passwd entry is created — uid 1000 exists only numerically.
RUN mkdir -p /home/service /space && chown -R 1000:1000 /home/service /space

# No /etc/passwd entry means node/npm need HOME spelled out.
# PATH expansion inside ENV is legal Containerfile syntax — this is what
# kills the compose literal-PATH hack.
ENV HOME=/home/service
ENV NPM_CONFIG_PREFIX=/home/service/.npm-global
ENV PATH=/home/service/.npm-global/bin:$PATH

WORKDIR /space

# Container idles; the operator execs in.
CMD ["sleep", "infinity"]
