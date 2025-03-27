/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (c) 2024 John McDowall
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
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>
#include <linux/if_link.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <net/if.h>
#include <arpa/inet.h>

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

static volatile bool running = true;

static void int_exit(int sig)
{
    running = false;
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

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <ifname>\n", argv[0]);
        return 1;
    }

    char *ifname = argv[1];
    int ifindex = if_nametoindex(ifname);
    if (ifindex == 0) {
        fprintf(stderr, "Failed to get interface index: %s\n", strerror(errno));
        return 1;
    }

    // Set up signal handler
    signal(SIGINT, int_exit);
    signal(SIGTERM, int_exit);

    // Load and attach XDP program
    struct bpf_object *obj;
    int prog_fd = bpf_prog_load("difw_kern.o", BPF_PROG_TYPE_XDP, &obj, &prog_fd);
    if (prog_fd < 0) {
        fprintf(stderr, "Error loading program: %s\n", strerror(errno));
        return 1;
    }

    if (bpf_set_link_xdp_fd(ifindex, prog_fd, 0) < 0) {
        fprintf(stderr, "Error attaching program: %s\n", strerror(errno));
        return 1;
    }

    // Get map file descriptor
    int map_fd = bpf_object__find_map_fd_by_name(obj, "sessions");
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
    bpf_set_link_xdp_fd(ifindex, -1, 0);
    return 0;
} 