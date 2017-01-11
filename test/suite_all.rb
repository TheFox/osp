#!/usr/bin/env ruby

if ENV['COVERAGE'] && ENV['COVERAGE'].to_i != 0
	require 'simplecov'
	require 'simplecov-phpunit'
	
	SimpleCov.formatter = SimpleCov::Formatter::PHPUnit
	SimpleCov.start do
		add_filter 'test'
	end
end

require_relative 'test_dependencies'
require_relative 'test_host'
require_relative 'test_osp'
