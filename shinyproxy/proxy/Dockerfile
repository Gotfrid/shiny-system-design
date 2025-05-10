ARG OPENJDK_VERSION="17"

FROM openjdk:${OPENJDK_VERSION}

ARG SHINYPROXY_VERSION="3.1.1"

RUN mkdir -p /opt/shinyproxy/
WORKDIR /opt/shinyproxy/

RUN curl "https://www.shinyproxy.io/downloads/shinyproxy-${SHINYPROXY_VERSION}.jar" -o /opt/shinyproxy/shinyproxy.jar

COPY . .

CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
