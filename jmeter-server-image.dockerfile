FROM centos:centos7.9.2009

# docker build -t yaman-jmeter-node-container --no-cache=true .
# docker scan --accept-license
# docker build --file jmeter-server-image.dockerfile -t yaman-jmeter-node-container --no-cache=false --build-arg build_job_name=yaman-ci-build-jmeter-image --build-arg build_job_number=1 --build-arg build_date=2016-12-25 .

########################################
## Argumentos/Parametros
########################################
ARG build_job_name
ARG build_job_number
ARG build_date
ARG TZ=America/Sao_Paulo

EXPOSE 5000/tcp
EXPOSE 5000/udp
EXPOSE 2000/tcp
EXPOSE 2000/udp

########################################
## Configuracao de Ambiente
########################################
ENV JAVA_HOME=/opt/yaman/java/jdk-11.0.18+10
ENV JMETER_HOME=/opt/yaman/jmeter/apache-jmeter-5.5
ENV PATH=${PATH}:${JAVA_HOME}/bin:${JMETER_HOME}/bin

########################################
## Custom Shell
########################################
#SHELL ["/bin/bash", "-c"]

########################################
## Custom Labels
########################################
LABEL author="Yaman Tecnologia LTDA"
LABEL version=${build_job_number}
LABEL releaseDate=${build_date}
LABEL desc="Image developed and customized for Yaman customers"
LABEL website="https://yaman.com.br"
LABEL registry="https://registry.yaman.com.br"
LABEL org.label-schema.schema-version=${build_job_number}
LABEL org.label-schema.name="Yaman JMeter Image"
LABEL org.label-schema.vendor="Yaman Tecnologia LTDA"
LABEL org.label-schema.license="Todos os direitos reservados"
LABEL org.label-schema.build-date=${build_date}
LABEL org.opencontainers.image.title="Yaman - JMeter Image"
LABEL org.opencontainers.image.vendor="CentOS"
LABEL org.opencontainers.image.licenses="GPL-2.0-only"
LABEL org.opencontainers.image.created=${build_date}

########################################
## Contexto do Container
########################################
RUN /bin/bash -c 'yum -y update'
RUN /bin/bash -c 'echo ${build_job_name}'
RUN /bin/bash -c 'echo ${build_job_number}'
RUN /bin/bash -c 'echo ${build_date}'
RUN /bin/bash -c 'echo ${TZ}'

########################################
### Configure Timezone
########################################
RUN /bin/bash -c 'ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo $TZ > /etc/timezone'

########################################
### Softwares Adicionais
########################################
RUN /bin/bash -c 'yum -y install vim wget zip net-tools git'

########################################
### Pastas
########################################
RUN /bin/bash -c 'cd / && mkdir -p /opt/yaman/'
RUN /bin/bash -c 'cd / && mkdir -p /opt/yaman/java/'
RUN /bin/bash -c 'cd / && mkdir -p /opt/yaman/jmeter/'
RUN /bin/bash -c 'cd / && mkdir -p /opt/yaman/scripts/'
RUN /bin/bash -c 'cd / && mkdir -p /opt/yaman/outputs/'

########################################
### Configuracao do Java
########################################
RUN /bin/bash -c 'cd /opt/yaman/java/ && wget https://publicsre.blob.core.windows.net/sre-public-tools/microsoft-jdk-11.0.18-linux-x64.tar.gz && tar -xvf microsoft-jdk-11.0.18-linux-x64.tar.gz'
RUN /bin/bash -c 'cd /opt/yaman/java/ && rm -rf microsoft-jdk-11.0.18-linux-x64.tar.gz'
RUN /bin/bash -c 'cd /opt/yaman/java/ && chmod -R 775 *'
RUN /bin/bash -c 'cd /etc/profile.d/'

RUN echo -e '\
export JAVA_HOME=/opt/yaman/java/jdk-11.0.18+10\n\
export PATH=PATH:JAVA_HOME/bin'\
>> /etc/profile.d/JAVA_HOME.sh

RUN /bin/bash -c "sed -i 's|PATH:JAVA_HOME/bin|\$PATH:\$JAVA_HOME/bin|g' /etc/profile.d/JAVA_HOME.sh"
RUN /bin/bash -c "cd /etc/profile.d/ && chmod -R 775 /etc/profile.d/JAVA_HOME.sh"

