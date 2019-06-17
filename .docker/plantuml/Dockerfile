FROM openjdk:11-jre-slim
ENV PLANTUML_VERSION=1.2019.6

RUN apt-get update && apt-get install -y graphviz wget
RUN mkdir -p /app/data && chmod -R 777 /app/data
RUN mkdir -p /opt/plantuml && chmod -R 777 /opt/plantuml
RUN wget "http://downloads.sourceforge.net/project/plantuml/${PLANTUML_VERSION}/plantuml.${PLANTUML_VERSION}.jar" -O /opt/plantuml/plantuml.jar

WORKDIR /app/data
CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/plantuml/plantuml.jar", "./plantuml", "-o", "../img"]

