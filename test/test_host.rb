#!/usr/bin/env ruby

require 'minitest/autorun'
require 'osp'


class TestHost < MiniTest::Test
	
	include TheFox::OSP
	
	def test_base
		osp = Host.new
		
		assert_equal('TheFox::OSP::Host', osp.class.to_s)
	end
	
	def test_initialize
		host = Host.new
		
		assert_equal(nil, host.osp)
		assert_equal(1, host.version)
		# assert_equal(, host.created_at)
		# assert_equal(, host.updated_at)
		assert_equal(nil, host.name)
		assert_equal(1, host.generation)
		assert_equal(16, host.length)
		assert_equal(1, host.symbols)
		assert_equal(nil, host.hashes)
		assert_equal(nil, host.password)
	end
	
	def test_osp
		osp = OSP.new('example@example.com', 'test1', 2 ** 10)
		
		host = Host.new
		host.osp = osp
		
		assert_same(osp, host.osp)
	end
	
	def test_osp_exception
		host = Host.new
		assert_raises(ArgumentError){ host.osp = nil }
	end
	
	def test_version
		host = Host.new
		
		host.version = 2
		assert_equal(2, host.version)
		
		host.version = '3'
		assert_equal(3, host.version)
	end
	
	def test_created_at
		host = Host.new
		
		now = DateTime.now
		host.created_at = now
		assert_equal(now, host.created_at)
	end
	
	def test_updated_at
		host = Host.new
		
		now = DateTime.now
		host.updated_at = now
		assert_equal(now, host.updated_at)
	end
	
	def test_name
		host = Host.new
		
		host.name = ''
		assert_equal(nil, host.name)
		
		host.name = 'host1'
		assert_equal('host1', host.name)
	end
	
	def test_generation
		host = Host.new
		
		host.generation = 2
		assert_equal(2, host.generation)
		
		host.generation = '3'
		assert_equal(3, host.generation)
	end
	
	def test_length
		host = Host.new
		
		host.length = 2
		assert_equal(2, host.length)
		
		host.length = '3'
		assert_equal(3, host.length)
	end
	
	def test_symbols
		host = Host.new
		
		host.symbols = 2
		assert_equal(2, host.symbols)
		
		host.symbols = '3'
		assert_equal(3, host.symbols)
	end
	
	def test_hashes
		host = Host.new
		
		host.hashes = nil
		assert_equal(nil, host.hashes)
		
		host.hashes = 2
		assert_equal(2, host.hashes)
		
		host.hashes = '3'
		assert_equal('3', host.hashes)
	end
	
	def test_password
		host = Host.new
		
		host.password = nil
		assert_equal(nil, host.password)
		
		host.password = 2
		assert_equal(2, host.password)
		
		host.password = '3'
		assert_equal('3', host.password)
	end
	
end
