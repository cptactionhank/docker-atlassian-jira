#!/bin/bash

# check if the `server.xml` file has been changed since the creation of this
# Docker image. If the file has been changed the entrypoint script will not
# perform modifications to the configuration file.
if [ "$(stat --format "%Y" "${JIRA_INSTALL}/conf/server.xml")" -eq "0" ]; then
  if [ -n "${X_PROXY_NAME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8080"]' --type "attr" --name "proxyName" --value "${X_PROXY_NAME}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_PORT}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8080"]' --type "attr" --name "proxyPort" --value "${X_PROXY_PORT}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PROXY_SCHEME}" ]; then
    xmlstarlet ed --inplace --pf --ps --insert '//Connector[@port="8080"]' --type "attr" --name "scheme" --value "${X_PROXY_SCHEME}" "${JIRA_INSTALL}/conf/server.xml"
  fi
  if [ -n "${X_PATH}" ]; then
    xmlstarlet ed --inplace --pf --ps --update '//Context/@path' --value "${X_PATH}" "${JIRA_INSTALL}/conf/server.xml"
  fi
fi

# do the same for setenv.sh which sets heapsize among other things
if [ "$(stat --format "%Y" "${JIRA_INSTALL}/bin/setenv.sh")" -eq "0" ]; then
  if [ -n "${JIRA_MINIMUM_MEMORY}" ]; then
    printf "%s\n" ",s/JVM_MINIMUM_MEMORY=.*/JVM_MINIMUM_MEMORY=\"${JIRA_MINIMUM_MEMORY}\"/" wq | ed -s "${JIRA_INSTALL}/bin/setenv.sh"
  fi
  if [ -n "${JIRA_MAXIMUM_MEMORY}" ]; then
    printf "%s\n" ",s/JVM_MAXIMUM_MEMORY=.*/JVM_MAXIMUM_MEMORY=\"${JIRA_MAXIMUM_MEMORY}\"/" wq | ed -s "${JIRA_INSTALL}/bin/setenv.sh"
  fi
fi

exec "$@"
