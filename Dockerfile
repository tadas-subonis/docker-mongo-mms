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

FROM ubuntu:wheezy
MAINTAINER Tadas Subonis

ENV HOME /root
ENV MMS_VERSION 3.0.0.167-1

# Install using one RUN line to get around 42 AUFS layers limit.
RUN \
  apt-get update ; \
  apt-get install -q -y --force-yes curl ; \
  apt-get clean ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
  \
echo "# Install MMS" ;\
  curl -sSL https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent-${MMS_VERSION}.linux_x86_64.tar.gz -o mms.tar.gz ;\
  tar zxf mms.tar.gz ;\
  rm mms.tar.gz ;\
  \
echo "# Generate start script" ;\
  echo '#!/bin/bash' > mms-agent ;\
  echo 'cd /root' >> mms-agent ;\
  echo 'sed -i "s/mmsApiKey=/mmsApiKey=$MMS_API_KEY/g" monitoring-agent.config' >> mms-agent ;\
  echo "./mongodb-mms-monitoring-agent" >> mms-agent ;\
  chmod +x mms-agent ;\
  \
true
# END RUN

CMD [ "/root/mms-agent" ]
