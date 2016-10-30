
GEM_NAME = osp

include Makefile.common

# Email: example@example.com
# Password: password
dev:
	RUBYOPT=--debug $(BUNDLER) exec ./bin/osp -d passwords.osp

.PHONY: test
test:
	RUBYOPT=-w $(BUNDLER) exec ./test/suite_all.rb

.PHONY: cov
cov:
	RUBYOPT=-w COVERAGE=1 $(BUNDLER) exec ./test/suite_all.rb -v

.PHONY: cov_local
cov_local:
	RUBYOPT=-w SIMPLECOV_PHPUNIT_LOAD_PATH=../simplecov-phpunit COVERAGE=1 $(BUNDLER) exec ./test/suite_all.rb -v
