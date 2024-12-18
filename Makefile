ODIN_FLAGS := -o:aggressive -microarch:native -no-bounds-check -disable-assert -no-type-assert -vet
CC_FLAGS := -Wall -Wextra -pedantic -std=c99 -O3

.PHONY : all wmm run clean

all: wmm bin/wmm

bin/wmm : main.odin wmm/*.odin
	odin build main.odin -file $(ODIN_FLAGS) -out:$@

wmm : bin/wmm.a

bin/%.a : bin/wmm.o
	ar rcs $@ $^

bin/%.o : wmm_c/GeomagnetismLibrary.c | bin
	gcc $(CC_FLAGS) -c $^ -o $@

bin:
	@mkdir -p bin

run :
	@ bin/wmm

clean :
	@rm -rf bin
