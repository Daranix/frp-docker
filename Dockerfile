FROM alpine

#LABEL MAINTAINER "Esteban Mayoral <contact@mpesteban.dev>"

ENV FRP_VERSION=v0.44.0

ADD entrypoint.sh /entrypoint.sh

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
 && mv frp_*_linux_amd64 /frp \
 && chown -R frp:frp /frp \
 && mv /entrypoint.sh /frp/

USER frp

WORKDIR /frp

EXPOSE 6000 7000

CMD ["/frp/entrypoint.sh"]