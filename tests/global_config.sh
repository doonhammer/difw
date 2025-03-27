#!/bin/bask
#
# runtests configuration file
#
TEST_LOG=runtests.logs
#
#
#
CLIENT_NS=vnf_client
SERVER_NS=vnf_server
VNF_NS=vnf
#
CLIENT_INTF=veth0
SERVER_INTF=veth3
VNF_INTF=veth1
VNF_INTF1=veth1
VNF_INTF2=veth2
#
PREFIX=24
VNF_ROUTE="10.0.33.0"
CLIENT_IPADDR="10.0.33.2"
SERVER_IPADDR="10.0.33.3"
VNF_IPADDR1="10.0.33.4"
VNF_IPADDR="10.0.33.4"
VNF_IPADDR2="10.0.33.5"
#
BR_NAME=vnf_bridge
BR_IPADDR="10.0.33.5"
BR_CLIENT_INTF=br_veth0
BR_SERVER_INTF=br_veth1
BR_VNF_INTF=br_veth2
# Test Parameters
#
IPERF_TIME=10
#
# End of Script
#