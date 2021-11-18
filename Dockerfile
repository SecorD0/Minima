FROM ubuntu

LABEL creator="SecorD | Let's Node"
LABEL url="https://t.me/letskynode — node Community"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=UTC


RUN apt update && \
    apt upgrade -y && \
    apt install wget openjdk-11-jre-headless -y; \
    apt clean; \
    wget -qO minima.jar https://github.com/minima-global/Minima/raw/master/jar/minima.jar

EXPOSE 9001 9002 9003 9004

ENTRYPOINT ["java"]

CMD ["-Xmx1G", "-jar", "minima.jar", "-port", "9001", "-daemon"]