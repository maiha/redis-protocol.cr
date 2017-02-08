SHELL = /bin/bash

.PHONY : all spec

all: spec

spec:
	crystal spec -v --fail-fast
