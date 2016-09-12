
GEM_NAME = osp

include Makefile.common

# Email: example@example.com
# Password: password
dev:
	RUBYOPT=-rbundler/setup ruby --debug ./bin/osp -d passwords.osp

.PHONY: test
test:
	RUBYOPT=-w $(BUNDLER) exec ./test/suite_all.rb
