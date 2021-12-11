FROM alpine

LABEL creator="SecorD | Let's Node"
LABEL url="https://t.me/letskynode — node Community"

WORKDIR minima

COPY minima_node.sh .

RUN apk add -U --no-cache wget bash openjdk11; \
	chmod +x minima_node.sh

EXPOSE 9001 9002

ENTRYPOINT ["./minima_node.sh"]

CMD ["-Xmx1G", "-jar", "/minima/minima.jar", "-data", "/minima/.minima", "-port", "9001", "-rpcenable", "-rpc", "9002", "-daemon"]
