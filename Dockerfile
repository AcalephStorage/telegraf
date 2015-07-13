FROM google/golang:1.4
MAINTAINER Acaleph <admin@acale.ph>

ENV INFLUXDB_HOSTNAME 192.168.12.10
ENV INFLUXDB_PORT  8086
ENV DB_NAME telegraf
ENV DB_USERNAME admin
ENV DB_PASSWORD admin
ENV INTERVAL 10s
ENV DEBUG true
ENV CEPH_PLUGIN true
ENV CPU_PLUGIN true
ENV CPU_PLUGIN true
ENV DISK_PLUGIN false
ENV DOCKER_PLUGIN true
ENV IO_PLUGIN false
ENV MEM_PLUGIN false
ENV MYSQL_PLUGIN false
ENV NET_PLUGIN false
ENV POSTGRESQL_PLUGIN true
ENV REDIS_PLUGIN false
ENV SWAP_PLUGIN false
ENV SYSTEM_PLUGIN true
ENV PROCDIR "/proc"

VOLUME ["var/run/ceph","usr/bin/ceph"]
WORKDIR /gopath/src/telegraf
ADD . /gopath/src/telegraf

RUN go get telegraf/cmd/telegraf
RUN chmod 777 /gopath/src/telegraf/telegraf-config.sh
ENTRYPOINT /gopath/src/telegraf/telegraf-config.sh

