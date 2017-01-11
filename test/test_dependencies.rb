#!/usr/bin/env ruby

require 'minitest/autorun'

class TestDependencies < MiniTest::Test
	
	def test_openssl
		# @deprecated OpenSSL::Cipher::Cipher since Ruby 2.4.0
		#OpenSSL::Cipher::Cipher.new('AES-256-CBC')
		
		OpenSSL::Digest::SHA256.digest('test')
	end
	
end
