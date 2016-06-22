
module TheFox
	module OSP
		
		class Database
			
			attr_accessor :has_changed
			
			def initialize(file_path, osp)
				@file_path = file_path
				@osp = osp
				@load_callback_method = nil
				@write_callback_method = nil
				@has_changed = false
				
				@data = {
					'meta' => {
						'version' => 1,
						'created_at' => DateTime.now.to_s,
						'updated_at' => DateTime.now.to_s,
					},
					'hosts' => {}
				}
			end
			
			def load_callback_method=(m)
				@load_callback_method = m
			end
			
			def load_callback(*o)
				if !@load_callback_method.nil?
					@load_callback_method.call(*o)
				end
			end
			
			def load
				load_callback(1000, 'Check for existing database file.')
				
				if File.exist?(@file_path)
					load_callback(1050, "Use database file: #{@file_path}")
					
					load_callback(1100, "Read file '#{@file_path}'.")
					db_meta = File.binread(@file_path)
					
					load_callback(1200, 'Process database metadata.')
					db_meta = Base64.strict_decode64(db_meta)
					db_meta = MessagePack.unpack(db_meta)
					
					db_e = Base64.strict_decode64(db_meta['db'])
					mac = OpenSSL::Digest::SHA256.digest(db_e)
					if db_meta['mac'] == mac
						load_callback(1300, 'Setup database decryption.')
						dk_sha256 = OpenSSL::Digest::SHA256.digest(@osp.dk)
						iv = Base64.strict_decode64(db_meta['iv'])
						
						aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
						aes.decrypt
						aes.key = dk_sha256
						aes.iv = iv
						
						begin
							load_callback(1350, 'Decrypt database.')
							db_b64 = aes.update(db_e)
							db_b64 << aes.final
						rescue Exception #=> e
							raise 'Incorrect email and password combination.'
						end
						
						load_callback(1400, 'Build database.')
						@data = MessagePack.unpack(Base64.strict_decode64(db_b64))
						
						@data['hosts'] = @data['hosts'].map{ |name, host|
							host_o = TheFox::OSP::Host.from_h(host)
							host_o.osp = @osp
							[name, host_o]
						}.to_h
						
						load_callback(9000, 'Database startup done.')
					else
						raise 'Database integrity check failed.'
					end
				else
					load_callback(9500, 'Database startup done.')
				end
			end
			
			def write_callback_method=(m)
				@write_callback_method = m
			end
			
			def write_callback(*o)
				@write_callback_method.call(*o) if !@write_callback_method.nil?
			end
			
			def write
				write_callback(1000, 'Check database for changes.')
				
				if @has_changed
					tmp = "#{@file_path}~"
					
					# http://stackoverflow.com/questions/9049789/aes-encryption-key-versus-iv
					# http://keepass.info/help/base/security.html
					# https://gist.github.com/byu/99651
					
					write_callback(1100, 'Make temp database.')
					db_c = @data.clone
					db_c['hosts'] = db_c['hosts'].map{ |name, host| [name, host.clone.to_h] }.to_h
					
					write_callback(1200, 'Setup database encryption.')
					dk_sha256 = OpenSSL::Digest::SHA256.digest(@osp.dk)
					iv = OpenSSL::Cipher::Cipher.new('AES-256-CBC').random_iv
					
					aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
					aes.encrypt
					aes.key = dk_sha256
					aes.iv = iv
					
					write_callback(1250, 'Encrypt database.')
					db_e = aes.update(Base64.strict_encode64(db_c.to_msgpack))
					db_e << aes.final
					
					mac = OpenSSL::Digest::SHA256.digest(db_e)
					
					db_out = {
						'version' => 1,
						'iv' => Base64.strict_encode64(iv),
						'db' => Base64.strict_encode64(db_e),
						'mac' => mac,
					}
					db_out = db_out.to_msgpack
					db_out = Base64.strict_encode64(db_out)
					
					write_callback(1300, "Write temp file to '#{tmp}'.")
					File.write(tmp, 'tmp')
					File.chmod(0600, tmp)
					File.binwrite(tmp, db_out)
					
					backup_dts = Time.now.strftime('%Y%m%d-%H%M%S')
					backup = "#{@file_path}~backup_#{backup_dts}_" + Digest::SHA256.file(tmp).hexdigest[0..7]
					
					write_callback(1350, "Backup temp file to '#{backup}'.")
					File.write(backup, 'tmp')
					File.chmod(0600, backup)
					FileUtils.cp(tmp, backup)
					
					write_callback(1390, "Finally, move temp file to '#{@file_path}'.")
					File.write(@file_path, 'tmp')
					File.chmod(0600, @file_path)
					FileUtils.mv(tmp, @file_path)
					
					@has_changed = false
				else
					write_callback(9500, 'Nothing changed, nothing written.')
				end
			end
			
			def update
				@data['meta']['updated_at'] = DateTime.now.to_s
			end
			
			def hosts
				@data['hosts']
			end
			
			def add_host(host)
				@data['hosts'][host.name] = host
				update
				@has_changed = true
			end
			
			def remove_host(host)
				if @data['hosts'].has_key?(host.name)
					@data['hosts'].delete(host.name)
					update
					@has_changed = true
					true
				else
					false
				end
			end
			
		end
		
	end
end
