
require 'base64'
require 'openssl'
require 'msgpack'
require 'pp'

require 'thefox-ext'

module TheFox
	module OSP
		
		ID = 'TheFox-OSP'
		HASHES_EXP = 24
		HASHES_N = 2 ** HASHES_EXP
		PASSWORD_MIN_SIZE = 8
		PASSWORD_MAX_SIZE = 32
		SYMBOLS = 1
		
		class OSP
			
			attr_accessor :dk
			attr_accessor :hashes
			
			def initialize(email, password, hashes = HASHES_N)
				@email = email
				@password = password
				@hashes = hashes
				@dk = nil
				@password_callback_method = nil
			end
			
			def key_derivation
				# puts "password: #{@password}"
				# puts "email: #{@email}"
				# puts "hashes: #{@hashes}"
				
				@dk = OpenSSL::PKCS5.pbkdf2_hmac(@password, @email, @hashes, 64, OpenSSL::Digest::SHA512.new)
				# pp @dk.length
				# pp @dk.length * 8
				# pp @dk.to_hex
			end
			
			def password(host_name, length = 16, generation = 1, symbols = 1)
				raise ArgumentError, "'host_name' can't be '' or nil" if host_name.nil? || host_name == '' || !host_name
				
				key_derivation if @dk.nil?
				
				pw = nil
				step = 0
				while pw.nil?
					raw = [ID, @email, host_name, generation, step]
					# pp raw
					data = raw.to_msgpack
					hmac_p = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, @dk, data)
					hmac_b64 = Base64.strict_encode64(hmac_p)
					pw = hmac_b64 if is_ok_pw(hmac_b64)
					
					# pp hmac_b64[0..16]
					#sleep 0.1
					
					@password_callback_method.call(step, hmac_b64) if !@password_callback_method.nil?
					step += 1
				end
				
				if symbols > 0
					sub_method = find_method_to_sub(pw)
					#puts "sub_method = #{sub_method}"
					
					_b64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
					
					indices = []
					(0..PASSWORD_MIN_SIZE).each do |n|
						c = pw[n]
						#puts "#{n} = #{c}"
						if c.method(sub_method).call
							indices << n
							if indices.count >= symbols
								break
							end
						end
					end
					
					#pp indices
					
					_map = "`~!@#$%^&*()-_+={}[]|;:,<>.?/"
					_map_len = _map.length
					
					last = 0
					arr = []
					indices.each do |index|
						arr << pw[last...index]
						c = pw[index]
						i = _b64map.index(c)
						x = _map[i % _map_len]
						arr << x
						last = index + 1
						
						#puts "#{index} = '#{c}' '#{i}' '#{x}'    #{last}"
					end
					arr << pw[last..-1]
					#pp arr
					pw = arr.join
				end
				
				#puts "length: #{length}"
				pw[0...length]
			end
			
			def password_callback_method=(m)
				@password_callback_method = m
			end
			
			private
			
			def is_ok_pw(pw)
				caps = 0
				lowers = 0
				digits = 0
				
				(0...PASSWORD_MIN_SIZE).each do |n|
					c = pw[n]
					
					# puts "#{n} = #{c}"
					
					if c.is_digit?
						digits += 1
					elsif c.is_upper?
						caps += 1
					elsif c.is_lower?
						lowers += 1
					else
						return false
					end
				end
				
				bad = lambda { |x| x == 0 || x > 5 }
				
				if bad.call(caps) || bad.call(lowers) || bad.call(digits)
					#puts 'return false'
					return false
				end
				
				(PASSWORD_MIN_SIZE...PASSWORD_MAX_SIZE).each do |n|
					if !pw[n].is_valid?
						return false
					end
				end
				
				true
			end
			
			def find_method_to_sub(pw)
				caps = 0
				lowers = 0
				digits = 0
				
				(0...PASSWORD_MIN_SIZE).each do |n|
					c = pw[n]
					if c.is_digit?
						digits += 1
					elsif c.is_upper?
						caps += 1
					elsif c.is_lower?
						lowers += 1
					end
					
					#puts "#{n} = #{c}   #{digits} #{caps} #{lowers}"
				end
				
				rv = ''
				if lowers >= caps && lowers >= digits then
					rv = 'is_lower?'
				elsif digits > lowers && digits >= caps
					rv = 'is_digit?'
				else
					rv = 'is_upper?'
				end
				#rv = 'is_upper?'
				rv
			end
			
		end
	end
end
