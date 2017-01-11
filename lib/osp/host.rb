
require 'date'

module TheFox
	module OSP
		
		class Host
			
			attr_accessor :created_at
			attr_accessor :updated_at
			attr_reader :osp
			attr_reader :name
			attr_reader :hashes
			attr_writer :password
			
			def initialize(osp = nil)
				@osp = osp
				
				@version = 1
				@created_at = DateTime.now
				@updated_at = DateTime.now
				
				@name = nil
				@generation = 1
				@length = 16
				@symbols = 1
				@hashes = @osp.nil? ? nil : @osp.hashes
				@password = nil
			end
			
			def osp=(v)
				if !v.is_a?(OSP)
					raise ArgumentError, "Wrong type -- #{v.class}"
				end
				
				@osp = v
			end
			
			def version=(v)
				@version = v.to_i
			end
			
			def version
				@version.to_i
			end
			
			def name=(v)
				@name = v == '' ? nil : v
			end
			
			def generation=(v)
				@generation = v.to_i
			end
			
			def generation
				@generation.to_i
			end
			
			def length=(v)
				@length = v.to_i
			end
			
			def length
				@length.to_i
			end
			
			def symbols=(v)
				@symbols = v.to_i
			end
			
			def symbols
				@symbols.to_i
			end
			
			def hashes=(v)
				@hashes = v
			end
			
			def generate_password(regenerate = false)
				if @password.nil? && !@osp.nil? || regenerate
					@password = @osp.password(@name, @length, @generation, @symbols)
				end
			end
			
			def password
				generate_password
				@password
			end
			
			def has_generated_password?
				!@password.nil?
			end
			
			def to_h
				{
					'version' => @version,
					'created_at' => @created_at.to_s,
					
					'name' => @name,
					'generation' => @generation,
					'length' => @length,
					'symbols' => @symbols,
					'hashes' => @hashes,
				}
			end
			
			def self.from_h(host)
				h = self.new
				host.each do |k, v|
					h.method("#{k}=").call(v)
				end
				h
			end
			
		end
	end
end
