UNAME_S = $(shell uname -s)
CFLAGS = -std=gnu99 -Os -Wall
ifeq ($(OS),Windows_NT)
	LDFLAGS = -s
	LDFLAGS_GFX = -lopengl32 -lgdi32 -mwindows
else ifeq ($(UNAME_S),Darwin)
	LDFLAGS =
	LDFLAGS_GFX = -framework OpenGL -framework Cocoa
else ifeq ($(UNAME_S),Linux)
	LDFLAGS = -s
	LDFLAGS_GFX = -lGLU -lGL -lX11
endif

.PHONY: all clean test

all: minish minigfx

minish: minilisp.c minish.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ minish.c

minigfx: minilisp.c tigr.h tigr.c minigfx.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDFLAGS_GFX) -o $@ tigr.c minigfx.c

clean:
	rm -f minish minigfx *~

test: minish
	@./test.sh
