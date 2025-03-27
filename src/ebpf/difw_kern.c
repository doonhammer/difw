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

#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include <bpf/bpf_tracing.h>

// Session key structure
struct session_key {
    __u32 src_ip;
    __u32 dst_ip;
    __u16 src_port;
    __u16 dst_port;
    __u8 protocol;
};

// Session info structure
struct session_info {
    __u64 packets;
    __u64 bytes;
    __u64 timestamp;
};

struct {
    __uint(type, BPF_MAP_TYPE_DEVMAP);
    __uint(key_size, sizeof(int));
    __uint(value_size, sizeof(int));
    __uint(max_entries, 2);
} xdp_tx_ports SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(key_size, sizeof(struct session_key));
    __uint(value_size, sizeof(struct session_info));
    __uint(max_entries, 10000);
} sessions SEC(".maps");

static __always_inline int process_packet(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    
    struct ethhdr *eth = data;
    if ((void*)(eth + 1) > data_end)
        return XDP_PASS;

    if (eth->h_proto != bpf_htons(ETH_P_IP))
        return XDP_PASS;

    struct iphdr *iph = (void*)(eth + 1);
    if ((void*)(iph + 1) > data_end)
        return XDP_PASS;

    struct session_key key = {};
    key.src_ip = iph->saddr;
    key.dst_ip = iph->daddr;
    key.protocol = iph->protocol;

    if (iph->protocol == IPPROTO_TCP) {
        struct tcphdr *tcp = (void*)(iph + 1);
        if ((void*)(tcp + 1) > data_end)
            return XDP_PASS;
        key.src_port = bpf_ntohs(tcp->source);
        key.dst_port = bpf_ntohs(tcp->dest);
    } else if (iph->protocol == IPPROTO_UDP) {
        struct udphdr *udp = (void*)(iph + 1);
        if ((void*)(udp + 1) > data_end)
            return XDP_PASS;
        key.src_port = bpf_ntohs(udp->source);
        key.dst_port = bpf_ntohs(udp->dest);
    } else {
        return XDP_PASS;
    }

    struct session_info *info, new_info = {};
    info = bpf_map_lookup_elem(&sessions, &key);
    if (!info) {
        new_info.packets = 1;
        new_info.bytes = (data_end - data);
        new_info.timestamp = bpf_ktime_get_ns();
        bpf_map_update_elem(&sessions, &key, &new_info, BPF_ANY);
    } else {
        info->packets++;
        info->bytes += (data_end - data);
        info->timestamp = bpf_ktime_get_ns();
    }

    return XDP_PASS;
}

SEC("xdp")
int difw(struct xdp_md *ctx)
{
    __u32 in_ifindex = ctx->ingress_ifindex;
    __u32 out_ifindex;

    // Process the packet and update session table
    int action = process_packet(ctx);
    if (action != XDP_PASS)
        return action;

    // Forward to the next interface
    if (in_ifindex == 1)
        out_ifindex = 2;
    else if (in_ifindex == 2)
        out_ifindex = 1;
    else
        return XDP_PASS;

    if (bpf_redirect_map(&xdp_tx_ports, out_ifindex, 0) < 0)
        return XDP_DROP;

    return XDP_REDIRECT;
}

char _license[] SEC("license") = "GPL";