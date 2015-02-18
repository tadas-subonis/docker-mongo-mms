# Mongo Monitoring Agent
#
# Includes:
#   - MMS agent (from 10gen)
#
# Run using
#
#     docker run -d -e MMS_API_KEY=<key> tasubo/docker-mongo-mms
#
# VERSION               1.0

FROM ubuntu:12.10
MAINTAINER Tadas Subonis

ENV HOME /root

# Install using one RUN line to get around 42 AUFS layers limit.
RUN \
  apt-get update -qq ;\
  apt-get install -q -y wget ;\
  apt-get clean ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
  \
echo "# Install MMS" ;\
  wget https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent-3.0.0.167-1.linux_x86_64.tar.gz ;\
  tar zxf mongodb-mms-monitoring-agent-3.0.0.167-1.linux_x86_64.tar.gz ;\
  rm mongodb-mms-monitoring-agent-3.0.0.167-1.linux_x86_64.tar.gz ;\
  \
echo "# Generate start script" ;\
  echo '#!/bin/bash' > mms-agent ;\
  echo 'sed -i "s/mmsApiKey=/mmsApiKey=$MMS_API_KEY/g" monitoring-agent.config' >> mms-agent ;\
  echo "./mongodb-mms-monitoring-agent" >> mms-agent ;\
  chmod +x mms-agent ;\
  \
true
# END RUN

CMD ["mms-agent"]
