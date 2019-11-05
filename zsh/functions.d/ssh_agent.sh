#!/bin/bash

AGENT_FILE=~/.ssh_agent_data

_setup_agent() {
    ssh-agent | grep -v echo >${AGENT_FILE}
}

if [ ! -f ${AGENT_FILE} ] ; then
    _setup_agent
else
    . ${AGENT_FILE}
fi
if ! ps -p ${SSH_AGENT_PID} &>/dev/null ; then
    _setup_agent
    . ${AGENT_FILE}
fi
