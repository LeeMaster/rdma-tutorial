
all: clean rdma_rw rdma_mc

rdma_rw: rdma_rw.c
	gcc -o $@ -Wall $^ -libverbs

rdma_mc: rdma_mc.c
	gcc -o $@ -Wall $^ -lrdmacm -libverbs

clean:
	rm -f rdma_mc rdma_rw

cscope:
	cscope -bqR
