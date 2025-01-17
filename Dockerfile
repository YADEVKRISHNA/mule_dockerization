
FROM java:openjdk-8-jdk
FROM maven:3.6.0-jdk-11-slim 

RUN mkdir mule

ADD hello-world /mule 
#ADD mule-ee-distribution-standalone-4.3.0.zip /mule
RUN echo "<--------------Downloading mule runtime engine------------->"
#ADD https://mule-runtime.s3.amazonaws.com/mule-ee-distribution-standalone-4.3.0.zip /mule
ADD https://s3.amazonaws.com/new-mule-artifacts/mule-ee-distribution-standalone-4.3.0-20210119.zip /mule

WORKDIR /mule
RUN echo "<--------------Extracting Mule Engine-------------->"
#RUN unzip mule-ee-distribution-standalone-4.3.0.zip && rm mule-ee-distribution-standalone-4.3.0.zip
RUN unzip mule-ee-distribution-standalone-4.3.0-20210119.zip && rm mule-ee-distribution-standalone-4.3.0-20210119.zip
#RUN echo "<--------------Setting up mule runtime agent-------------->"
#RUN ./mule-enterprise-standalone-4.3.0-20210119/bin/amc_setup -H c3eb1c77-2401-4cf1-ae7d-37c7100e2061---506683 ec2-runtime-container
RUN echo "<--------------Packaging mule application and adding to runtime Engine------------->"
RUN mvn clean -Dskiptests package && mv target/hello-world-1.0.0-SNAPSHOT-mule-application.jar mule-enterprise-standalone-4.3.0-20210119/apps/hello-world.jar && rm pom.xml mule-artifact.json -rf target src

#VOLUME ["/mule/mule-enterprise-standalone-4.3.0/logs", "/mule/mule-enterprise-standalone-4.3.0/apps", "/mule/mule-enterprise-standalone-4.3.0/domains"]
VOLUME ["/mule/mule-enterprise-standalone-4.3.0-20210119/logs", "/mule/mule-enterprise-standalone-4.3.0-20210119/apps", "/mule/mule-enterprise-standalone-4.3.0-20210119/domains"]

RUN echo "<-------------Exposing port-------------->"
EXPOSE 8081
CMD ["./mule-enterprise-standalone-4.3.0-20210119/bin/mule"]

