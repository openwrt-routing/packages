#!/bin/sh

. /lib/functions.sh
. /lib/functions/network.sh

CHECK_TIME=$1
CHECK_BABELD=$2

babeld_get_mesh_interface() {
	config_get $1 ifname
}

babeld_has_mesh_neighbors() {
    config_load babeld
    mesh_interfaces=$(config_foreach babeld_get_mesh_interface interface ifname)

    for mesh in $mesh_interfaces; do
        network_get_physdev phy $mesh
        linklocal=$(ip -6 a list dev $phy | grep "scope link" | awk '{print $2}' | sed 's/\/64//')
        ips=$(ping ff02::1%$phy -c2 | grep from | awk '{print $4}' | sed 's/.$//')
        for ip in $ips; do
            if [ $ip != $linklocal ] && [ $(owipcalc $ip linklocal) -eq 1 ]; then
                echo 1
                return 0
            fi
        done
    done

    echo 0
}

reboot_now() {
    # copied from watch-cat
    reboot &

    [ "$1" -ge 1 ] && {
        sleep "$1"
        echo 1 >/proc/sys/kernel/sysrq
        echo b >/proc/sysrq-trigger
    }
}

while [ 1 ]; do

    # first sleep
    sleep $CHECK_TIME

    if [ $CHECK_BABELD ]; then 
        babeld_has_neighbor=$(babeld_has_mesh_neighbors)
        if [ $babeld_has_neighbor -eq 0 ]; then
            echo "No neighbor available! Rebooting!"
            reboot_now
        else
            echo "Neighbors available. Everything is fine."
        fi
    fi
done

exit 0
