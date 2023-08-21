CFLAGS = -std=gnu99 -Os -Wall
ifeq ($(OS),Windows_NT)
	LDFLAGS = -s
	GFX_LDFLAGS = -s -lopengl32 -lgdi32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		LDFLAGS =
		GFX_LDFLAGS = -framework OpenGL -framework Cocoa
	else ifeq ($(UNAME_S),Linux)
		LDFLAGS = -s
		GFX_LDFLAGS = -s -lGLU -lGL -lX11
	endif
endif

.PHONY: clean test

minish: minilisp.c minish.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o minish minish.c

clean:
	rm -f minish minigfx *~

test: minish
	@./test.sh
