
FROM picoded/ubuntu-base AS builder

MAINTAINER David Lafia <davidlafia@yahoo.fr>

RUN apt-get update && \
	apt-get install -y maven && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y git && \
	apt-get install -f libpng16-16 && \
	apt-get install -f libjasper1 && \
	apt-get install -y libdc1394-22 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/oracle-jdk8-installer;
	

RUN git clone https://github.com/barais/TPDockerSampleApp
WORKDIR ./TPDockerSampleApp/
RUN mvn install:install-file -Dfile=./lib/opencv-3410.jar \
     -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar


RUN mvn package

FROM openjdk:8
COPY --from=builder /workspace/TPDockerSampleApp/target/fatjar-0.0.1-SNAPSHOT.jar .
COPY --from=builder /workspace/TPDockerSampleApp/lib .
RUN apt-get update && \
        apt-get install -f libpng16-16 && \
        apt-get install -y libdc1394-22 ;
CMD ["java","-Djava.library.path=ubuntuupperthan18/", "-jar", "fatjar-0.0.1-SNAPSHOT.jar"]