########################################
### Configuracao do JMeter
########################################
RUN /bin/bash -c 'cd /opt/yaman/jmeter/'
RUN /bin/bash -c 'cd /opt/yaman/jmeter/ && wget https://publicsre.blob.core.windows.net/sre-public-tools/apache-jmeter-5.5.tgz && tar -xvf apache-jmeter-5.5.tgz'
RUN /bin/bash -c 'cd /opt/yaman/jmeter/ && rm -rf apache-jmeter-5.5.tgz'
RUN /bin/bash -c 'cd /opt/yaman/jmeter/ && chmod -R 775 *'
RUN /bin/bash -c 'cd /etc/profile.d/'

RUN echo -e '\
export JMETER_HOME=/opt/yaman/jmeter/apache-jmeter-5.5\n\
export PATH=PATH:JMETER_HOME/bin'\
>> /etc/profile.d/JMETER_HOME.sh

RUN /bin/sh -c "sed -i 's|PATH:JMETER_HOME|\$PATH:\$JMETER_HOME|g' /etc/profile.d/JMETER_HOME.sh"
RUN /bin/bash -c 'cd /etc/profile.d/ && chmod -R 775 /etc/profile.d/JMETER_HOME.sh'

RUN /bin/sh -c "cp -r -a \$JMETER_HOME/bin/jmeter.properties \$JMETER_HOME/bin/jmeter-properties.original"
#RUN /bin/sh -c "cp -r -a \$JMETER_HOME/bin/jmeter-server.properties \$JMETER_HOME/bin/jmeter-server.original"

RUN /bin/sh -c "cd \$JMETER_HOME/bin/ "

RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.output_format=csv|jmeter.save.saveservice.output_format=csv|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.time=true|jmeter.save.saveservice.time=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.response_message=true|jmeter.save.saveservice.response_message=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.successful=true|jmeter.save.saveservice.successful=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.sent_bytes=true|jmeter.save.saveservice.sent_bytes=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.filename=false|jmeter.save.saveservice.filename=false|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.encoding=false|jmeter.save.saveservice.encoding=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.idle_time=true|jmeter.save.saveservice.idle_time=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.label=true|jmeter.save.saveservice.label=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.thread_name=true|jmeter.save.saveservice.thread_name=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.assertions=true|jmeter.save.saveservice.assertions=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.thread_counts=true|jmeter.save.saveservice.thread_counts=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.latency=true|jmeter.save.saveservice.latency=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.hostname=false|jmeter.save.saveservice.hostname=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.response_code=true|jmeter.save.saveservice.response_code=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.data_type=true|jmeter.save.saveservice.data_type=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.bytes=true|jmeter.save.saveservice.bytes=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.subresults=true|jmeter.save.saveservice.subresults=false|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.url=true|jmeter.save.saveservice.url=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.connect_time=true|jmeter.save.saveservice.connect_time=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.sample_count=false|jmeter.save.saveservice.sample_count=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.assertion_results_failure_message=true|jmeter.save.saveservice.assertion_results_failure_message=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#jmeter.save.saveservice.print_field_names=true|jmeter.save.saveservice.print_field_names=true|g' \$JMETER_HOME/bin/jmeter.properties "

RUN /bin/sh -c "sed -i 's|#server.rmi.ssl.disable=false|server.rmi.ssl.disable=true|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#server_port=1099|server_port=2000|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#server.rmi.port=1234|server.rmi.port=2000|g' \$JMETER_HOME/bin/jmeter.properties "
RUN /bin/sh -c "sed -i 's|#server.rmi.localport=4000|server.rmi.localport=5000|g' \$JMETER_HOME/bin/jmeter.properties "

RUN /bin/sh -c "sed -i '54i JVM_ARGS=\"-Xms512m -Xmx512m -XX:+DisableExplicitGC\"' \$JMETER_HOME/bin/jmeter"
RUN /bin/sh -c "sed -i '32i JVM_ARGS=\"-Xms512m -Xmx512m -XX:+DisableExplicitGC\"' \$JMETER_HOME/bin/jmeter.sh"

RUN echo -e '\
[Unit]\
Description=Jmeter-Server - Run Jmeter-Server\
After=network.target\
StartLimitIntervalSec=0\
[Service]\
Type=idle\
User=root\
ExecStart=/opt/yaman-jmeter/apache-jmeter-5.5/bin/jmeter-server\
\
[Install]\
WantedBy=multi-user.target'\
>> /etc/systemd/system/jmeter-server.service

# Adicionando client
RUN curl -fsSLO 'https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz'

ADD bot.sh /opt/yaman/scripts

########################################
### Execution
########################################
#CMD ["/bin/bash","-c","tail -f /dev/null"]
CMD ["/bin/bash","-c","tail -f /dev/null"]