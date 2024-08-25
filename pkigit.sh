#!/bin/bash

eval SSH_AUTH_SOCK=/tmp/ssh-XXXXXXr4zPRm/agent.17942; export SSH_AUTH_SOCK;
SSH_AGENT_PID=17943; export SSH_AGENT_PID;
echo Agent pid 17943;
ssh-add
ssh-add /home/ivan_koshak_99/.ssh/pki
