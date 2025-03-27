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
#include <linux/if.h>
#include <linux/if_link.h>
#include <linux/bpf.h>
#include <linux/bpf_common.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#define IFNAMSIZ 16

static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;

typedef struct _arg_config {
  char first[IFNAMSIZ];
  char second[IFNAMSIZ];
} arg_config_t;

/*
 Program config
 */
void print_config(arg_config_t *config){
    printf("\n---- VNF Test Utility ----\n");
    printf("First interface: %s\n", config->first);
    printf("Second interface: %s\n", config->second);
    printf("----------------------------------------\n");
}
int main(int argc, char **argv)
{
    char arg_first[IFNAMSIZ];
    char arg_second[IFNAMSIZ];
    int c,err;

    struct bpf_prog_load_attr prog_load_attr = {
        .prog_type  = BPF_PROG_TYPE_XDP,
    };

    xdp_flags |= XDP_FLAGS_SKB_MODE;

    static struct option longopts[] = {
        {"first", required_argument,0,'f'},
        {"second", required_argument,0,'s'},
        {"help",no_argument,0,'h'},
    };
    /*
    * Set defaults
    */
    arg_first[0]='\0';
    arg_second[0] = '\0';
        /*
     * Loop over input
     */
    while (( c = getopt_long(argc,argv, "f:s:h",longopts,NULL))!=-1){
        switch(c) {
            case 'f':
                strncpy(arg_first,optarg,IFNAMSIZ-1);
                break;
            case 's':
                strncpy(arg_second, optarg,IFNAMSIZ-1);
                break;
            case 'h':
                printf("Command line arguments: \n");
                printf("-f, --first     First interface \n");
                printf("-s, --second    Second interface \n");
                printf("-h, --help:     Command line help \n");
                exit(1);
            default:
                printf("Ignoring unrecognized command line option:%d\n ",c);
                break;
        }
    }


    int ifindex1 = if_nametoindex(arg_first);
    int ifindex2 = if_nametoindex(arg_second);
    if (!ifindex1 || !ifindex2)
    {
        perror("Failed to get interface index");
        return 1;
    }

    struct bpf_object *obj;
    int prog_fd;
    prog_load_attr.file = "difw_kern.o";

    err = bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd);
    if (err) {
        printf("Does kernel support devmap lookup?\n");
        /* If not, the error message will be:
         *  "cannot pass map_type 14 into func bpf_map_lookup_elem#1"
         */
        return 1;
    }
/*
    obj = bpf_object__open_file("difw_kern.o", NULL);
    if (!obj)
    {
        fprintf(stderr, "Failed to open BPF object\n");
        return 1;
    }

    if (bpf_object__load(obj))
    {
        fprintf(stderr, "Failed to load BPF object\n");
        bpf_object__close(obj);
        return 1;
    }
*/
    struct bpf_program *prog = bpf_object__find_program_by_title(obj, "difw");
    if (!prog)
    {
        fprintf(stderr, "Failed to find BPF program\n");
        bpf_object__close(obj);
        return 1;
    }

    prog_fd = bpf_program__fd(prog);
    if (prog_fd < 0)
    {
        fprintf(stderr, "Failed to get BPF program FD\n");
        bpf_object__close(obj);
        return 1;
    }

    if (bpf_set_link_xdp_fd(ifindex1, prog_fd, xdp_flags) < 0)
    {
        perror("Failed to attach XDP program to interface 1");
        bpf_object__close(obj);
        return 1;
    }

    if (bpf_set_link_xdp_fd(ifindex2, prog_fd, xdp_flags) < 0)
    {
        perror("Failed to attach XDP program to interface 2");
        bpf_set_link_xdp_fd(ifindex1, -1, xdp_flags);
        bpf_object__close(obj);
        return 1;
    }

    printf("XDP program loaded successfully on %s and %s\n", argv[1], argv[2]);

    // Keep running until user stops the program
    printf("Press Ctrl+C to exit\n");
    while (1)
        sleep(1);

    bpf_set_link_xdp_fd(ifindex1, -1, xdp_flags);
    bpf_set_link_xdp_fd(ifindex2, -1, xdp_flags);
    bpf_object__close(obj);

    return 0;
}