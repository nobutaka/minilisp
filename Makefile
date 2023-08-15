CFLAGS=-std=gnu99 -g -O2 -Wall

.PHONY: clean test

minilisp: minilisp.c minilisp-ext.c
	$(CC) $(CFLAGS) -o minilisp minilisp-ext.c

clean:
	rm -f minilisp *~

test: minilisp
	@./test.sh
