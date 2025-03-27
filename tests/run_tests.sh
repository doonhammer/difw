#!/bin/bash
#
#
#
# Setup error handling, 
set -o errexit
set -o nounset
umask 077
#
# Read global configuration data
source "$(dirname "$0")/global_config.sh"
#
opt_test_type="NULL"
opt_test_number="NULL"
#
# Logging to file
#
echo 'Creating test' &> "$TEST_LOG"
#
# Error Handling
#
handle_error(){
    echo "$1" >&2
    exit 1
}


create_simple_veth_setup(){
    ip netns add "$CLIENT_NS"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.ip_forward=1 &>> "$TEST_LOG"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    #ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #
    ip netns add "$SERVER_NS"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv4.ip_forward=1 &>> "$TEST_LOG"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    #ip netns exec "$SERVER_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #
    #
    # Stop Firewall on all namespaces
    #
    ip netns exec vnf_client systemctl stop ufw >>"$TEST_LOG"
    ip netns exec vnf_server systemctl stop ufw >>"$TEST_LOG"
    #
    # Create Veths between three namespaces
    #
    echo 'Adding client namespace'
    ip link add "$CLIENT_INTF" type veth peer name "$SERVER_INTF"
    ip link set dev "$CLIENT_INTF" netns "$CLIENT_NS"
    ip netns exec "$CLIENT_NS" ip addr add "$CLIENT_IPADDR"/"$PREFIX" dev "$CLIENT_INTF"
    ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx off rx off gro off gso off &>> "$TEST_LOG"
   
    ip netns exec "$CLIENT_NS" ip link set dev lo up
    ip netns exec "$CLIENT_NS" ip link set dev "$CLIENT_INTF" up
    #
    #ip netns exec "$VNF_NS" ip route add 192.168.1.0/24  dev "$VNF_INTF0"
    #ip netns exec "$CLIENT_NS" ip route add 192.168.2.0/24 via "$CLIENT_IPADDR"
    #ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx off gso off &>> "$TEST_LOG"
    #
    #
    echo 'Adding server namespace'
    #ip link add "$SERVER_INTF" type veth peer name "$CLIENT_INTF"
    ip link set dev "$SERVER_INTF" netns "$SERVER_NS"
    ip netns exec "$SERVER_NS" ip addr add "$SERVER_IPADDR"/"$PREFIX" dev "$SERVER_INTF"
    ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx off rx off gro off gso off &>> "$TEST_LOG"
    #
    ip netns exec "$SERVER_NS" ip link set dev lo up
    ip netns exec "$SERVER_NS" ip link set dev "$SERVER_INTF" up
    #
}

