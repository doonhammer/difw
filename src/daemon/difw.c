/*
 * Copyright (c) 2025 John McDowall
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <getopt.h>
#include <string.h>
#include <unistd.h>
#include <linux/if_link.h>
#include <linux/bpf.h>
#include <linux/bpf_common.h>
#include <net/if.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <arpa/inet.h>


static int ifindex = -1;
static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
static __u32 prog_fd;

// Same structures as in kernel program
struct session_key {
    __u32 src_ip;
    __u32 dst_ip;
    __u16 src_port;
    __u16 dst_port;
    __u8 protocol;
};

struct session_info {
    __u64 packets;
    __u64 bytes;
    __u64 timestamp;
};

typedef struct _arg_config {
  char first[IFNAMSIZ];
  char second[IFNAMSIZ];
} arg_config_t;

static volatile bool running = true;

static void int_exit(int sig)
{
    __u32 curr_prog_id = 0;

    if (ifindex > -1) {
        if (bpf_xdp_query_id(ifindex, xdp_flags, &curr_prog_id)) {
            printf("bpf_xdp_query_id failed\n");
            exit(1);
        }
        if (prog_fd == curr_prog_id)
            bpf_xdp_detach(ifindex, xdp_flags, NULL);
        else if (!curr_prog_id)
            printf("couldn't find a prog id on a given iface\n");
        else
            printf("program on interface changed, not removing\n");
    }
    exit(0);
}

static void print_session(const struct session_key *key, const struct session_info *info)
{
    char src_ip[16], dst_ip[16];
    inet_ntop(AF_INET, &key->src_ip, src_ip, sizeof(src_ip));
    inet_ntop(AF_INET, &key->dst_ip, dst_ip, sizeof(dst_ip));
    
    printf("Session: %s:%d -> %s:%d (proto: %d)\n",
           src_ip, key->src_port,
           dst_ip, key->dst_port,
           key->protocol);
    printf("  Packets: %llu\n", info->packets);
    printf("  Bytes: %llu\n", info->bytes);
    printf("  Last seen: %llu ns\n", info->timestamp);
}

/*
 Program config
 */
void print_config(arg_config_t *config){
    printf("\n---- DIFW Test Utility ----\n");
    printf("Interface to attach to: %s\n", config->first);
    printf("----------------------------------------\n");
}
int main(int argc, char **argv)
{
    char arg_first[IFNAMSIZ];
    char filename[256];
    struct bpf_program *prog;
    struct bpf_object *obj;
    int map_fd;
    int c,err;



    xdp_flags |= XDP_FLAGS_SKB_MODE;

    static struct option longopts[] = {
        {"interface", required_argument,0,'i'},
        {"help",no_argument,0,'h'},
    };
    /*
    * Set defaults
    */
    arg_first[0]='\0';
   
        /*
     * Loop over input
     */
    while (( c = getopt_long(argc,argv, "i:h",longopts,NULL))!=-1){
        switch(c) {
            case 'i':
                strncpy(arg_first,optarg,IFNAMSIZ-1);
                break;
            case 'h':
                printf("Command line arguments: \n");
                printf("-i, --interface     Interface to attach to \n");
                printf("-h, --help:     Command line help \n");
                exit(1);
            default:
                printf("Ignoring unrecognized command line option:%d\n ",c);
                break;
        }
    }


    ifindex = if_nametoindex(arg_first);
    if (!ifindex)
    {
        perror("Failed to get interface index");
        return 1;
    }

    snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
    obj = bpf_object__open_file(filename, NULL);
    if (libbpf_get_error(obj))
        return 1;

    //prog = bpf_object__next_program(obj, NULL);
   

    prog = bpf_object__find_program_by_name(obj, "difw");
    if (!prog) {
        fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
    }
    bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);

    err = bpf_object__load(obj);
    if (err)
        return 1;

    prog_fd = bpf_program__fd(prog);


    if (bpf_xdp_attach(ifindex, prog_fd, xdp_flags, NULL) < 0) {
        printf("link set xdp fd failed\n");
        return 1;
    }

 // Get map file descriptor
    map_fd = bpf_object__find_map_fd_by_name(obj, "sessions");
    if (map_fd < 0) {
        fprintf(stderr, "Error finding map: %s\n", strerror(errno));
        return 1;
    }

    printf("Successfully attached XDP program. Monitoring sessions...\n");

    // Main loop to print sessions
    while (running) {
        struct session_key key, next_key;
        struct session_info info;
        
        memset(&key, 0, sizeof(key));
        while (bpf_map_get_next_key(map_fd, &key, &next_key) == 0) {
            if (bpf_map_lookup_elem(map_fd, &next_key, &info) == 0) {
                print_session(&next_key, &info);
            }
            key = next_key;
        }
        
        printf("\n");
        sleep(1);
    }

    // Cleanup
   int_exit(0);
    return 0;

    return 0;
}