#!/usr/bin/env ruby

require 'bundler/setup'
require 'minitest/autorun'
require 'osp'

class TestOsp < MiniTest::Test
	def test_that_it_has_a_version_number
		refute_nil ::TheFox::OSP::VERSION
	end
	
	def test_base
		osp = TheFox::OSP::OSP.new('example@example.com', 'test1', 2 ** 10)
		
		assert_equal('TheFox::OSP::OSP', osp.class.to_s)
	end
	
	def test_hashes
		osp = TheFox::OSP::OSP.new('example@example.com', 'test1', 2 ** 10)
		assert_equal(2 ** 10, osp.hashes)
		
		osp = TheFox::OSP::OSP.new('example@example.com', 'test1', 2 ** 20)
		assert_equal(2 ** 20, osp.hashes)
	end
	
	def test_password1
		osp = TheFox::OSP::OSPDotCom.new('example@example.com', 'test1', 2 ** 10)
		osp.key_derivation
		
		assert_equal('TA24hNn0', osp.password('host1', 8, 1, 0))
		assert_equal('TA>4hNn0', osp.password('host1', 8, 1, 1))
		assert_equal('TA>?hNn0', osp.password('host1', 8, 1, 2))
		assert_equal('TA>?hNn,', osp.password('host1', 8, 1, 3))
		
		assert_equal('DHKzN7uY', osp.password('host2', 8, 1, 0))
		assert_equal('@HKzN7uY', osp.password('host2', 8, 1, 1))
		assert_equal('@^KzN7uY', osp.password('host2', 8, 1, 2))
		assert_equal('@^(zN7uY', osp.password('host2', 8, 1, 3))
		
		assert_equal('Qf4lvgE7', osp.password('host3', 8, 1, 0))
		assert_equal('Q!4lvgE7', osp.password('host3', 8, 1, 1))
		assert_equal('Q!4&vgE7', osp.password('host3', 8, 1, 2))
		assert_equal('Q!4&[gE7', osp.password('host3', 8, 1, 3))
		
		assert_equal('DHKzN7uYUBc3l0wi', osp.password('host2', 16, 1, 0))
		assert_equal('@HKzN7uYUBc3l0wi', osp.password('host2', 16, 1, 1))
		assert_equal('@^KzN7uYUBc3l0wi', osp.password('host2', 16, 1, 2))
		assert_equal('@^(zN7uYUBc3l0wi', osp.password('host2', 16, 1, 3))
		
		assert_equal('wU0t38KE4tDQb3c0', osp.password('host2', 16, 2, 0))
		assert_equal('wU,t38KE4tDQb3c0', osp.password('host2', 16, 2, 1))
		assert_equal('wU,t.8KE4tDQb3c0', osp.password('host2', 16, 2, 2))
		assert_equal('wU,t.!KE4tDQb3c0', osp.password('host2', 16, 2, 3))
		
		assert_equal('OezcZk881M3Jxw9Z', osp.password('host2', 16, 3, 0))
		assert_equal('O~zcZk881M3Jxw9Z', osp.password('host2', 16, 3, 1))
		assert_equal('O~:cZk881M3Jxw9Z', osp.password('host2', 16, 3, 2))
		assert_equal('O~:/Zk881M3Jxw9Z', osp.password('host2', 16, 3, 3))
	end
	
	# def test_password2
	# 	#PASSWORD_MIN_SIZE = 8
	# 	#PASSWORD_MAX_SIZE = 16
		
	# 	osp = TheFox::OSP::OSP.new('example@example.com', 'test1', 2 ** 10)
	# 	osp.key_derivation
		
	# 	assert_equal('cXyE2Dq1', osp.password('host1', 8, 1, 0))
	# 	assert_equal('/XyE2Dq1', osp.password('host1', 8, 1, 1))
	# 	assert_equal('/X;E2Dq1', osp.password('host1', 8, 1, 2))
	# 	assert_equal('/X;E2D_1', osp.password('host1', 8, 1, 3))
		
	# 	assert_equal('kT455AIH', osp.password('host2', 8, 1, 0))
	# 	assert_equal('k]455AIH', osp.password('host2', 8, 1, 1))
	# 	assert_equal('k]455`IH', osp.password('host2', 8, 1, 2))
	# 	assert_equal('k]455`&H', osp.password('host2', 8, 1, 3))
		
	# 	assert_equal('RN1vFCCx', osp.password('host3', 8, 1, 0))
	# 	assert_equal('}N1vFCCx', osp.password('host3', 8, 1, 1))
	# 	assert_equal('}_1vFCCx', osp.password('host3', 8, 1, 2))
	# 	assert_equal('}_1v$CCx', osp.password('host3', 8, 1, 3))
		
	# 	assert_equal('kT455AIHkWRmXRN9', osp.password('host2', 16, 1, 0))
	# 	assert_equal('k]455AIHkWRmXRN9', osp.password('host2', 16, 1, 1))
	# 	assert_equal('k]455`IHkWRmXRN9', osp.password('host2', 16, 1, 2))
	# 	assert_equal('k]455`&HkWRmXRN9', osp.password('host2', 16, 1, 3))
		
	# 	assert_equal('SDBNsS7tMF4HjpPz', osp.password('host2', 16, 2, 0))
	# 	assert_equal('[DBNsS7tMF4HjpPz', osp.password('host2', 16, 2, 1))
	# 	assert_equal('[@BNsS7tMF4HjpPz', osp.password('host2', 16, 2, 2))
	# 	assert_equal('[@~NsS7tMF4HjpPz', osp.password('host2', 16, 2, 3))
		
	# 	assert_equal('GZ8SAox0xBvFM9QL', osp.password('host2', 16, 3, 0))
	# 	assert_equal('%Z8SAox0xBvFM9QL', osp.password('host2', 16, 3, 1))
	# 	assert_equal('%>8SAox0xBvFM9QL', osp.password('host2', 16, 3, 2))
	# 	assert_equal('%>8[Aox0xBvFM9QL', osp.password('host2', 16, 3, 3))
	# end
	
	def test_password3
		#PASSWORD_MIN_SIZE = 8
		#PASSWORD_MAX_SIZE = 32
		
		osp = TheFox::OSP::OSP.new('example@example.com', 'test1', 2 ** 10)
		osp.key_derivation
		
		assert_equal('cXyE2Dq1', osp.password('host1', 8, 1, 0))
		assert_equal('/XyE2Dq1', osp.password('host1', 8, 1, 1))
		assert_equal('/X;E2Dq1', osp.password('host1', 8, 1, 2))
		assert_equal('/X;E2D_1', osp.password('host1', 8, 1, 3))
		
		assert_equal('ar7JQegF', osp.password('host2', 8, 1, 0))
		assert_equal('.r7JQegF', osp.password('host2', 8, 1, 1))
		assert_equal('.+7JQegF', osp.password('host2', 8, 1, 2))
		assert_equal('.+7JQ~gF', osp.password('host2', 8, 1, 3))
		
		assert_equal('RN1vFCCx', osp.password('host3', 8, 1, 0))
		assert_equal('}N1vFCCx', osp.password('host3', 8, 1, 1))
		assert_equal('}_1vFCCx', osp.password('host3', 8, 1, 2))
		assert_equal('}_1v$CCx', osp.password('host3', 8, 1, 3))
		
		assert_equal('ar7JQegFyBk737gQ', osp.password('host2', 16, 1, 0))
		assert_equal('.r7JQegFyBk737gQ', osp.password('host2', 16, 1, 1))
		assert_equal('.+7JQegFyBk737gQ', osp.password('host2', 16, 1, 2))
		assert_equal('.+7JQ~gFyBk737gQ', osp.password('host2', 16, 1, 3))
		
		assert_equal('E3uJvG0rGFKwgpHD', osp.password('host2', 16, 2, 0))
		assert_equal('E3}JvG0rGFKwgpHD', osp.password('host2', 16, 2, 1))
		assert_equal('E3}J[G0rGFKwgpHD', osp.password('host2', 16, 2, 2))
		assert_equal('E3}J[G0+GFKwgpHD', osp.password('host2', 16, 2, 3))
		
		assert_equal('7p51OI3QRAKGUcUc', osp.password('host2', 16, 3, 0))
		assert_equal('~p51OI3QRAKGUcUc', osp.password('host2', 16, 3, 1))
		assert_equal('~p/1OI3QRAKGUcUc', osp.password('host2', 16, 3, 2))
		assert_equal('~p/<OI3QRAKGUcUc', osp.password('host2', 16, 3, 3))
	end
end
