
module TheFox
	module OSP
		
		class Host
			
			# attr_accessor :osp
			# attr_accessor :version
			attr_accessor :created_at
			attr_accessor :updated_at
			# attr_accessor :name
			# attr_accessor :generation
			# attr_accessor :length
			# attr_accessor :symbols
			# attr_accessor :hashes
			# attr_accessor :password
			
			def initialize(osp = nil)
				@osp = osp
				
				@version = 1
				@created_at = DateTime.now
				@updated_at = DateTime.now
				
				@name = nil
				@generation = 1
				@length = 16
				@symbols = 1
				@hashes = !@osp.nil? ? @osp.hashes : nil
				@password = nil
			end
			
			def osp=(v)
				raise ArgumentError, 'Wrong type.' if !v.is_a?(TheFox::OSP::OSP)
				
				@osp = v
			end
			
			def osp
				@osp
			end
			
			def version=(v)
				@version = v.to_i
			end
			
			def version
				@version.to_i
			end
			
			# def created_at=(v)
			# 	@created_at = v
			# end
			
			# def created_at
			# 	@created_at
			# end
			
			def name=(v)
				v = nil if v == ''
				@name = v
			end
			
			def name
				@name
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
			
			def hashes
				@hashes
			end
			
			def generate_password(regenerate = false)
				if @password.nil? && !@osp.nil? || regenerate
					# puts "host name: '#{@name}'"
					@password = @osp.password(@name, @length, @generation, @symbols)
				end
			end
			
			def password=(v)
				@password = v
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
					
					#'password' => @password,
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
			