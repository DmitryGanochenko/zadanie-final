#!/bin/bash
check=$(grep -ci "test1.local" /etc/hosts)
if ((check)) ;then
echo 'test1 OK'
else
echo 'test1.local not configured'
echo '192.168.13.101 test1.local'|sudo tee -a  /etc/hosts
fi

check=$(grep -ci "test2.local" /etc/hosts)
if ((check)) ;then
echo 'test2 OK'
else
echo 'test2.local not configured'
echo '192.168.13.102 test2.local'|sudo tee -a  /etc/hosts
fi

if [ ! -f ~/.ssh/id_rsa ]; then
    echo 'SSH Key not found'
	ssh-keygen
else
	echo 'SSH OK'
fi
