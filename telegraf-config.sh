#!/bin/bash

output="/telegraf.toml"
cat <<BASIC > $output
# Telegraf configuration

# If this file is missing an [agent] section, you must first generate a
# valid config with 'telegraf -sample-config > telegraf.toml'

# Telegraf is entirely plugin driven. All metrics are gathered from the
# declared plugins.

# Even if a plugin has no configuration, it must be declared in here
# to be active. Declaring a plugin means just specifying the name
# as a section with no variables. To deactivate a plugin, comment
# out the name and any variables.

# Use 'telegraf -config telegraf.toml -test' to see what metrics a config
# file would generate.

# One rule that plugins conform to is wherever a connection string
# can be passed, the values '' and 'localhost' are treated specially.
# They indicate to the plugin to use their own builtin configuration to
# connect to the local system.

# NOTE: The configuration has a few required parameters. They are marked
# with 'required'. Be sure to edit those to make this configuration work.

# Configuration for influxdb server to send metrics to
[influxdb]
url = "http://$INFLUXDB_HOSTNAME:$INFLUXDB_PORT" # required.
database = "$DB_NAME" # required. The target database for metrics. This database must already exist
username = "$DB_USERNAME"
password = "$DB_PASSWORD"

# Tags can also be specified via a normal map, but only one form at a time:

# Configuration for telegraf itself
[agent]
interval = "$INTERVAL"
debug = $DEBUG
BASIC

PLUGINS
if [[ "$CEPH_PLUGIN" == "true" ]]; then 
cat <<CEPH >> $output
# Read metrics about ceph clusters
[ceph]
cluster = "ceph"
binLocation = "/var/ceph"
socketDir = "/var/run/ceph"
CEPH
fi

if [ "$CPU_PLUGIN" = true ]; then
cat <<CPU >> $output
# Read metrics about cpu usage
[cpu]
  # no configuration
CPU
fi

if [ "$DISK_PLUGIN" = true ]; then
cat <<DISK >> $output
# Read metrics about disk usage by mount point
[disk]
  # no configuration
DISK
fi

if [ "$DOCKER_PLUGIN" = true ]; then
cat <<DOCKER >> $output
# Read metrics about docker containers
[docker]
  # no configuration
DOCKER
fi

if [ "$IO_PLUGIN" = true ]; then
cat <<IO >> $output
# Read metrics about disk IO by device
[io]
  # no configuration
IO
fi

if [ "$MEM_PLUGIN" = true ]; then
cat <<MEMORY >> $output	
# Read metrics about memory usage
[mem]
  # no configuration
MEMORY
fi

if [ "$MYSQL_PLUGIN" = true ]; then
cat <<MYSQL >> $output	
# Read metrics from one or many mysql servers
[mysql]

# specify servers via a url matching:
#  [username[:password]@][protocol[(address)]]/[?tls=[true|false|skip-verify]]
#  e.g. root:root@http://10.0.0.18/?tls=false
#
# If no servers are specified, then localhost is used as the host.
servers = ["localhost"]
MYSQL
fi

if [ "$NET_PLUGIN" = true ]; then
cat <<NET >> $output
# Read metrics about network interface usage
[net]

# By default, telegraf gathers stats from any up interface (excluding loopback)
# Setting interfaces will tell it to gather these explicit interfaces,
# regardless of status.
#
# interfaces = ["eth0", ... ]
NET
fi

if [ "$POSTGRESQL_PLUGIN" = true ]; then
cat <<POSTGRES >> $output
# Read metrics from one or many postgresql servers
[postgresql]

# specify servers via an array of tables
[[postgresql.servers]]

# specify address via a url matching:
#   postgres://[pqgotest[:password]]@localhost?sslmode=[disable|verify-ca|verify-full]
# or a simple string:
#   host=localhost user=pqotest password=... sslmode=...
# 
# All connection parameters are optional. By default, the host is localhost
# and the user is the currently running user. For localhost, we default
# to sslmode=disable as well.
# 

address = "sslmode=disable"

# A list of databases to pull metrics about. If not specified, metrics for all
# databases are gathered.

# databases = ["app_production", "blah_testing"]

# [[postgresql.servers]]
# address = "influx@remoteserver"
POSTGRES
fi

if [ "$REDIS_PLUGIN" = true ]; then
cat <<REDIS >> $output
# Read metrics from one or many redis servers
[redis]

# An array of address to gather stats about. Specify an ip on hostname
# with optional port. ie localhost, 10.10.3.33:18832, etc.
#
# If no servers are specified, then localhost is used as the host.
servers = ["localhost"]
REDIS
fi

if [ "$SWAP_PLUGIN" = true ]; then
cat <<SWAP >> $output	
# Read metrics about swap memory usage
[swap]
  # no configuration
SWAP
 fi

if [ "$SYSTEM_PLUGIN" = true ]; then
cat <<SYSTEM >> $output	
# Read metrics about system load
[system]
  # no configuration
SYSTEM
fi

#RUN TELEGRAF
/gopath/bin/telegraf -config $output