create_veth_setup(){
    ip netns add "$CLIENT_NS"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.ip_forward=1 &>> "$TEST_LOG"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    #ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
   
    ip netns add "$SERVER_NS"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv4.ip_forward=1 &>> "$TEST_LOG"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    #ip netns exec "$SERVER_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
   
    ip netns add "$VNF_NS"
    ip netns exec "$VNF_NS" sysctl -w net.ipv4.ip_forward=1 &>>"$TEST_LOG"
    ip netns exec "$VNF_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>>"$TEST_LOG"
    # ip netns exec "$VNF_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #
    # Stop Firewall on all namespaces
    #
    ip netns exec vnf_client systemctl stop ufw >>"$TEST_LOG"
    ip netns exec vnf systemctl stop ufw >>"$TEST_LOG"
    ip netns exec vnf_server systemctl stop ufw >>"$TEST_LOG"
    #
    # Create Veths between three namespaces
    #
    echo 'Adding client namespace'
    ip link add "$CLIENT_INTF" type veth peer name "$VNF_INTF1"
    ip link set dev "$CLIENT_INTF" netns "$CLIENT_NS"
    ip link set dev "$VNF_INTF1" netns "$VNF_NS"
    ip netns exec "$CLIENT_NS" ip addr add "$CLIENT_IPADDR"/"$PREFIX" dev "$CLIENT_INTF"
    ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx off rx off gro off gso off &>> "$TEST_LOG"
    ip netns exec "$VNF_NS" ip addr add "$VNF_IPADDR1"/"$PREFIX" dev "$VNF_INTF1"
    
    ip netns exec "$CLIENT_NS" ip link set dev lo up
    ip netns exec "$CLIENT_NS" ip link set dev "$CLIENT_INTF" up
    #
    echo 'Adding test server namespace'
    ip netns exec "$VNF_NS" ip link set dev lo up
    ip netns exec "$VNF_NS" ip link set dev "$VNF_INTF1" up
    ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF1" rx off tx off gro off gso off &>> "$TEST_LOG"
    #
    #
    #ip netns exec "$VNF_NS" ip route add 192.168.1.0/24  dev "$VNF_INTF0"
    #ip netns exec "$CLIENT_NS" ip route add 192.168.2.0/24 via "$CLIENT_IPADDR"
    #ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx off gso off &>> "$TEST_LOG"
    #
    #
    echo 'Adding server namespace'
    ip link add "$SERVER_INTF" type veth peer name "$VNF_INTF2"
    echo "Step 1"
    ip link set dev "$SERVER_INTF" netns "$SERVER_NS"
    ip link set dev "$VNF_INTF2" netns "$VNF_NS"

    ip netns exec "$SERVER_NS" ip addr add "$SERVER_IPADDR"/"$PREFIX" dev "$SERVER_INTF"
    ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx off rx off gro off gso off &>> "$TEST_LOG"
    ip netns exec "$VNF_NS" ip addr add "$VNF_IPADDR2"/"$PREFIX" dev "$VNF_INTF2"

    #ip netns exec "$VNF_NS" ip link set dev lo up
    ip netns exec "$SERVER_NS" ip link set dev lo up
    ip netns exec "$SERVER_NS" ip link set dev "$SERVER_INTF" up
    
    ip netns exec "$VNF_NS" ip link set dev "$VNF_INTF2" up
    ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF2" tx off rx off gro off gso off &>> "$TEST_LOG"
    #
    #ip netns exec "$VNF_NS" ip route add "$VNF_ROUTE"/"$PREFIX" dev "$VNF_INTF2"
    #
    
    #ip netns exec "$SERVER_NS" ip route add "$VNF_ROUTE"/"$PREFIX" via "$SERVER_IPADDR"
   
    #
}

