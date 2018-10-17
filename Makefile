
rdma_rw: rdma_rw.c
	gcc -o $@ -Wall $^ -libverbs
