CFLAGS = -std=gnu99 -g -O2 -Wall

.PHONY: clean test

minish: minilisp.c minish.c
	$(CC) $(CFLAGS) -o minish minish.c

clean:
	rm -f minish minigfx *~

test: minish
	@./test.sh
