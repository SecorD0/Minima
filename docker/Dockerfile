FROM alpine

LABEL creator="SecorD | Let's Node"
LABEL url="https://t.me/letskynode — node Community"

WORKDIR root

COPY entrypoint.sh .

RUN apk add -U --no-cache wget bash openjdk11

EXPOSE 9001 9002

ENTRYPOINT ["./entrypoint.sh"]

CMD ["-Xmx1G", "-jar", "/root/minima.jar", "-data", "/root/.minima", "-port", "9001", "-rpcenable", "-rpc", "9002", "-daemon"]
