# coding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'osp/version'

Gem::Specification.new do |spec|
	spec.name          = 'osp'
	spec.version       = TheFox::OSP::VERSION
	spec.date          = TheFox::OSP::DATE
	spec.author        = 'Christian Mayer'
	spec.email         = 'christian@fox21.at'
	
	spec.summary       = %q{One Shall Pass}
	spec.description   = %q{Password Manager: One Shall Pass for Command Line.}
	spec.homepage      = TheFox::OSP::HOMEPAGE
	spec.license       = 'GPL-3.0'
	
	spec.files         = `git ls-files -z`.split("\x0").reject{ |f| f.match(%r{^(test|spec|features)/}) }
	spec.bindir        = 'bin'
	spec.executables   = ['osp']
	spec.require_paths = ['lib']
	spec.required_ruby_version = '>=2.1.0'
	
	spec.add_development_dependency 'minitest', '~>5.8'
	spec.add_development_dependency 'simplecov', '~>0.12'
	spec.add_development_dependency 'simplecov-phpunit', '~>1.0'
	
	spec.add_dependency 'highline', '~>1.7'
	spec.add_dependency 'msgpack', '~>0.7'
	
	spec.add_dependency 'thefox-ext', '~>1.2'
end
