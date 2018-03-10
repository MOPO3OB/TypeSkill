case @os
when :macos
	def getChar
		STDIN.echo = false
		STDIN.raw!
		input = STDIN.sysread(8)
		input.force_encoding('UTF-8')
		if !/^\e(.|\n){1,}$/.match(input)
			input = input[0]
		else
			if /^\e(.|\n){0,}\e{1,}/.match(input)
				input = input[0..input[1..input.length-1].index("\e")]	
			end
		end
	ensure
		STDIN.echo = true
		STDIN.cooked!
		return input
	end
when :linux
	stty = `stty -g`
	system("stty -echo raw opost min 0")
	Kernel.at_exit {system "stty #{stty}"}
	def getChar
		input = STDIN.sysread(8)
		input.force_encoding('UTF-8')
		if !/^\e(.|\n){1,}$/.match(input)
			input = input[0]
		else
			if /^\e(.|\n){0,}\e{1,}/.match(input)
				input = input[0..input[1..input.length-1].index("\e")]
			end
		end
		return input
	end
when :windows
	if @console
		begin
			verbose = $VERBOSE
			$VERBOSE = nil
			require 'Win32API'
		ensure
			$VERBOSE = verbose
		end
		begin
			@getwch ||= Win32API.new('msvcrt', '_getwch', [], 'L')
		rescue Exception
			begin
				@getwch ||= Win32API.new('crtdll', '_getwch', [], 'L')
			rescue Exception
				error 8
			end
		ensure
			def getwch; @getwch.call.chr(Encoding::UTF_8) end
		end
		def getChar
			input = getwch
			if ["\u0000", "\u00e0"].include?(input)
				input << getwch
			end
			return input
		end
	else
		STDOUT.sync = true
		stty = `stty -g`
		system("stty raw -echo")
		Kernel.at_exit {system "stty #{stty}"}
		def getChar
			input = STDIN.sysread(16)
			input.force_encoding('UTF-8')
			input.encode!('UTF-8', 'UTF-8', :invalid => :replace, :replace => '')
			if !/^\e(.|\n){1,}$/.match(input) and !input.empty?
				input = input[0]
			else
				if /^\e(.|\n){0,}\e{1,}/.match(input)
					input = input[0..input[1..input.length-1].index("\e")]	
				end
			end
			return input
		end
	end
end

def userInput(width, blockBackspace, blockDelete, blockArrows, blockOption, blockReturn)
	input = ""											# 0..width
	cursor = 1											# 1 - left, width+1 - right
	print "\e[?25h"		# This line prevents from not showing cursor when the cursor was hidden before launch
	interrupted = false

	while true
		char = getChar

		case char
		when "\t"
		when "\u0003"
			interrupted = true
			break
		when "\r"
			if !blockReturn
				break
			end
		when "\n"
			break
		when "\u0014"
			if cursor > 1
				if cursor == input.length + 1
					temp = input[cursor-3]
					input[cursor-3] = input[cursor-2]
					input[cursor-2] = temp
				elsif cursor <= input.length
					temp = input[cursor-2]
					input[cursor-2] = input[cursor-1]
					input[cursor-1] = temp
					cursor = cursor + 1
				end
			end
		when "\u007f"
			if !blockBackspace and cursor > 1
				input.slice!(cursor-2)
				cursor = cursor - 1
			end
		when "\b"
			if cursor > 1
				input.slice!(cursor-2)
				cursor = cursor - 1
			end
		when "\e[3~", "\u00e0S"
			if !blockDelete and cursor <= input.length
				input.slice!(cursor-1)
			end
		when "\u0004"
			if cursor <= input.length
				input.slice!(cursor-1)
			end
		when "\v"
			input.slice!(cursor-1..input.length)
		when "\e[D", "\u00e0K"
			if !blockArrows and cursor > 1
				cursor = cursor - 1
			end
		when "\u0002"
			if cursor > 1
				cursor = cursor - 1
			end
		when "\u0001"
			cursor = 1
		when "\e[C", "\u00e0M"
			if !blockArrows and cursor < input.length + 1
				cursor = cursor + 1
			end
		when "\u0006"
			if cursor < input.length + 1
				cursor = cursor + 1
			end
		when "\u0005"
			cursor = input.length + 1
		when /^.$/
			if input.length < width and char.ord > 31
				input.insert(cursor-1, char)
				cursor = cursor + 1
			end
		end

		print "\e[2K"					# Clears line before printing input

		print "\e[G"					# Goes to the first column before printing input
		print "\e[D" if @console && @windowsVersion == 7			# Fix for windows 7 console

		print input						# Prints input

		if @console && @windowsVersion == 7	# This is a fix for escape sequences when using windows 7 console
			print "\e[#{cursor-1}G"
			print "\e[D" if cursor == 1	# Carriage won't be hidden on console during user's input
		else
			if cursor == width+1		# Hides cursor when it's out of the terminal boundaries
				print "\e[?25l"
			else
				print "\e[?25h"
			end
			print "\e[#{cursor}G"		# Places cursor in it's place
		end
	end									# Line is ready or program is being interrupted
	print "\e[G"						# Returns carriage to the first column for proper output of results
	print "\e[D" if @console && @windowsVersion == 7			# Fix for windows 7 console

	print "\e[?25h" if !@console		# This line prevents from not showing cursor after program was interrupted when the cursor was hidden

	return input, interrupted
end