create_linux_bridge_setup(){
    echo 'Creating bridge setup'
#
    # Share mount points for network namespaces
    #
    printf '\nCreating bridge and associated namespaces \n'
    #mount -t bpf bpf /sys/fs/bpf/tc/globals || handle_error "Unable to mount /sys/fs/bpf inside test environment"
    #mount --make-shared /sys/fs/bpf || handle_error "Unable to make shared /sys/fs/bpf inside test environment"
    #mount --bind /sys/fs/bpf /sys/fs/bpf || handle_error "Unable to bind /sys/fs/bpf inside test environment"
    #
    # Create Namespaces and configure
    #
    sysctl -w net.ipv4.ip_forward=1 &>>"$TEST_LOG"
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>>"$TEST_LOG"
    sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #sysctl -w net.bridge.bridge-nf-call-iptables=0 &>> "$TEST_LOG"
    sysctl -w net.ipv4.conf.all.forwarding=1  &>> "$TEST_LOG"
    #
    ip netns add "$CLIENT_NS"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.ip_forward=0 &>> "$TEST_LOG"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #ip netns exec "$CLIENT_NS" sysctl -w net.bridge.bridge-nf-call-iptables=0 &>> "$TEST_LOG"
    ip netns exec "$CLIENT_NS" sysctl -w net.ipv4.conf.all.forwarding=1  &>> "$TEST_LOG"
    #
    ip netns add "$SERVER_NS"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv4.ip_forward=0 &>> "$TEST_LOG"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>> "$TEST_LOG"
    ip netns exec "$SERVER_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #ip netns exec "$SERVER_NS" sysctl -w net.bridge.bridge-nf-call-iptables=0 &>> "$TEST_LOG"
    #
    ip netns add "$VNF_NS"
    ip netns exec "$VNF_NS" sysctl -w net.ipv4.ip_forward=0 &>>"$TEST_LOG"
    ip netns exec "$VNF_NS" sysctl -w net.ipv6.conf.all.disable_ipv6=1 &>>"$TEST_LOG"
    ip netns exec "$VNF_NS" sysctl -w net.ipv4.conf.all.rp_filter=2 &>> "$TEST_LOG"
    #ip netns exec "$VNF_NS" sysctl -w net.bridge.bridge-nf-call-iptables=0 &>> "$TEST_LOG"
    #
    # Create Veths between three namespaces
    #
    ip link add "$BR_CLIENT_INTF" type veth peer name "$CLIENT_INTF"
    ip link set dev "$BR_CLIENT_INTF" up
    ip link set dev "$CLIENT_INTF" netns "$CLIENT_NS"
    ip netns exec "$CLIENT_NS" ip link set dev lo up
    ip netns exec "$CLIENT_NS" ip link set dev "$CLIENT_INTF" up
    ip netns exec "$CLIENT_NS" ip addr add "$CLIENT_IPADDR"/"$PREFIX" dev "$CLIENT_INTF"
    ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx off rx off gro off gso off &>> "$TEST_LOG"


    ip link add "$BR_VNF_INTF" type veth peer name "$VNF_INTF"
    ip link set dev "$BR_VNF_INTF" up
    ip link set dev "$VNF_INTF" netns "$VNF_NS"
    ip netns exec "$VNF_NS" ip link set dev lo up
    ip netns exec "$VNF_NS" ip link set dev "$VNF_INTF" up
    ip netns exec "$VNF_NS" ip addr add "$VNF_IPADDR"/"$PREFIX" dev "$VNF_INTF"
    ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF" tx off gro off gso off rx off &>> "$TEST_LOG"
    #
    
    ip link add "$BR_SERVER_INTF" type veth peer name "$SERVER_INTF"
    ip link set dev "$BR_SERVER_INTF" up
    ip link set dev "$SERVER_INTF" netns "$SERVER_NS"
    ip netns exec "$SERVER_NS" ip link set dev lo up
    ip netns exec "$SERVER_NS" ip link set dev "$SERVER_INTF" up
    ip netns exec "$SERVER_NS" ip addr add "$SERVER_IPADDR"/"$PREFIX" dev "$SERVER_INTF"
    ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx off gro off gso off rx off &>> "$TEST_LOG"
    #
    # Create Bridge
    #
    ip link add "$BR_NAME" type bridge 
    ip link set "$BR_NAME" up
    sleep 1
    #ip link set dev "$BR_NAME" mtu 1500
    #
    ip link set "$BR_CLIENT_INTF" master "$BR_NAME"
    ip link set "$BR_SERVER_INTF" master "$BR_NAME"
    ip link set "$BR_VNF_INTF" master "$BR_NAME"
    #ethtool -K "$BR_CLIENT_INTF" tx off gro off gso off rx off &>> "$TEST_LOG"
    #ethtool -K "$BR_SERVER_INTF" tx off gro off gso off rx off &>> "$TEST_LOG"
    #ethtool -K "$BR_VNF_INTF" tx off gro off gso off rx off &>> "$TEST_LOG"
    #
    ip addr add "$BR_IPADDR"/"$PREFIX" dev "$BR_NAME" &>> "$TEST_LOG"
    #
    ip netns exec "$CLIENT_NS" ip route add default via "$BR_IPADDR"
    ip netns exec "$SERVER_NS" ip route add default via "$BR_IPADDR"
    ip netns exec "$VNF_NS" ip route add default via "$BR_IPADDR"

    #ip link set dev lo up
    #ip -all netns exec ip route add default via "$BR_IPADDR"
    

}

cleanup_test(){
    echo 'Cleanup tests'
    sudo pkill -f iperf3
    sudo pkill -f difw
    ip netns del "$CLIENT_NS"
    ip netns del "$SERVER_NS"
    ip netns del "$VNF_NS"
    ip link del "$BR_NAME"
    ip link del "$BR_CLIENT_INTF"
    ip link del "$BR_SERVER_INTF"
    ip link del "$BR_VNF_INTF"

}

list_tests(){
 echo 'List tests'
}

