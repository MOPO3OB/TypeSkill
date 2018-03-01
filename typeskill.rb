#!/usr/bin/env ruby
require 'optparse'
require 'rbconfig'

@version = '1.0.0'
@typeskill = File.basename(__FILE__)

@os = (
	host_os = RbConfig::CONFIG['host_os']
	case host_os
	when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
		:windows
	when /darwin|mac os/
		:macos
	when /linux/
		:linux
	when /solaris|bsd/
		:unix
	else
		error 1, host_os.inspect
	end
)

require_relative 'strings'

def error(errorcode, clarification=nil)
	print "#{@strings[:error][:head]} #{errorcode}: "
	message = @strings[:error][:messages][errorcode-1]
	if clarification != nil
		message.sub! '$clarification$', clarification
	end
	puts "#{message}\n#{@strings[:error][:body]}"
	exit errorcode
end

options = {}

optparse = OptionParser.new do|opts|
	opts.banner = @strings[:help][:banner]

	options[:colored] = true
	opts.on( '-c', '--color', @strings[:help][:colored] ) do
		options[:colored] = false
	end

	options[:backspace] = false
	opts.on( '-b', '--backspace', @strings[:help][:backspace] ) do
		options[:backspace] = true
	end

	options[:delete] = false
	opts.on( '-d', '--delete', @strings[:help][:delete] ) do
		options[:delete] = true
	end

	options[:arrows] = false
	opts.on( '-a', '--arrows', @strings[:help][:arrows] ) do
		options[:arrows] = true
	end

	options[:option] = false
	# opts.on( '-o', '--option', 'Block shortcuts ⌥ ←/⌥ → option with arrows' ) do
	# 	options[:option] = true
	# end

	options[:return] = false
	opts.on( '-r', '--return', @strings[:help][:return] ) do
		options[:return] = true
	end

	opts.on( '-s', '--shortcuts', @strings[:help][:shortcuts] ) do
		puts @strings[:shortcuts]
		exit 0
	end

	opts.on( '-h', '--help', @strings[:help][:help] ) do
		puts opts
		exit 0
	end

	opts.on( '-v', '--version', @strings[:help][:version] ) do
		puts @version
		exit 0
	end

	opts.on( '--about', @strings[:help][:about] ) do
		puts @strings[:about]
		exit 0
	end

	opts.on( '--changelog', @strings[:help][:changelog] ) do
		puts @strings[:changelog]
		exit 0
	end
end

begin
	optparse.parse!

	if ARGV[0] == nil
		error 3
	else
		require_relative 'core.rb'

		core ARGV[0], options[:colored], options[:backspace], options[:delete], options[:arrows], options[:option], options[:return]
	end

	rescue OptionParser::InvalidOption, OptionParser::MissingArgument
		error 2, $!.to_s[$!.to_s.index(':')+2..$!.to_s.length-1]
	end
