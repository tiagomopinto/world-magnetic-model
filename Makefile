ODIN_FLAGS := -o:aggressive -microarch:native -no-bounds-check -disable-assert -no-type-assert -vet -strict-style
CC_FLAGS := -Wall -Wextra -pedantic -std=c99 -O3

.PHONY : all bin run clean

all: bin/wmm.a bin/wmm

bin/wmm : main.odin wmm/*.odin
	odin build main.odin -file $(ODIN_FLAGS) -out:$@

bin/%.a : bin/wmm.o
	ar rcs $@ $^

bin/%.o : wmm_c/GeomagnetismLibrary.c | bin
	gcc $(CC_FLAGS) -c $^ -o $@

bin:
	@mkdir -p bin

run :
	@bin/wmm

clean :
	@rm -rf bin