show_test(){
    ip netns list
    ip netns exec "$CLIENT_NS" ip -d addr show "$CLIENT_INTF"
    ip netns exec "$SERVER_NS" ip -d addr show "$SERVER_INTF"
    ip netns exec "$VNF_NS" ip -d addr show "$VNF_INTF1"
    ip netns exec "$VNF_NS" ip -d addr show "$VNF_INTF2"
}

run_test(){
    case "$opt_test_number" in
        1)  
            create_simple_veth_setup
            echo "Running test 1"
            execute_test_1 run
            ;;
        2)  
            create_veth_setup
            echo "Running test 2"
            execute_test_2 run
            ;;
        3)  
            create_linux_bridge_setup
            execute_test_2 run
            ;;
        a) execute_test_all
            ;;
        '?')
            printf 'ERROR: Invalid test type: %s\n' $opt_test_type
            exit 1
            ;;
    esac
}

execute_test_1(){

    printf '\nTest 1: Basic client/server IPERF3 Test\n'
    if [ $1 != list ]; then
        #ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF1" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF2" tx on gso on &>> "$TEST_LOG"
        ip netns exec "$SERVER_NS" iperf3 -s & 
        sleep 1
        ip netns exec "$CLIENT_NS" iperf3  -t "$IPERF_TIME" -c "$SERVER_IPADDR" 
    fi
}

execute_test_2(){

    printf '\nTest 2: Basic IPERF3 Test\n'
    if [ $1 != list ]; then
        #ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF1" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF2" tx on gso on &>> "$TEST_LOG"
        ip netns exec "$VNF_NS" ../difw  -f veth1 -s veth2 &
        sleep 1
        ip netns exec "$SERVER_NS" iperf3 -s & 
        sleep 1
        ip netns exec "$CLIENT_NS" iperf3  -t "$IPERF_TIME" -c "$SERVER_IPADDR" 
    fi
}

execute_test_3(){

    printf '\nTest 3: Basic IPERF3 Test\n'
    if [ $1 != list ]; then
        #ip netns exec "$CLIENT_NS" ethtool -K "$CLIENT_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$SERVER_NS" ethtool -K "$SERVER_INTF" tx on gso on &>> "$TEST_LOG"
        #ip netns exec "$VNF_NS" ethtool -K "$VNF_INTF" tx on gso on &>> "$TEST_LOG"
        ip netns exec "$VNF_NS" ../bin/vnf -f "$VNF_INTF" -p 1 &
        ip netns exec "$SERVER_NS" iperf3 -s & 
        sleep 1
        ip netns exec "$CLIENT_NS" iperf3  -t "$IPERF_TIME" -c "$SERVER_IPADDR"
    fi
}
#
# CLI Usage function
#
usage() {
cat << EOF
Usage: ${0##*/} [-h] [-c type] [-d] [-b] [-s] [-l] [-t number or a]

 
     -h 	Display this help and exit
     -c 	Create veth environment
     -b     Create bridge enviroment
     -d 	Delete test environment
     -s 	Show test environment
     -l 	List all test available
     -t 	Run Test number (a for all)

EOF
}
#
# Parse Command Line Arguments
#
while getopts "hcdlbst:" opt; do
    case "$opt" in
        h)
            usage
            exit 0
            ;;
        c) 
           create_veth_setup
           exit 0
           ;;
        b)
           create_linux_bridge_setup
           exit 0
           ;;
        d) 
           cleanup_test
           exit 0
           ;;
        s) show_test
           exit 0
		   ;;
		l) list_tests
		   ;;
		t) opt_test_number=$OPTARG
		   ;;
        '?')
           usage
           exit 1
           ;;
    esac
done

printf '\nCreating test type: %s\n' "$opt_test_type"
if [ "$opt_test_type" != "NULL" ]; then
	printf '\nCreating test type: %s\n' "$opt_test_type"
	#create_vnf_setup
    exit 1
fi

if [ "$opt_test_number" != "NULL" ]; then
	printf '\nRunning test number type: %s\n' "$opt_test_number"
	run_test
    exit 1
fi

usage
#

# End of Script
#