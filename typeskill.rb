#!/usr/bin/env ruby
require 'optparse'

Version = '1.0.0'
ThisFile = File.basename(__FILE__)

def error(message, exitcode)
	puts "Error #{exitcode}: #{message}"
	puts "Use #{ThisFile} --help"
	exit exitcode
end

options = {}

optparse = OptionParser.new do|opts|
	opts.banner = "Usage: #{ThisFile} [options] file"

	options[:colored] = false
	opts.on( '-c', '--color', 'Use colored output' ) do
		options[:colored] = true
	end

	options[:backspace] = false
	opts.on( '-b', '--backspace', 'Block ⌫  backspace (use ⌃H instead)' ) do
		options[:backspace] = true
	end

	options[:delete] = false
	opts.on( '-d', '--delete', 'Block ⌦  delete (use ⌃D instead)' ) do
		options[:delete] = true
	end

	options[:arrows] = false
	opts.on( '-a', '--arrows', 'Block ←/→ arrows (use ⌃B/⌃F instead)' ) do
		options[:arrows] = true
	end

	options[:option] = false
	# opts.on( '-o', '--option', 'Block shortcuts ⌥ ←/⌥ → option with arrows' ) do
	# 	options[:option] = true
	# end

	options[:return] = false
	opts.on( '-r', '--return', 'Block ⏎ return (use ⌃J instead)' ) do
		options[:return] = true
	end

	opts.on( '-s', '--shortcuts', 'Show available shortcuts' ) do
		puts "⌃C		Interrupt program execution"
		puts "⌃A		Go to the beginning of line"
		puts "⌃E		Go to the end of line"
		puts "⌃T		Swap 2 characters"
		puts "⌃K		Delete text after the insertion point"
		puts "⌃H or ⌫		Backspace"
		puts "⌃D or ⌦		Delete"
		puts "⌃F or →		Go 1 character forwards"
		puts "⌃B or ←		Go 1 character backwards"
		puts "⌃J or ⏎		Complete line"
		exit 0
	end

	opts.on( '-h', '--help', 'Show this message' ) do
		puts opts
		exit 0
	end

	opts.on( '-v', '--version', 'Show version' ) do
		puts Version
		exit 0
	end

	opts.on( '--about', 'Show about message' ) do
		puts "TypeSkill #{Version}"
		puts "Grind experience in typing skill line!"
		puts "https://github.com/MOPO3OB"
		exit 0
	end

	opts.on( '--changelog', 'Show changelog' ) do
		puts "1.0.0 (27.02.18) - Initial release"
		exit 0
	end
end

begin
	optparse.parse!

	if ARGV[0] == nil
		error "no file specified", 2
	else
		require_relative 'core.rb'

		core ARGV[0], options[:colored], options[:backspace], options[:delete], options[:arrows], options[:option], options[:return]
	end

	rescue OptionParser::InvalidOption, OptionParser::MissingArgument
		error "#{$!.to_s}", 1
	end