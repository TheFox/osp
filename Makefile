
GEM_NAME = osp

include Makefile.common

dev:
	RUBYOPT=-rbundler/setup ruby --debug ./bin/osp -d passwords.osp

.PHONY: test
test:
	RUBYOPT=-w $(BUNDLER) exec ./tests/ts_all.rb
