#include <stdio.h>

#include "client.h"
#include "config.h"
#include "debug.h"
#include "ib.h"
#include "server.h"
#include "setup_ib.h"

FILE *log_fp = NULL;

extern struct ib_res g_ib_res;
extern struct config_info g_config_info;

int init_env();
void destroy_env();

int main(int argc, char *argv[]) {
    int ret = 0;

    if (argc != 3) {
        printf("Usage: %s config_file sock_port\n", argv[0]);
        return 0;
    }

    ret = parse_config_file(argv[1]);
    check(ret == 0, "Failed to parse config file");
    g_config_info.sock_port = argv[2];

    ret = init_env();
    check(ret == 0, "Failed to init env");

    ret = setup_ib();
    check(ret == 0, "Failed to setup IB");

    if (g_config_info.is_server) {
        ret = run_server();
    } else {
        ret = run_client();
    }
    check(ret == 0, "Failed to run workload");

error:
    close_ib_connection();
    destroy_env();
    return ret;
}

int init_env() {
    char fname[64] = {'\0'};

    if (g_config_info.is_server) {
        sprintf(fname, "server[%d].log", g_config_info.rank);
    } else {
        sprintf(fname, "client[%d].log", g_config_info.rank);
    }
    log_fp = fopen(fname, "w");
    check(log_fp != NULL, "Failed to open log file");

    log(LOG_HEADER, "IB Echo Server");
    print_config_info();

    return 0;
error:
    return -1;
}

void destroy_env() {
    log(LOG_HEADER, "Run Finished");
    if (log_fp != NULL) {
        fclose(log_fp);
    }
}
