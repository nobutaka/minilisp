CFLAGS = -std=gnu99 -Os -Wall
LDFLAGS = -s

ifeq ($(OS),Windows_NT)
	GFX_LDFLAGS = -lopengl32 -lgdi32 -mwindows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		GFX_LDFLAGS = -framework OpenGL -framework Cocoa
	else ifeq ($(UNAME_S),Linux)
		GFX_LDFLAGS = -lGLU -lGL -lX11
	endif
endif

.PHONY: clean test

minish: minilisp.c minish.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o minish minish.c

minigfx: minilisp.c tigr.c minigfx.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(GFX_LDFLAGS) -o minigfx tigr.c minigfx.c

clean:
	rm -f minish minigfx *~

test: minish
	@./test.sh
