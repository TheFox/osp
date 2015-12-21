
GEM_NAME = osp

include Makefile.common

.PHONY: test
test:
	RUBYOPT=-w $(BUNDLER) exec ./tests/ts_all.rb
