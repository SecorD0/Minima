FROM alpine

LABEL creator="SecorD | Let's Node"
LABEL url="https://t.me/letskynode — node Community"

RUN apk add -U --no-cache openjdk11

EXPOSE 9001 9002 9003 9004

ENTRYPOINT ["java"]

CMD ["-Xmx1G", "-jar", "/root/.minima/minima.jar", "-data", "/root/.minima", "-port", "9001", "-rpcenable", "-rpc", "9002", "-daemon"]
