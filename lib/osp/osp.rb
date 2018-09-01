
require 'base64'
require 'openssl'
require 'msgpack'
require 'thefox-ext'

module TheFox
  module OSP
    
    class OSP
      
      ID = 'TheFox-OSP'
      HASHES_EXP = 24
      HASHES_N = 2 ** HASHES_EXP
      PASSWORD_MIN_SIZE = 8
      PASSWORD_MAX_SIZE = 32
      SYMBOLS = 1
      
      attr_accessor :dk
      attr_accessor :hashes
      
      def initialize(email, password, hashes = self.class::HASHES_N)
        @email = email
        @password = password
        @hashes = hashes
        @dk = nil
        @password_callback_method = nil
      end
      
      def key_derivation
        @dk = OpenSSL::PKCS5.pbkdf2_hmac(@password, @email, @hashes, 64, OpenSSL::Digest::SHA512.new)
      end
      
      def password(host_name, length = 16, generation = 1, symbols_n = self.class::SYMBOLS)
        if length < PASSWORD_MIN_SIZE
          raise RangeError, 'Invalid password length: %d. Minimum length is %d.' % [length, PASSWORD_MIN_SIZE]
        end
        if length > PASSWORD_MAX_SIZE
          raise RangeError, 'Invalid password length: %d. Maximum length is %d.' % [length, PASSWORD_MAX_SIZE]
        end
        if host_name.nil? || host_name == '' || !host_name
          raise ArgumentError, "'host_name' can't be '' or nil"
        end
        
        if @dk.nil?
          key_derivation
        end
        
        password_s = find_password(host_name, generation)
        
        if symbols_n > 0
          password_s = find_symbols(password_s, symbols_n)
        end
        
        password_s[0...length]
      end
      
      def password_callback_method=(m)
        @password_callback_method = m
      end
      
      private
      
      def find_password(host_name, generation)
        password_s = nil
        step = 0
        while password_s.nil?
          raw = [self.class::ID, @email, host_name, generation, step]
          data = raw.to_msgpack
          hmac_p = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA512.new, @dk, data)
          hmac_b64 = Base64.strict_encode64(hmac_p)
          if is_password_ok(hmac_b64)
            password_s = hmac_b64
          end
          
          if not @password_callback_method.nil?
            @password_callback_method.call(step, hmac_b64)
          end
          step += 1
        end
        
        password_s
      end
      
      def find_symbols(password_s, symbols_n)
        sub_method = find_method_to_sub(password_s)
        
        _b64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
        
        indices = Array.new
        (0..self.class::PASSWORD_MIN_SIZE).each do |n|
          c = password_s[n]
          if c.method(sub_method).call
            indices << n
            if indices.count >= symbols_n
              break
            end
          end
        end
        
        _map = "`~!@#$%^&*()-_+={}[]|;:,<>.?/"
        _map_len = _map.length
        
        last = 0
        arr = Array.new
        indices.each do |index|
          arr << password_s[last...index]
          c = password_s[index]
          i = _b64map.index(c)
          x = _map[i % _map_len]
          arr << x
          last = index + 1
        end
        arr << password_s[last..-1]
        
        arr.join
      end
      
      def is_password_ok(password_s)
        caps = 0
        lowers = 0
        digits = 0
        
        (0...self.class::PASSWORD_MIN_SIZE).each do |n|
          c = password_s[n]
          
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
          return false
        end
        
        (self.class::PASSWORD_MIN_SIZE...self.class::PASSWORD_MAX_SIZE).each do |n|
          if not password_s[n].is_valid?
            return false
          end
        end
        
        true
      end
      
      def find_method_to_sub(password_s)
        caps = 0
        lowers = 0
        digits = 0
        
        (0...self.class::PASSWORD_MIN_SIZE).each do |n|
          c = password_s[n]
          if c.is_digit?
            digits += 1
          elsif c.is_upper?
            caps += 1
          elsif c.is_lower?
            lowers += 1
          end
        end
        
        if lowers >= caps && lowers >= digits then
          'is_lower?'
        elsif digits > lowers && digits >= caps
          'is_digit?'
        else
          'is_upper?'
        end
      end
      
    end
  end
end
