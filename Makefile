CFLAGS = -std=gnu99 -Os -Wall
LDFLAGS = -s

.PHONY: clean test

minish: minilisp.c minish.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o minish minish.c

clean:
	rm -f minish minigfx *~

test: minish
	@./test.sh
