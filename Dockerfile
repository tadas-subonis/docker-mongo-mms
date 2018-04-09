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

FROM debian:wheezy
MAINTAINER Tadas Subonis

ENV HOME /root
ENV MMS_VERSION latest

#curl -OL https://cloud.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent-latest.linux_x86_64.tar.gz
# Install using one RUN line to get around 42 AUFS layers limit.
RUN \
  cd /opt ; \
  apt-get update ; \
  apt-get install -q -y --force-yes curl ; \
  apt-get clean ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
  \
echo "# Install MMS" ;\
  curl -sSL https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent-${MMS_VERSION}.linux_x86_64.tar.gz -o mms.tar.gz ;\
  tar zxf mms.tar.gz ;\
  rm mms.tar.gz ;\
  mv mongodb-mms-monitoring-agent-* mms ;\
  \
echo "# Generate start script" ;\
  echo '#!/bin/bash' > mms-agent ;\
  echo 'sed -i "s/mmsApiKey=/mmsApiKey=$MMS_API_KEY/g" /opt/mms/monitoring-agent.config' >> mms-agent ;\
  echo 'sed -i "s/mmsGroupId=/mmsGroupId=$MMS_GROUP_ID/g" /opt/mms/monitoring-agent.config' >> mms-agent ;\
  echo "/opt/mms/mongodb-mms-monitoring-agent -conf /opt/mms/monitoring-agent.config" >> mms-agent ;\
  chmod +x mms-agent ;\
  \
true
# END RUN

CMD [ "/opt/mms-agent" ]
