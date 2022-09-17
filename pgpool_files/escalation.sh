#!/bin/bash
# This script is run by wd_escalation_command to bring down the virtual IP on other pgpool nodes
# before bringing up the virtual IP on the new active pgpool node.

set -o xtrace

POSTGRESQL_STARTUP_USER=postgres
SSH_KEY_FILE=id_rsa_pgpool
SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/${SSH_KEY_FILE}"

PGPOOLS=(192.168.1.41 192.168.1.42 192.168.1.43)

VIP=192.168.1.44
DEVICE=ens20

for pgpool in "${PGPOOLS[@]}"; do
    [ "$HOSTNAME" = "$pgpool" ] && continue

    ssh -T ${SSH_OPTIONS} ${POSTGRESQL_STARTUP_USER}@$pgpool "
        /usr/bin/sudo /sbin/ip addr del $VIP/24 dev $DEVICE
    "
done
exit 0
