FROM alpine

#LABEL MAINTAINER "Esteban Mayoral <contact@mpesteban.dev>"

ARG FRP_VERSION=0.44.0

COPY --chown=frp:frp entrypoint.sh /frp/entrypoint.sh

RUN echo "Fetching version ${FRP_VERSION}"
RUN PLATARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && echo "Platform: ${PLATARCH}"
RUN addgroup -S frp \
 && adduser -D -S -h /var/frp -s /sbin/nologin -G frp frp \
 && apk add --no-cache curl \
 && echo "Fetching version ${FRP_VERSION}" \
 && PLATARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
 && echo "Platform: ${PLATARCH}" \
 && curl -fSL https://github.com/fatedier/frp/releases/download/${FRP_VERSION}/frp_${FRP_VERSION:1}_linux_${PLATARCH}.tar.gz -o frp.tar.gz \
 && tar -zxv -f frp.tar.gz \
 && rm -rf frp.tar.gz \
 && mv frp_*_linux_*/* /frp/ \
 && chown -R frp:frp /frp 

USER frp
RUN ["chmod", "+x", "/frp/entrypoint.sh"]

WORKDIR /frp

ENTRYPOINT ["/frp/entrypoint.sh"]