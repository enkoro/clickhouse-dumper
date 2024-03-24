FROM oraclelinux:9
RUN yum install pigz
WORKDIR /usr/bin
RUN curl https://clickhouse.com/ | sh && clickhouse --help
WORKDIR /app
COPY dump.sh .