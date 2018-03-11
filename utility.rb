module HashRecursive
	refine Hash do
		def merge(other_hash, recursive=false, &block)
			if recursive
				block_actual = Proc.new { |key, oldval, newval|
					newval = block.call(key, oldval, newval) if block_given?
					[oldval, newval].all? { |v| v.is_a?(Hash) } ? oldval.merge(newval, &block_actual) : newval
				}
				self.merge(other_hash, &block_actual)
			else
				super(other_hash, &block)
			end
		end
		def merge!(other_hash, recursive=false, &block)
			if recursive
				self.replace(self.merge(other_hash, recursive, &block))
			else
				super(other_hash, &block)
			end
		end
		def each(recursive=false, &block)
			if recursive
				Enumerator.new do |yielder|
					self.map do |key, value|
						value.each(recursive).map{ |key_next, value_next|
							yielder << [[key, key_next].flatten, value_next]
						} if value.is_a?(Hash)
						yielder << [[key], value]
					end
				end.entries.each(&block)
			else
				super(&block)
			end
		end
		alias_method(:each_pair, :each)
		def dig(*keychain)
			value = self[keychain.shift]
			keychain.empty? ? value : value.dig(*keychain)
		end unless method_defined?(:dig)
		def [](keychain, recursive=false)
			recursive && keychain.is_a?(Array) ? dig(*keychain) : super(keychain)
		end
		def []=(keychain, recursive=false, value)
			if recursive && keychain.is_a?(Array)
				key = keychain.pop
				if keychain.empty?
					self[key] = value
				else
					self[keychain, recursive] = self.dig(*keychain).merge(key => value)
				end
			else
				super(keychain, value)
			end
		end
	end
end

def error(errorcode, clarification=nil)
	print "#{@strings[:error][:head]} #{errorcode}: "
	message = @strings[:error][:messages][errorcode-1]
	if clarification != nil
		message.sub! '$clarification$', clarification
	end
	print "#{message}\n#{@strings[:error][:body]}"
	puts if @os != :windows
	exit errorcode
end

def determineWindowsConsole()
	@console = false
	@console = STDOUT.isatty if @os == :windows
end

def determineWindowsVersion()
	ver = (/(\d|\s)\d\.\d[^\d]/).match(`ver`)
	if ver != nil
		@windowsVersion = case ver[0].to_f
		when 4.0
			95
		when 5.1, 5.2
			'XP'
		when 6.0
			'Vista'
		when 6.1
			7
		when 6.2
			8
		when 6.3
			8.1
		when 10.0
			10
		else
			error 10, ver[0]
		end
	else
		error 9
	end
end

def determineOS()
	require 'rbconfig'
	os = RbConfig::CONFIG['host_os']
	@os = case os
	when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
		determineWindowsConsole()
		determineWindowsVersion()
		:windows
	when /darwin|mac os/
		:macos
	when /linux/
		:linux
	when /solaris|bsd/
		:unix
	else
		error 1, os.inspect
	end
end

def checkFile(file)
	if !File.exist?(file)
		error 4, file.inspect
	elsif !File.file?(file)
		error 5, file.inspect
	elsif !File.readable?(file)
		error 6, file.inspect
	elsif File.zero?(file)
		error 7, file.inspect
	else
		return true
	end
end