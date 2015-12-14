
GEM_NAME = osp

include Makefile.common

.PHONY: test
test:
	RUBYOPT=-w ./tests/ts_all.rb
